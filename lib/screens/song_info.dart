import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/HELPER/get_audio_size_in_mb.dart';
import 'package:music_player/HELPER/minute_converter.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongInfo extends StatefulWidget {
  final String title;
  final String artist;
  final int id;
  final SongModel songs;

  const SongInfo(
      {super.key,
      required this.artist,
      required this.id,
      required this.title,
      required this.songs});

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  List<String> texts = [
    "Duration",
    "Extension",
    "genre",
    "File Size",
    "location",
  ];
  final space = const SizedBox(
    height: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Song Info",
          style: TextStyle(
              color: Theme.of(context).cardColor, fontFamily: 'beauti'),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).cardColor,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            space,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .12,
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: AudioArtworkDefiner(
                      id: widget.id,
                      imgRadius: 15,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(15)),
                        height: MediaQuery.of(context).size.height * .12,
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'beauti',
                                  letterSpacing: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).cardColor),
                            ),
                            const Divider(),
                            Text(
                              widget.artist == "<unknown>"
                                  ? "UNKNOWN"
                                  : widget.artist,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'beauti',
                                  letterSpacing: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).cardColor),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            space,
            Container(
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: texts.length,
                  itemBuilder: (context, index) {
                    File file = File(widget.songs.data);
                    double fileSize = getFileSizeInMB(file);
                    List<String> songs = [
                      "${ToMinutes.stringParseToMinuteSeconds(widget.songs.duration!)} Minutes",
                      widget.songs.fileExtension,
                      widget.songs.genre.toString() == "null"
                          ? "NO GENRE"
                          : widget.songs.genre.toString(),
                      "${fileSize.toStringAsFixed(1)} MB",
                      widget.songs.data
                    ];
                    return Container(
                      height: MediaQuery.of(context).size.width * 0.20,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(15)),
                      width: MediaQuery.of(context).size.width * .8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: Text(
                              texts[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'coolvetica',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Theme.of(context).cardColor.withOpacity(.3),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              songs[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'coolvetica',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
