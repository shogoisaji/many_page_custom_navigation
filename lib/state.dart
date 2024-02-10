import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@riverpod
class SlideValue extends _$SlideValue {
  @override
  double build() => 0.0;

  void setValue(double value) => state = value;
}
