import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/plan_live_detection.dart';
import '../../domain/models/models.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../resources/helper.dart';

class LiveScanScreen extends StatefulWidget {
  const LiveScanScreen({super.key});

  @override
  State<LiveScanScreen> createState() => _LiveScanScreenState();
}

class _LiveScanScreenState extends State<LiveScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanAnim;
  late final Animation<double> _scanLine;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  void _initPage() {
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLine = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scanAnim, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      if (mounted) AppCubit.get(context).startLiveScan(cameras);
    });
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is LiveScanDetectedState) {
            _scanAnim.stop();
            AppHelpers.showPickedImageDetails(
              context,
              file: state.plantImage,
              prediction: state.result,
              details: state.details,
            );
          } else if (state is LiveScanActiveState) {
            _scanAnim.repeat(reverse: true);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              _CameraPreviewLayer(cubit: AppCubit.get(context)),
              _ScanOverlay(
                scanLine: _scanLine,
                isActive: state is LiveScanActiveState,
              ),
              _TopBar(),
              if (state is LiveScanLoadingState) const _LoadingIndicator(),
              if (state is LiveScanErrorState) _ErrorBanner(state.message),
            ],
          );
        },
      ),
    );
  }
}

// ─── Camera Layer ─────────────────────────────────────────────────────────────

class _CameraPreviewLayer extends StatelessWidget {
  const _CameraPreviewLayer({required this.cubit});

  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    final controller = cubit.cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize!.height,
            height: controller.value.previewSize!.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

// ─── Scan Overlay ─────────────────────────────────────────────────────────────

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay({required this.scanLine, required this.isActive});

  final Animation<double> scanLine;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scanLine,
      builder: (_, __) => CustomPaint(
        painter: _ScanPainter(progress: scanLine.value, isActive: isActive),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({required this.progress, required this.isActive});

  final double progress;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    // Dim background outside the scan box
    final cutout = _scanRect(size);
    final bgPaint = Paint()..color = Colors.black54;
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(12)));
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, holePath),
      bgPaint,
    );

    // Corner brackets
    final bracketPaint = Paint()
      ..color = isActive ? const Color(0xFF4CAF50) : Colors.white54
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const br = 20.0; // bracket length
    const cr = 12.0; // corner radius

    void drawCorner(Offset corner, double xDir, double yDir) {
      final path = Path();
      path.moveTo(corner.dx + xDir * br, corner.dy);
      path.lineTo(corner.dx + xDir * cr, corner.dy);
      path.arcToPoint(
        Offset(corner.dx, corner.dy + yDir * cr),
        radius: const Radius.circular(cr),
        clockwise: xDir * yDir < 0,
      );
      path.lineTo(corner.dx, corner.dy + yDir * br);
      canvas.drawPath(path, bracketPaint);
    }

    drawCorner(cutout.topLeft, 1, 1);
    drawCorner(cutout.topRight, -1, 1);
    drawCorner(cutout.bottomLeft, 1, -1);
    drawCorner(cutout.bottomRight, -1, -1);

    // Scan line
    if (isActive) {
      final scanY = cutout.top + cutout.height * progress;
      final linePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF4CAF50).withOpacity(0.8),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(cutout.left, scanY - 1, cutout.width, 2));
      canvas.drawLine(
        Offset(cutout.left, scanY),
        Offset(cutout.right, scanY),
        linePaint..strokeWidth = 2,
      );
    }
  }

  Rect _scanRect(Size size) {
    const margin = 48.0;
    final side = size.width - margin * 2;
    return Rect.fromLTWH(margin, (size.height - side) / 2, side, side);
  }

  @override
  bool shouldRepaint(_ScanPainter old) =>
      old.progress != progress || old.isActive != isActive;
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

// ─── Loading / Error ──────────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    ),
  );
}
