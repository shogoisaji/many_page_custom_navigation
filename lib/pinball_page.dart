import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PinballPage extends HookConsumerWidget {
  PinballPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xPosition = useState(50.0);
    final yPosition = useState(50.0);
    SMIInput<bool>? _isStart;
    SMIInput<double>? _x;
    SMIInput<double>? _y;

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

    final riveWidth = MediaQuery.sizeOf(context).width;

    const double GRAVITY = 9.8;
    const double STRENGTH = 3;

    final isShow = useState(false);

    final nextPage = useState('');

    void _hide() {
      if (_isStart == null) {
        return;
      }
      _isStart!.value = false;
      print('hide');
    }

    useEffect(() {
      if (nextPage.value != '') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _hide();
          context.go(nextPage.value);
        });
      }
      return () {};
    }, [nextPage.value]);

    useEffect(
      () {
        // 右端に到達したら
        if (xPosition.value == 100) {
          if (yPosition.value >= 50) {
            print('右上');
            nextPage.value = '/list';
          } else {
            print('右下');
            nextPage.value = '/settings';
          }
        }
        // 左端に到達したら
        if (xPosition.value == 0) {
          if (yPosition.value >= 50) {
            print('左上');
            nextPage.value = '/home';
          } else {
            print('左下');
            nextPage.value = '/account';
          }
        }
        // 上端に到達したら
        if (yPosition.value == 100) {
          if (xPosition.value >= 50) {
            print('右上');
            nextPage.value = '/list';
          } else {
            print('左上');
            nextPage.value = '/home';
          }
        }
        // 下端に到達したら
        if (yPosition.value == 0) {
          if (xPosition.value >= 50) {
            print('右下');
            nextPage.value = '/settings';
          } else {
            print('左下');
            nextPage.value = '/account';
          }
        }
        return () {};
      },
      [xPosition.value, yPosition.value],
    );

    useEffect(() {
      if (_isStart != null && _isStart!.value) {
        accelerometerEventStream(
          samplingPeriod: const Duration(milliseconds: 200),
        ).listen((event) {
          if (_x == null || _y == null) return;
          xPosition.value = (50 - event.x / 9.8 * 50 * STRENGTH).clamp(0, 100);
          yPosition.value = (50 - event.y / 9.8 * 50 * STRENGTH * 1.2 + 30).clamp(0, 100);
          _x!.value = xPosition.value;
          _y!.value = yPosition.value;
        });
      }
      return () {};
    }, [_isStart]);

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_isStart == null) return;
                  _isStart!.value = false;
                },
                child: const Text('hide'),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   width: 500,
        //   height: 100,
        //   child: Slider(
        //     value: xPosition.value,
        //     divisions: 10,
        //     onChanged: (value) {
        //       if (_x == null) return;
        //       xPosition.value = value;
        //       _x!.value = value;
        //     },
        //   ),
        // ),
        // Container(
        //   color: Colors.blue[300],
        //   width: 500,
        //   height: 100,
        //   child: Slider(
        //     min: 0,
        //     max: 100,
        //     value: yPosition.value,
        //     divisions: 10,
        //     onChanged: (value) {
        //       if (_y == null) return;
        //       yPosition.value = value;
        //       _y!.value = value;
        //     },
        //   ),
        // ),
        isShow.value
            ? GestureDetector(
                onTap: () {
                  if (_isStart == null) return;
                  _isStart!.value = false;
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: Colors.black.withOpacity(0.3),
                ),
              )
            : Container(),
        Positioned(
          bottom: 0,
          left: 0,
          child: IgnorePointer(
            ignoring: _isStart == null
                ? false
                : _isStart!.value
                    ? true
                    : false,
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
