import 'package:flutter/material.dart';
import 'dialogues/playlist_delete_dialogue.dart';

Widget playListadded(
    {required BuildContext context,
    required String playlistName,
    required String deleteText,
    required void Function() delete,
    required void Function() ontap,
    required String data,
    required bool isDoes}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.10,
    width: MediaQuery.of(context).size.width * 0.15,
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          blurRadius: 3,
          offset: const Offset(2, 2),
        ),
        BoxShadow(
          color: Theme.of(context).dividerColor,
          blurRadius: 3,
          offset: const Offset(-2, -2),
        ),
      ],
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
    child: Center(
      child: ListTile(
          leading: Text(
            data.toUpperCase(),
            style: TextStyle(
                color: data.contains("first")
                    ? Colors.green
                    : Theme.of(context).cardColor,
                fontFamily: 'coolvetica'),
          ),
          title: Text(
            playlistName,
            style: TextStyle(
                fontFamily: 'coolvetica',
                fontSize: MediaQuery.of(context).size.height * 0.025,
                letterSpacing: 1.5,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).cardColor),
          ),
          trailing: isDoes
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: Text(
                    "Added",
                    style: TextStyle(
                        fontFamily: 'coolvetica',
                        letterSpacing: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).cardColor),
                  )),
                )
              : Icon(
                  Icons.playlist_add_circle,
                  size: 30,
                  color: Theme.of(context).canvasColor,
                ),
          onLongPress: () {
            showPlaylistDeleteDialogue(
                context: context, text1: deleteText, onPress: delete);
          },
          onTap: ontap),
    ),
  );
}
