// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopAppBar extends StatelessWidget {
  bool isPop;
  bool nxt;
  void Function() iconTap;
  void Function(String) onSelected;
  String firstString;
   bool showImportButton;
  IconData icon;
  String secondString;
  String topString;
  Widget widget;
  TopAppBar(
      {super.key,
      this.isPop = true,
      this.nxt = false,
      this.showImportButton = false,
      required this.iconTap,
      required this.icon,
      required this.onSelected,
      required this.firstString,
      required this.secondString,
      required this.topString,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: iconTap,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    icon,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 35,
                  )),
            ),
            Text(
              topString,
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: "appollo",
                fontSize: 23,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            isPop
                ? PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tooltip: "Clear All",
                    color: Theme.of(context).splashColor,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).cardColor,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'ClearAll',
                            child: Text(
                              "Clear All",
                              style: TextStyle(
                                letterSpacing: 1,
                                fontFamily: "appollo",
                                fontSize: 15,
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if(showImportButton)
                          PopupMenuItem<String>(
                            value: 'import',
                            child: Text(
                              "Import playlist",
                              style: TextStyle(
                                letterSpacing: 1,
                                fontFamily: "appollo",
                                fontSize: 15,
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ) 
                        ],
                    onSelected: onSelected)
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Icon(
                  icon == Icons.favorite_rounded || icon == Icons.album
                      ? Icons.play_circle_rounded
                      : icon == Icons.music_note_rounded
                          ? Icons.play_circle_fill_rounded
                          : Icons.playlist_add_rounded,
                  color: Colors.red[400],
                )),
            Text(
              firstString,
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: "appollo",
                fontSize: 15,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                secondString,
                style: const TextStyle(
                  letterSpacing: 1,
                  fontFamily: "appollo",
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        widget,
        SizedBox(height: nxt ? 100 : 0),
      ],
    );
  }
}
