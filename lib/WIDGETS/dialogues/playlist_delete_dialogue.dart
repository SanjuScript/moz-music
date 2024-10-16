import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';

void showPlaylistDeleteDialogue({
  required BuildContext context,
  required String text1,
  required void Function() onPress,
  bool isPlaylistPage = false,
  void Function()? rename,
}) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * .8,
              // margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).splashColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      "$text1?",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'beauty',
                        letterSpacing: 1.5,
                        fontSize: 18,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                      if (isPlaylistPage)
                        TextButton(
                          onPressed: rename,
                          child: const Text(
                            'Rename',
                            style: TextStyle(
                              color: Colors.deepPurple,
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
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
