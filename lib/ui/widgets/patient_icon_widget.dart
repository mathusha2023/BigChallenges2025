import 'package:flutter/material.dart';

class PatientIconWidget extends StatelessWidget {
  const PatientIconWidget({
    super.key,
    required this.width,
    required this.height,
    this.isMale = true,
  });

  final double width, height;
  final bool isMale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary,
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Image(
          image: AssetImage(
            isMale
                ? "assets/images/male_icon.png"
                : "assets/images/female_icon.png",
          ),
        ),
      ),
    );
  }
}
