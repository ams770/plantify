import 'package:flutter/widgets.dart';

import 'constants.dart';

extension NonNullString on String? {


  bool get isValidEmail=> RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this??"");


  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInt on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension NonNullDouble on double? {
  double orZero() {
    if (this == null) {
      return Constants.zeroD;
    } else {
      return this!;
    }
  }
}

extension NonNullBool on bool? {
  bool orFalse() {
    if (this == null) {
      return false;
    } else {
      return this!;
    }
  }
}

extension NumBox on num {
  Widget get height => SizedBox(height: this as double);
  Widget get width => SizedBox(width: this as double);

}
