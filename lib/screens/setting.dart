import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/screens/about.dart';
import 'package:music_player/screens/privacy_policy.dart';
import '../DATABASE/playlistDb.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Center(
            child: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contact_page,
                    color: Theme.of(context).cardColor,
                  ),
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).cardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () {
                     Navigator.pushNamed(context, '/privacyPage');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        color: Theme.of(context).cardColor,
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () {
                    showPlaylistDeleteDialogue(
                        context: context,
                        text1: "Do you really want to Reset Moz Music ?",
                        onPress: () {
                          PlayListDB.resetAPP(context);
                          GetSongs.player.stop();
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Theme.of(context).cardColor,
                      ),
                      Text(
                        "Tap To Reset",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            '''make sure that you are using
             the latest version of moz music'''
                .toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
