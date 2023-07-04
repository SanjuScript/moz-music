import 'package:flutter/material.dart';

void showPlaylistDeleteDialogue({
  required BuildContext context,
  required String text1,
  required void Function() onPress,
  bool isPlaylistPage = false,
  void Function()? rename,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
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
                  if (isPlaylistPage)
                    TextButton(
                      onPressed: rename,
                      child: Text(
                        'Rename',
                        style: TextStyle(
                          color: Colors.indigo[600],
                        ),
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
            ),
          );
        },
      );
    },
  );
}
