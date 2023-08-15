import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteSongDialog extends StatelessWidget {
  final String songTitle;
  final void Function() onPress;

  const DeleteSongDialog({Key? key, required this.songTitle, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1), // Slide up from bottom
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOut,
      )),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Remove Song',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Are you sure you want to delete "$songTitle" from the playlist?',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onPress,
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
