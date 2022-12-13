import 'package:flutter/material.dart';
import 'package:todo/utils/theme.dart';

class AButton extends StatelessWidget {
  const AButton({required this.label, required this.onTap});
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: primaryClr),
        height: 50,
        width: 150,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
