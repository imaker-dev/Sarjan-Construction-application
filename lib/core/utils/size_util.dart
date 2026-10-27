import 'package:flutter/material.dart';

class SizeUtil {
  SizeUtil._();

  /// Dynamic width as a percentage of screen width (e.g. 50 = 50%)
  static double width(BuildContext context, [double percentage = 100]) =>
      MediaQuery.sizeOf(context).width * (percentage / 100);

  /// Dynamic height as a percentage of screen height (e.g. 20 = 20%)
  static double height(BuildContext context, [double percentage = 100]) =>
      MediaQuery.sizeOf(context).height * (percentage / 100);

  /// Dynamic uniform padding based on screen width percentage
  static EdgeInsets paddingAll(BuildContext context, double percentage) =>
      EdgeInsets.all(width(context, percentage));

  /// Dynamic symmetric padding based on screen width/height percentages
  static EdgeInsets paddingSymmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        horizontal: width(context, horizontal),
        vertical: height(context, vertical),
      );
}

extension SizeExtension on BuildContext {
  double w(double percentage) => SizeUtil.width(this, percentage);
  double h(double percentage) => SizeUtil.height(this, percentage);
  EdgeInsets pAll(double percentage) => SizeUtil.paddingAll(this, percentage);
  EdgeInsets pSymmetric({double h = 0, double v = 0}) =>
      SizeUtil.paddingSymmetric(this, horizontal: h, vertical: v);
}
