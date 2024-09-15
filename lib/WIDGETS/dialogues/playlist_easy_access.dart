import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/ANIMATION/slide_animation.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/WIDGETS/indicators.dart';
import 'package:music_player/screens/playlist/playlist_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistEasyAccess {
  static void show({
    required BuildContext context,
    required List<SongModel> getList,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: CustomThemes.darkThemeMode.copyWith(
            dialogTheme: Theme.of(context).dialogTheme,
          ),
          child: Theme(
            data: CustomThemes.darkThemeMode
                .copyWith(dialogTheme: Theme.of(context).dialogTheme),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Playlists",
                      style: TextStyle(
                        fontFamily: 'coolvetica',
                        fontSize: 20,
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable:
                          Hive.box<MusicModel>('playlistDB').listenable(),
                      builder: (BuildContext context, Box<MusicModel> value,
                          Widget? child) {
                        if (Hive.box<MusicModel>('playlistDB').isEmpty) {
                          return Column(
                            children: [
                              songEmpty(context, "No Playlist Found", () {},
                                  isSetting: false),
                              const SizedBox(height: 16),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    SearchAnimationNavigation(
                                        const PlaylistScreen()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Consumer<NowPlayingProvider>(
                            builder: (context, nowValue, child) {
                              final itemCount = value.length;
                              return SizedBox(
                                height: itemCount > 8
                                    ? 320
                                    : null, // Set a specific height if itemCount > 8
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: itemCount,
                                      itemBuilder: (context, index) {
                                        final data =
                                            value.values.toList()[index];
                                        return Dismissible(
                                          key: Key(data
                                              .name), // Use a unique key for each playlist
                                          direction:
                                              DismissDirection.startToEnd,
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            color: Colors.grey[400]!
                                                .withOpacity(.5),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            value.deleteAt(index);
                                          },
                                          child: ListTile(
                                            title: Text(
                                              data.name.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .unselectedWidgetColor),
                                            ),
                                            trailing: IconButton(
                                              icon: data.isValueIn(getList[
                                                          nowValue.currentIndex]
                                                      .id)
                                                  ? const Icon(Icons.done)
                                                  : const Icon(
                                                      Icons.add_circle),
                                              onPressed: () {
                                                if (!data.isValueIn(getList[
                                                        nowValue.currentIndex]
                                                    .id)) {
                                                  print('data does');
                                                  data.add(getList[
                                                          nowValue.currentIndex]
                                                      .id);
                                                } else {
                                                  print('data doesnt');
                                                  data.deleteData(getList[
                                                          nowValue.currentIndex]
                                                      .id);
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
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
}
