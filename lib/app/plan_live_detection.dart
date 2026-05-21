import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantLiveResult {
  const PlantLiveResult({
    required this.index,
    required this.label,
    required this.confidence,
  });

  final int index;
  final String label;
  final double confidence;
}

// ─── Isolate-safe frame data ─────────────────────────────────────────────────
// CameraImage byte buffers may be backed by native (platform) memory that
// becomes invalid once the camera frame callback returns.  We deep-copy every
// plane into a Dart-heap Uint8List so the data survives SendPort transfer.

class _PlaneData {
  const _PlaneData({
    required this.bytes,
    required this.bytesPerRow,
    this.bytesPerPixel,
  });

  final Uint8List bytes;
  final int bytesPerRow;
  final int? bytesPerPixel;
}

class _FrameData {
  const _FrameData({
    required this.width,
    required this.height,
    required this.formatGroup,
    required this.planes,
  });

  final int width;
  final int height;
  final ImageFormatGroup formatGroup;
  final List<_PlaneData> planes;
}

// ─── Protocol ────────────────────────────────────────────────────────────────

enum _Code { init, ready, busy, detect, result }

class _Cmd {
  const _Cmd(this.code, {this.args});
  final _Code code;
  final List<Object?>? args;
}

// ─── Public Service ───────────────────────────────────────────────────────────

class PlantLiveDetectionService {
  PlantLiveDetectionService._({
    required Isolate isolate,
    required ReceivePort receivePort,
    required Interpreter interpreter,
    required List<String> labels,
    required int inputWidth,
    required int inputHeight,
  })  : _isolate = isolate,
        _receivePort = receivePort,
        _interpreter = interpreter,
        _labels = labels,
        _inputWidth = inputWidth,
        _inputHeight = inputHeight;

  static const double confidenceThreshold = 0.85;

  final Isolate _isolate;
  final ReceivePort _receivePort;
  final Interpreter _interpreter;
  final List<String> _labels;
  final int _inputWidth;
  final int _inputHeight;

  late final SendPort _sendPort;
  bool _isReady = false;
  bool _disposed = false;

  final _resultController = StreamController<PlantLiveResult?>.broadcast();
  Stream<PlantLiveResult?> get results => _resultController.stream;

  static Future<PlantLiveDetectionService> start({
    required Interpreter interpreter,
    required List<String> labels,
    required int inputWidth,
    required int inputHeight,
  }) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      _IsolateWorker._run,
      receivePort.sendPort,
    );

    final service = PlantLiveDetectionService._(
      isolate: isolate,
      receivePort: receivePort,
      interpreter: interpreter,
      labels: labels,
      inputWidth: inputWidth,
      inputHeight: inputHeight,
    );

    receivePort.listen((msg) => service._onMessage(msg as _Cmd));
    return service;
  }

  /// Called for each camera frame. Drops frame if isolate is still busy.
  void processFrame(CameraImage frame) {
    if (_disposed) return;
    if (_isReady && !_resultController.isClosed) {
      _isReady = false; // Gate immediately — no queue build-up

      // Deep-copy frame data for safe isolate transfer.
      final frameData = _FrameData(
        width: frame.width,
        height: frame.height,
        formatGroup: frame.format.group,
        planes: frame.planes
            .map(
              (p) => _PlaneData(
                bytes: Uint8List.fromList(p.bytes),
                bytesPerRow: p.bytesPerRow,
                bytesPerPixel: p.bytesPerPixel,
              ),
            )
            .toList(),
      );

      _sendPort.send(_Cmd(_Code.detect, args: [frameData]));
    }
  }

  void _onMessage(_Cmd cmd) {
    if (_disposed) return;
    switch (cmd.code) {
      case _Code.init:
        _sendPort = cmd.args![0] as SendPort;
        _sendPort.send(
          _Cmd(
            _Code.init,
            args: [
              RootIsolateToken.instance!,
              _interpreter.address, // Share by address — no double allocation
              _labels,
              _inputWidth,
              _inputHeight,
              confidenceThreshold,
            ],
          ),
        );
      case _Code.ready:
        _isReady = true;
      case _Code.busy:
        _isReady = false;
      case _Code.result:
        _isReady = true;
        if (!_resultController.isClosed) {
          _resultController.add(cmd.args?[0] as PlantLiveResult?);
        }
      case _Code.detect:
        throw UnimplementedError();
    }
  }

  void dispose() {
    _disposed = true;
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
    if (!_resultController.isClosed) _resultController.close();
  }
}

// ─── Background Isolate ───────────────────────────────────────────────────────

class _IsolateWorker {
  _IsolateWorker(this._sendPort);

  final SendPort _sendPort;

