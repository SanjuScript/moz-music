import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/WIDGETS/bottomsheet/sleep_timer_sheet.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/main_container_for_settings.dart';
import 'package:music_player/WIDGETS/settings_widget/about_showing.dart';
import 'package:music_player/WIDGETS/settings_widget/privacy_policy_showing.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_text.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_version.dart';
import 'package:music_player/WIDGETS/settings_widget/sleep_timer_showing.dart';
import 'package:music_player/WIDGETS/settings_widget/theme_changing.dart';
import '../../DATABASE/playlistDb.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<Widget> _classItems = [
    const SettingsThememodeChanging(),
    const SettingsAboutShowing(),
    const PrivacypolicyShown(),
    const SleepTimerShowing()
  ];

  static void navtoabout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  static void navtoprivacypolicy(BuildContext context) {
    Navigator.pushNamed(context, '/privacyPage');
  }

  static void controltimer(BuildContext context) {
    sleepTimerBottomModalSheet(context);
  }

  final Map<int, Function(BuildContext)> indexToFunction = {
    1: navtoabout,
    2: navtoprivacypolicy,
    3: controltimer,
  };

  @override
  Widget build(BuildContext context) {
    // bool darkMode = Provider.of<ThemeProvider>(context).theme == darkThemeMode;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _classItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      if (indexToFunction.containsKey(index)) {
                        indexToFunction[index]!(context);
                      }
                    },
                    child: _classItems[index]);
              },
            ),
          ),
          InkWell(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () {
              showPlaylistDeleteDialogue(
                  context: context,
                  text1: "Do you really want to Reset Moz Music ?",
                  onPress: () {
                    PlayListDB.resetAPP(context);
                    MozController.player.stop();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.97,
                child: SettingsContainer(
                  isneeded: true,
                  child: Center(
                    child: singleTextS(context: context, text: 'Reset App'),
                  ),
                ),
              ),
            ),
          ),
          Opacity(
              opacity: .8,
              child: Center(
                  child: singleTexts2(
                      text: 'App Version : $appVersion', context: context))),
        ],
      ),
    );
  }
}
