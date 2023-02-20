import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ValueNotifier<List<Path>> notifier = ValueNotifier([]);
  List<Map<String, dynamic>> paths = [];
  Size pageSize = Size.zero;

  void initIcosahedrons() {
    final height = MediaQuery.of(context).size.height - 40;
    final width = MediaQuery.of(context).size.width - 40;
    final size = Size(width, height);
    for (var i = 0; i < 5; i++) {
      final icosahedronPath = icosahedron(size, i);
      final decagonPath = decagon(size, i * 2);
      paths.add(icosahedronPath);
      paths.add(decagonPath);
    }
    notifier = ValueNotifier(paths.map((e) => e['path'] as Path).toList());
    setState(() {});
  }

  void icosahedronsAdd(Offset position) {
    List<Map<String, dynamic>> newPathList = paths;
    for (var element in paths) {
      if (element['path'].contains(position)) {
        newPathList.remove(element);
        final offsets = element['offsets'] as List<Offset>;
        final ab = (offsets.first + offsets[1]) / 2;
        final ac = (offsets.first + offsets[2]) / 2;
        final cb = (offsets[1] + offsets[2]) / 2;
        final path = Path()..addPolygon([ab, ac, cb], true);
        newPathList.add({
          'path': path,
          'offsets': [ab, ac, cb]
        });
        final path1 = Path()..addPolygon([offsets.first, ab, ac], true);
        newPathList.add({
          'path': path1,
          'offsets': [offsets.first, ab, ac]
        });
        final path2 = Path()..addPolygon([offsets[1], ab, cb], true);
        newPathList.add({
          'path': path2,
          'offsets': [offsets[1], ab, cb]
        });
        final path3 = Path()..addPolygon([offsets[2], ac, cb], true);
        newPathList.add({
          'path': path3,
          'offsets': [offsets[2], ac, cb]
        });
        break;
      }
    }
    paths = newPathList;
    notifier = ValueNotifier(paths.map((e) => e['path'] as Path).toList());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double d = size.height > size.width ? size.width - 40 : size.height - 40;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (pageSize != size) {
        paths = [];
        initIcosahedrons();
        pageSize = size;
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(d / 2),
            child: SizedBox(
              height: d,
              width: d,
              child: InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTapDown: (details) {
                  icosahedronsAdd(details.localPosition);
                },
                child: CustomPaint(
                  painter: Icosahedron(notifier),
                  foregroundPainter: CicrularPainter(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> decagon(Size size, int index) {
    var path = Path();

    List<Offset> offsets = [];

    double sides = 10;
    double radius = size.height > size.width ? size.width / 2 : size.height / 2;

    var angle = (pi * 2) / sides;

    Offset center = Offset(radius, radius);

    double dx = radius * cos(angle * index) + center.dx;
    double dy = radius * sin(angle * index) + center.dy;
    path.moveTo(dx, dy);

    offsets.add(Offset(dx, dy));

    for (int i = index + 1; i <= index + 2; i++) {
      double x = radius * cos(angle * i) + center.dx;
      double y = radius * sin(angle * i) + center.dy;
      offsets.add(Offset(x, y));
      path.lineTo(x, y);
    }

    path.close();

    return {'path': path, 'offsets': offsets};
  }

  Map<String, dynamic> icosahedron(Size size, int index) {
    var path = Path();

    List<Offset> offsets = [];

    double sides = 5;
    double radius = size.height > size.width ? size.width / 2 : size.height / 2;
    double radians = 0;

    var angle = (pi * 2) / sides;

    Offset center = Offset(radius, radius);

    double dx = radius * cos(angle * index) + center.dx;
    double dy = radius * sin(angle * index) + center.dy;
    path.moveTo(dx, dy);

    offsets.add(Offset(dx, dy));

    double startX = radius * cos(radians + angle * (index + 1)) + center.dx;
    double startY = radius * sin(radians + angle * (index + 1)) + center.dy;
    path.lineTo(startX, startY);
    offsets.add(Offset(startX, startY));
    path.lineTo(center.dx, center.dy);
    offsets.add(Offset(center.dx, center.dy));
    path.close();

    return {'path': path, 'offsets': offsets};
  }
}

class Icosahedron extends CustomPainter {
  ValueNotifier<List<Path>> notifier;
  Icosahedron(this.notifier) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint();
    painter.color = Colors.green[800]!;
    painter.isAntiAlias = true;
    painter.style = PaintingStyle.stroke;

    for (var path in notifier.value) {
      canvas.drawPath(path, painter);
    }
  }

  @override
  bool shouldRepaint(covariant Icosahedron oldDelegate) => true;
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
