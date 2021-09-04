import 'package:flutter/material.dart';

class ChangelogContent extends StatelessWidget {
  const ChangelogContent({
    required this.version,
    required this.details,
    required this.textStyle
  });

  final String version;
  final List<String> details;
  final TextStyle textStyle;

  static const String bullet = "•";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Version: $version", style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(details.length, (index) => Text(
                "$bullet ${details[index]}",
                style: textStyle.copyWith(
                  fontSize: 16,
                  height: 1.5
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}