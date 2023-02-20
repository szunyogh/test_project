import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height - 40;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: SizedBox(
              height: size,
              width: size,
              child: CustomPaint(
                painter: CicrularPainter(),
                foregroundPainter: Icosahedron(),
                child: InkWell(
                  //focusColor: Colors.transparent,
                  //hoverColor: Colors.transparent,
                  //splashColor: Colors.transparent,
                  //highlightColor: Colors.transparent,
                  onTap: () {
                    print("ghukhjm");
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Icosahedron extends CustomPainter {
  Paint painter = Paint();

  Path decagon(Size size, int index) {
    var path = Path();

    double sides = 10;
    double radius = size.height > size.width ? size.width / 2 : size.height / 2;

    var angle = (pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    double dx = radius * cos(angle * index) + center.dx;
    double dy = radius * sin(angle * index) + center.dy;
    path.moveTo(dx, dy);

    for (int i = index + 1; i <= index + 2; i++) {
      double x = radius * cos(angle * i) + center.dx;
      double y = radius * sin(angle * i) + center.dy;
      path.lineTo(x, y);
    }

    path.close();

    return path;
  }

  Path icosahedron(Size size, int index) {
    var path = Path();

    double sides = 5;
    double radius = size.height > size.width ? size.width / 2 : size.height / 2;
    double radians = 0;

    var angle = (pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    double dx = radius * cos(angle * index) + center.dx;
    double dy = radius * sin(angle * index) + center.dy;
    path.moveTo(dx, dy);

    double startX = radius * cos(radians + angle * (index + 1)) + center.dx;
    double startY = radius * sin(radians + angle * (index + 1)) + center.dy;
    path.lineTo(startX, startY);
    path.lineTo(center.dx, center.dy);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = Colors.green[800]!;
    painter.isAntiAlias = true;
    painter.style = PaintingStyle.stroke;

    canvas.drawPath(decagon(size, 0), painter);
    canvas.drawPath(decagon(size, 2), painter);
    canvas.drawPath(decagon(size, 4), painter);
    canvas.drawPath(decagon(size, 6), painter);
    canvas.drawPath(decagon(size, 8), painter);
    canvas.drawPath(icosahedron(size, 0), painter);
    canvas.drawPath(icosahedron(size, 1), painter);
    canvas.drawPath(icosahedron(size, 2), painter);
    canvas.drawPath(icosahedron(size, 3), painter);
    canvas.drawPath(icosahedron(size, 4), painter);
  }

  @override
  bool shouldRepaint(Icosahedron oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(Icosahedron oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    painter.color = Colors.red;
    return true;
  }
}

class CicrularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800]!;
    paint.isAntiAlias = true;
    paint.style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.height > size.width ? size.width / 2 : size.height / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
