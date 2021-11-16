import 'package:example/smooth_corner_debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double radius = kIsWeb ? 100 : 40;
  double smoothness = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 20)),
            Container(
              width: 200,
              height: 200,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: SmoothRectangleBorder(
                    radius: 40,
                    smoothness: smoothness,
                  ),
                ),
                child: Image.network(
                  "https://img1.mydrivers.com/img/20200424/s_cf611107e2d2469fa54b0d8ae2ee5a31.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 20)),
            Container(
              width: kIsWeb ? 500 : 200,
              height: kIsWeb ? 500 : 200,
              decoration: ShapeDecoration(
                shape: SmoothBorderDebug(radius:radius, smoothness: smoothness),
                color: Colors.amber,
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 40)),
            Slider(
              min: 0.0,
              max: 1.0,
              onChanged: (double value) {
                setState(() {
                  smoothness = value;
                });
              },
              value: smoothness,
            ),
            Slider(
              activeColor: Colors.amber,
              min: 0,
              max: kIsWeb ? 250 : 100,
              onChanged: (double value) {
                setState(() {
                  radius = value;
                });
              },
              value: radius,
            )
          ],
        ),
      ),
    );
  }
}
