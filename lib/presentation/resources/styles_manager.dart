import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, FontWeight fontWeight, Color color, double? height) {
  return TextStyle(
    fontFamily: FontConstants.fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );
}

//REGULAR TEXT STYLE

TextStyle getlightStyle({
  double fontSize = FontSize.s12,
  FontWeight fontWeight = FontWeightManager.light,
  required Color color,
  double? height,
}) {
  return _getTextStyle(
    fontSize,
    fontWeight,
    color,
    height,
  );
}

TextStyle getRegularStyle({
  double fontSize = FontSize.s12,
  FontWeight fontWeight = FontWeightManager.regular,
  required Color color,
  double? height,
}) {
  return _getTextStyle(
    fontSize,
    fontWeight,
    color,
    height,
  );
}

TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  FontWeight fontWeight = FontWeightManager.medium,
  required Color color,
  double? height,
}) {
  return _getTextStyle(
    fontSize,
    fontWeight,
    color,
    height,
  );
}

TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s12,
  FontWeight fontWeight = FontWeightManager.semiBold,
  required Color color,
  double? height,
}) {
  return _getTextStyle(
    fontSize,
    fontWeight,
    color,
    height,
  );
}

TextStyle getBoldStyle({
  double fontSize = FontSize.s12,
  FontWeight fontWeight = FontWeightManager.bold,
  required Color color,
  double? height,
}) {
  return _getTextStyle(
    fontSize,
    fontWeight,
    color,
    height,
  );
}

