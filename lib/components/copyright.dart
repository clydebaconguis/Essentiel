import 'package:flutter/material.dart';

class Copyright extends StatelessWidget {
  const Copyright({super.key});

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
            const Icon(
              Icons.copyright_outlined,
              color: Colors.black,
              size: 18.0,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Copyright $year',
              style: const TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Powered by',
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 8,
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
