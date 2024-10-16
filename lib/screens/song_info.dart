import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/get_audio_size_in_mb.dart';
import 'package:music_player/HELPER/minute_converter.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:intl/intl.dart';

class SongInfo extends StatefulWidget {
  const SongInfo({super.key});

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  List<String> texts = [
    "Duration",
    "Extension",
    "Genre",
    "File Size",
    "Location",
    "Added On",
  ];
  final space = const SizedBox(height: 15);

  String formatDate(String path) {
    final file = File(path);
    final dateAdded = file.lastModifiedSync();
    final daysAgo = DateTime.now().difference(dateAdded).inDays;
    return "$daysAgo days ago";
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final SongModel songData = arguments['songs'];
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Stack(
          children: [
            Positioned.fill(
              child: AudioArtworkDefinerForOthers(
                id: songData.id,
                imgRadius: 15,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  color: Theme.of(context).splashColor.withOpacity(0.85),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height * .07,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Song Info",
                      style: TextStyle(
                          shadows: const [
                            BoxShadow(
                              color: Color.fromARGB(90, 63, 63, 63),
                              blurRadius: 15,
                              offset: Offset(-2, 2),
                            ),
                          ],
                          fontSize: 25,
                          fontFamily: 'rounder',
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                SizedBox(
                  width: size.width * 0.87,
                  height: size.height * 0.38,
                  child: AudioArtworkDefinerForOthers(
                    size: 500,
                    id: songData.id,
                    imgRadius: 10,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        songData.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'beauti',
                          letterSpacing: 1,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      const Divider(),
                      Text(
                        songData.artist.toString() == "<unknown>"
                            ? "UNKNOWN"
                            : songData.artist.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'beauti',
                          letterSpacing: 1,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
             
                ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
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
                      songData.data,
                      formatDate(songData.data),
                    ];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).cardColor.withOpacity(.3),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          texts[index],
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontFamily: 'coolvetica',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          songs[index],
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'coolvetica',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
