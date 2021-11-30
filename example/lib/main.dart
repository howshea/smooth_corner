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
  double radius = kIsWeb ? 80 : 40;
  double smoothness = 0.6;
  bool topLeftEnable = true;
  bool topRightEnable = true;
  bool bottomLeftEnable = true;
  bool bottomRightEnable = true;

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
            Container(
              width: 200,
              height: 200,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: SmoothRectangleBorder(
                    smoothness: smoothness,
                    borderRadius:
                        BorderRadius.circular(radius * (kIsWeb ? 0.5 : 1)),
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
              width: kIsWeb ? 400 : 200,
              height: kIsWeb ? 400 : 200,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: SmoothBorderDebug(
                  borderRadius: BorderRadius.circular(radius),
                  smoothness: smoothness,
                ),
                color: Colors.amber,
              ),
              child: Text(
                'radius:${radius.toInt()} \nsmooth:${smoothness.toStringAsFixed(2)}',
                style: kIsWeb
                    ? Theme.of(context).textTheme.headline4
                    : Theme.of(context).textTheme.bodyText1,
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
            ),
          ],
        ),
      ),
    );
  }
}
