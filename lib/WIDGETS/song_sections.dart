import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/ANIMATION/fade_animation.dart';
import 'package:music_player/screens/artists/artists_page.dart';

import '../ANIMATION/slide_animation.dart';
import '../screens/album/album_list.dart';

List<String> texts = [
  "Songs",
  "Albums",
  "Artists",
];
void _navigate({required BuildContext context, required Widget child}) {
  Navigator.push(context, ThisIsFadeRoute(route: child));
}

class SongSections extends StatefulWidget {
  const SongSections({super.key});

  @override
  State<SongSections> createState() => _SongSectionsState();
}

class _SongSectionsState extends State<SongSections>
    with TickerProviderStateMixin {
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onHighlightChanged: (value) {
              setState(() {
                isTap = value;
              });
            },
            onTap: () {
              if (index == 1) {
                _navigate(context: context, child: const AlbumList());
              } else if (index == 2) {
                _navigate(context: context, child: const ArtistList());
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * .3,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Theme.of(context).hoverColor.withOpacity(.2),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        texts[index],
                        maxLines: 2,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontFamily: "beauti",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          color: Theme.of(context).cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
