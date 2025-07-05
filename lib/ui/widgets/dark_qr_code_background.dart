import 'package:flutter/material.dart';

class DarkQrCodeBackground extends StatelessWidget {
  const DarkQrCodeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(height: height / 3, color: Color.fromARGB(150, 0, 0, 0)),
        SizedBox(
          height: height / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                color: Color.fromARGB(150, 0, 0, 0),
                width: (height / 3 - width).abs() / 2,
              ),
              Container(
                width: height / 3,
                decoration: BoxDecoration(color: Colors.transparent),
              ),
              Container(
                color: Color.fromARGB(150, 0, 0, 0),
                width: (height / 3 - width).abs() / 2,
              ),
            ],
          ),
        ),
        Container(height: height / 3, color: Color.fromARGB(150, 0, 0, 0)),
      ],
    );
  }
}
