
import 'package:flutter/material.dart';

Widget permissionCheck({
  required BuildContext context,
  required void Function() reload,
  required bool boolean,
  required void Function() requestPermission,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "MAKE SURE THAT YOU ALLOWED THE PERMISSIONS",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).cardColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: requestPermission,
        child: Text(
          "Tap To Open Settings",
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

