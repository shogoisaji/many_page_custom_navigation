import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PinballPage extends StatefulWidget {
  PinballPage({Key? key}) : super(key: key);

  @override
  _PinballPageState createState() => _PinballPageState();
}

class _PinballPageState extends State<PinballPage> {
  double xPosition = 0.0;
  double yPosition = 0.0;
  bool isShow = false;
  String nextRoute = '/home';
  SMIInput<bool>? _isStart;
  SMIInput<double>? _x;
  SMIInput<double>? _y;

  final double STRENGTH = 3;

  @override
  void initState() {
    super.initState();
    accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 150),
    ).listen((event) {
      if (_x == null || _y == null) return;
      _x!.value = (50 - event.x / 9.8 * 50 * STRENGTH).clamp(0, 100);
      _y!.value = (50 - event.y / 9.8 * 50 * STRENGTH * 1.2 + 30).clamp(0, 100);
      navigateCheck(_x!.value, _y!.value);
    });
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    artboard.addController(controller!);
    _isStart = controller.findInput<bool>('isStart') as SMIBool;
    _x = controller.findInput<double>('x') as SMINumber;
    _y = controller.findInput<double>('y') as SMINumber;
  }

  void navigateCheck(double x, double y) {
    if (!_isStart!.value) return;
    if (x == 100) {
      if (y >= 50) {
        print('右上');
        context.go('/list');
        _isStart!.value = false;
      } else {
        print('右下');
        context.go('/settings');
        _isStart!.value = false;
      }
    }
    // 左端に到達したら
    if (x == 0) {
      if (y >= 50) {
        print('左上');
        context.go('/home');
        _isStart!.value = false;
      } else {
        print('左下');
        context.go('/account');
        _isStart!.value = false;
      }
    }
    // 上端に到達したら
    if (y == 100) {
      if (x >= 50) {
        print('右上');
        context.go('/list');
        _isStart!.value = false;
      } else {
        print('左上');
        context.go('/home');
        _isStart!.value = false;
      }
    }
    // 下端に到達したら
    if (y == 0) {
      if (x >= 50) {
        print('右下');
        context.go('/settings');
        _isStart!.value = false;
      } else {
        print('左下');
        context.go('/account');
        _isStart!.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final riveWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             _isStart!.value = false;
        //           });
        //         },
        //         child: const Text('hide'),
        //       ),
        //     ],
        //   ),
        // ),
        // Commented out Sliders as before
        isShow
            ? GestureDetector(
                onTap: () {
                  if (_isStart == null) return;
                  setState(() {
                    _isStart!.value = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.3),
                ),
              )
            : Container(),
        Positioned(
          bottom: 0,
          left: 0,
          child: IgnorePointer(
            ignoring: _isStart != null ? _isStart!.value : false,
            child: SizedBox(
                width: riveWidth,
                height: riveWidth,
                child: RiveAnimation.asset('assets/rive/pinball_nav.riv', fit: BoxFit.contain, onInit: _onRiveInit)),
          ),
        ),
      ],
    );
  }
}
