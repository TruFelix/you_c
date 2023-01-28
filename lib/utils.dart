import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension PaddingExtension on Iterable<Widget> {
  List<Padding> padded([EdgeInsets padding = const EdgeInsets.all(4)]) {
    return map((e) => Padding(
          padding: padding,
          child: e,
        )).toList();
  }
}

extension MaterialStateExtension<T> on T {
  MaterialStateProperty get asState => MaterialStateProperty.all(this);
}
