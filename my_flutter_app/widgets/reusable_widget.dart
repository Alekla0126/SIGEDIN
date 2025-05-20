import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String text;
  const ReusableWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
