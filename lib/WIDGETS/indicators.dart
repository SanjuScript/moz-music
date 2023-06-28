import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Widget circleProgress(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color: const Color.fromARGB(255, 67, 160, 71),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}

Widget songEmpty(BuildContext context, String text, void Function() then,{bool isSetting = true}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       isSetting ? TextButton(
            onPressed: () {
              openAppSettings().whenComplete(() {
                then();
              });
            },
            child: const Text("open settings")) : const SizedBox(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
