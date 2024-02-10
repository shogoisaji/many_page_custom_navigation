import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:many_page_custom_navigation/state.dart';

final List<String> pageList = ['Page first', 'Page second', 'Page third', 'Page fourth', 'Page fifth'];

class HomePage extends HookConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final slideValue = useState(0.0);
    final slideValue = ref.watch(slideValueProvider);

    var matrix = Matrix4.identity()..rotateX(slideValue * math.pi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Many Page Nav Demo'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 300,
                child: Align(
                  child: Transform(
                    transform: matrix,
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.topCenter,
                      color: Colors.blue,
                      child: Text(
                        'Transform\nObject',
                        style: TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Text('slide value : ${slideValue.toStringAsFixed(2)}')),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              //
            },
            child: const Text('Reset'),
          ),
          const SizedBox(height: 32.0),
          CustomSlider(),
        ],
      ),
    );
  }

  // Widget _buildSlider(String label, double value, Function(double) onChanged) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: SizedBox(
  //       width: 200,
  //       child: Column(
  //         children: <Widget>[
  //           Text(label),
  //           RotatedBox(
  //             quarterTurns: 3, // 270度回転させる（時計回り）
  //             child: Slider(
  //               min: 0,
  //               max: pageList.length.toDouble() - 1,
  //               divisions: pageList.length - 1,
  //               value: value,
  //               onChanged: onChanged,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class CustomSlider extends HookConsumerWidget {
  CustomSlider({
    super.key,
  });

  @override
  build(BuildContext context, WidgetRef ref) {
    final double height = 200;
    final double width = 50.0;
    final double paddingValue = 5.0;
    final double toggleWidth = width - paddingValue * 2;

    final _animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    final _dragPositionY = useState(0.0);

    void _resetToggle() {
      _animationController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      _dragPositionY.value = _animationController.value * 110;
    }

    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.green,
        ),
        child: Stack(
          children: [
            Positioned(
              top: paddingValue,
              left: paddingValue,
              child: Container(
                width: width - paddingValue * 2,
                height: height - paddingValue * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: -0.1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: paddingValue + _dragPositionY.value,
              left: paddingValue,
              child: Container(
                width: toggleWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      spreadRadius: 0.5,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Container(
                  width: width - paddingValue * 2,
                  height: width - paddingValue * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: -0.1,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: paddingValue + _dragPositionY.value,
              left: paddingValue,
              child: Draggable(
                onDragEnd: (details) async {
                  print('onDragEnd');
                  _resetToggle();
                },
                onDragUpdate: (details) {
                  _animationController.value = _dragPositionY.value / 110;
                  _dragPositionY.value += details.delta.dy;
                  if (_dragPositionY.value < 0) {
                    _dragPositionY.value = 0;
                  } else if (_dragPositionY.value > height - paddingValue * 2 - toggleWidth) {
                    _dragPositionY.value = height - paddingValue * 2 - toggleWidth;
                  }
                  ref
                      .read(slideValueProvider.notifier)
                      .setValue(_dragPositionY.value / ((height - paddingValue * 2) / pageList.length));
                },
                feedback: Container(
                  width: toggleWidth,
                  height: toggleWidth,
                  color: Colors.transparent,
                ),
                child: Container(
                  width: toggleWidth,
                  height: toggleWidth,
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ));
  }
}
