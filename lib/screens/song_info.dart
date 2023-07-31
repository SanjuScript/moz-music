import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/get_audio_size_in_mb.dart';
import 'package:music_player/HELPER/minute_converter.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongInfo extends StatefulWidget {
  const SongInfo({
    super.key,
  });

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
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = arguments['title'];
    final String artist = arguments['artist'];
    final int id = arguments['id'];
    final SongModel songData = arguments['songs'];

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
                      id: id,
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                title,
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
                                artist == "<unknown>"
                                    ? "UNKNOWN"
                                    : artist,
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
                    File file = File(songData.data);
                    double fileSize = getFileSizeInMB(file);
                    List<String> songs = [
                      "${ToMinutes.stringParseToMinuteSeconds(songData.duration!)} Minutes",
                      songData.fileExtension,
                      songData.genre.toString() == "null"
                          ? "NO GENRE"
                          : songData.genre.toString(),
                      "${fileSize.toStringAsFixed(1)} MB",
                      songData.data
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
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
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
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
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
