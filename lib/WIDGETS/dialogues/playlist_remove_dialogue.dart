import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteSongDialog extends StatelessWidget {
  final String songTitle;
  void Function() onPress;

  DeleteSongDialog({super.key, required this.songTitle,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'remove Song',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Are you sure you want to delete "$songTitle" from the playlist?',
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: onPress,
                child: Text(
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
    );
  }
}