  Interpreter? _interpreter;
  List<String>? _labels;
  int _w = 224, _h = 224;
  double _threshold = 0.85;

  static const double _mean = 127.5;
  static const double _std = 127.5;

  static void _run(SendPort sendPort) {
    final port = ReceivePort();
    final worker = _IsolateWorker(sendPort);
    port.listen((msg) async => worker._handle(msg as _Cmd));
    sendPort.send(_Cmd(_Code.init, args: [port.sendPort]));
  }

  Future<void> _handle(_Cmd cmd) async {
    switch (cmd.code) {
      case _Code.init:
        BackgroundIsolateBinaryMessenger.ensureInitialized(
          cmd.args![0] as RootIsolateToken,
        );
        _interpreter = Interpreter.fromAddress(cmd.args![1] as int);
        _labels = cmd.args![2] as List<String>;
        _w = cmd.args![3] as int;
        _h = cmd.args![4] as int;
        _threshold = cmd.args![5] as double;
        _sendPort.send(const _Cmd(_Code.ready));

      case _Code.detect:
        final image = _toImage(cmd.args![0] as _FrameData);
        _sendPort.send(
          _Cmd(_Code.result, args: [image != null ? _infer(image) : null]),
        );

      default:
        break;
    }
  }

  PlantLiveResult? _infer(image_lib.Image raw) {
    final resized = image_lib.copyResize(raw, width: _w, height: _h);

    final input = [
      List.generate(
        _h,
        (y) => List.generate(_w, (x) {
          final p = resized.getPixel(x, y);
          return [
            (p.r.toDouble() - _mean) / _std,
            (p.g.toDouble() - _mean) / _std,
            (p.b.toDouble() - _mean) / _std,
          ];
        }),
      ),
    ];

    final output = [List<double>.filled(_labels!.length, 0.0)];
    _interpreter!.run(input, output);

    int bestIndex = -1;
    double bestScore = _threshold;
    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > bestScore) {
        bestScore = output[0][i];
        bestIndex = i;
      }
    }

    if (bestIndex == -1) return null;
    return PlantLiveResult(
      index: bestIndex,
      label: _labels![bestIndex],
      confidence: bestScore,
    );
  }

  // ─── Camera Image Conversion ────────────────────────────────────────────────

  image_lib.Image? _toImage(_FrameData frame) {
    try {
      return switch (frame.formatGroup) {
        ImageFormatGroup.yuv420 => _fromYUV420(frame),
        ImageFormatGroup.bgra8888 => _fromBGRA8888(frame),
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }

  image_lib.Image _fromYUV420(_FrameData frame) {
    final yPlane = frame.planes[0];
    final uPlane = frame.planes[1];
    final vPlane = frame.planes[2];
    final result = image_lib.Image(width: frame.width, height: frame.height);

    for (int y = 0; y < frame.height; y++) {
      for (int x = 0; x < frame.width; x++) {
        final yVal = yPlane.bytes[y * yPlane.bytesPerRow + x];
        final uvIndex =
            (y ~/ 2) * uPlane.bytesPerRow +
            (x ~/ 2) * (uPlane.bytesPerPixel ?? 1);
        final u = uPlane.bytes[uvIndex] - 128;
        final v = vPlane.bytes[uvIndex] - 128;

        result.setPixelRgb(
          x,
          y,
          (yVal + 1.402 * v).clamp(0, 255).toInt(),
          (yVal - 0.344136 * u - 0.714136 * v).clamp(0, 255).toInt(),
          (yVal + 1.772 * u).clamp(0, 255).toInt(),
        );
      }
    }
    return result;
  }

  image_lib.Image _fromBGRA8888(_FrameData frame) {
    final plane = frame.planes[0];
    final bytesPerRow = plane.bytesPerRow;
    final width = frame.width;
    final height = frame.height;

    // Fast path: no stride padding
    if (bytesPerRow == width * 4) {
      return image_lib.Image.fromBytes(
        width: width,
        height: height,
        bytes: plane.bytes.buffer,
        order: image_lib.ChannelOrder.bgra,
      );
    }

    // Strip row-stride padding so the image lib reads tightly-packed pixels
    final tightBytes = Uint8List(width * height * 4);
    for (int y = 0; y < height; y++) {
      final srcOffset = y * bytesPerRow;
      final dstOffset = y * width * 4;
      tightBytes.setRange(
        dstOffset,
        dstOffset + width * 4,
        plane.bytes,
        srcOffset,
      );
    }
    return image_lib.Image.fromBytes(
      width: width,
      height: height,
      bytes: tightBytes.buffer,
      order: image_lib.ChannelOrder.bgra,
    );
  }
}
