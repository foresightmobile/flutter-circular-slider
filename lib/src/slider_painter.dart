import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'circular_slider_paint.dart' show CircularSliderMode;
import 'utils.dart';

class SliderPainter extends CustomPainter {
  CircularSliderMode mode;
  double startAngle;
  double endAngle;
  double sweepAngle;
  Color selectionColor;
  Color handlerColor;
  double handlerOutterRadius;
  bool showRoundedCapInSelection;
  bool showHandlerOutter;
  double sliderStrokeWidth;

  Offset initHandler;
  Offset endHandler;
  Offset center;
  double radius;

  SliderPainter({
    @required this.mode,
    @required this.startAngle,
    @required this.endAngle,
    @required this.sweepAngle,
    @required this.selectionColor,
    @required this.handlerColor,
    @required this.handlerOutterRadius,
    @required this.showRoundedCapInSelection,
    @required this.showHandlerOutter,
    @required this.sliderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint progress = _getPaint(color: selectionColor);

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2) - sliderStrokeWidth;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + startAngle, sweepAngle, false, progress);

    Paint handler = _getPaint(color: handlerColor, style: PaintingStyle.fill);
    Paint handlerOutter = _getPaint(color: handlerColor, width: 2.0);

    final sunIcon = Icons.wb_sunny;
    TextPainter sunTextPainter = TextPainter(textDirection: TextDirection.rtl);
    sunTextPainter.text = TextSpan(
        text: String.fromCharCode(sunIcon.codePoint),
        style: TextStyle(fontSize: 20.0, fontFamily: sunIcon.fontFamily));
    sunTextPainter.layout();

    // final sun = Icons.wb_sunny;
    // var sunBuilder = ParagraphBuilder(ParagraphStyle(
    //   fontFamily: sun.fontFamily,
    // ))
    //   ..addText(String.fromCharCode(sun.codePoint));
    // var sunIcon = sunBuilder.build();
    // sunIcon.layout(const ParagraphConstraints(width: 15));
    
    // draw handlers
    if (mode == CircularSliderMode.doubleHandler) {
      initHandler = radiansToCoordinates(center, -pi / 2 + startAngle, radius);
      canvas.drawCircle(initHandler, 8.0, handler);
      canvas.drawCircle(initHandler, handlerOutterRadius, handlerOutter);
      // canvas.drawParagraph(, Offset(initHandler.dx, initHandler.dy + radius + 5));
      sunTextPainter.paint(canvas, Offset(initHandler.dx, initHandler.dy + 10));
    }

    TextPainter moonTextPainter = TextPainter(textDirection: TextDirection.rtl);
    moonTextPainter.text = TextSpan(
        text: String.fromCharCode(FontAwesomeIcons.moon.codePoint),
        style: TextStyle(
            fontSize: 40.0,
            fontFamily: FontAwesomeIcons.moon.fontFamily,
            package: FontAwesomeIcons.moon.fontPackage));
    moonTextPainter.layout();

    // final moon = FontAwesomeIcons.moon;
    // var moonBuilder = ParagraphBuilder(ParagraphStyle(
    //   fontFamily: FontAwesomeIcons.moon.fontFamily,
    // ))..addText(String.fromCharCode(FontAwesomeIcons.moon.codePoint));
    // var moonIcon = moonBuilder.build();
    // moonIcon.layout(const ParagraphConstraints(width: 15));

    endHandler = radiansToCoordinates(center, -pi / 2 + endAngle, radius);
    canvas.drawCircle(endHandler, 8.0, handler);
    if (showHandlerOutter) {
      canvas.drawCircle(endHandler, handlerOutterRadius, handlerOutter);
      moonTextPainter.paint(canvas, Offset(endHandler.dx, endHandler.dy + 10));
      //canvas.drawParagraph(moonIcon, Offset(endHandler.dx, endHandler.dy + radius + 5));
    }
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap =
            showRoundedCapInSelection ? StrokeCap.round : StrokeCap.butt
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? sliderStrokeWidth;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
