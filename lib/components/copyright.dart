import 'package:flutter/material.dart';

class Copyright extends StatelessWidget {
  Color labelColor = Colors.black;
  Copyright({super.key, required this.labelColor});

  @override
  Widget build(BuildContext context) {
    var year = DateTime.now().year;
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.copyright_outlined,
              color: labelColor,
              size: 18.0,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Copyright $year',
              style: TextStyle(color: labelColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Powered by',
              style: TextStyle(color: labelColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "images/cklogo.png",
                height: 25,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
