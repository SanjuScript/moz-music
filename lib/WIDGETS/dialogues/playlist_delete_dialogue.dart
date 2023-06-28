import 'package:flutter/material.dart';

import '../../COLORS/colors.dart';

void showPlaylistDeleteDialogue({
  required BuildContext context,
  required String text1,
  required void Function() onPress,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Theme(
        data: darkThemeMode.copyWith(
          dialogTheme: Theme.of(context).dialogTheme,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            text1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'beauty',
              letterSpacing: 1.5,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(),
              ),
            ),
            TextButton(
              onPressed: onPress,
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
