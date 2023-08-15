import 'package:flutter/material.dart';
import 'package:music_player/Widgets/buttons/theme_button_widget.dart';
import 'package:provider/provider.dart';
import '../ANIMATION/slide_animation.dart';
import '../COLORS/colors.dart';
import '../DATABASE/most_played.dart';
import '../PROVIDER/theme_class_provider.dart';
import '../SCREENS/playlist/playlist_screen.dart';
import '../screens/about.dart';
import '../SCREENS/favoritepage/favoriteSongLists.dart';
import '../SCREENS/privacy_policy.dart';
import '../SCREENS/search_music_screen.dart';
import '../SCREENS/setting.dart';
import 'bottomsheet/sleep_timer_sheet.dart';

Widget drawerWidget(
    {required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey}) {

  return Drawer(
    child: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.deepPurple[400],
            child: const Center(
              child: Text(
                'M o z  M u s i c ',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 229, 229),
                  fontFamily: 'optica',
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.color_lens_outlined,
                    onTap: () {},
                    text: 'Theme Mode',
                    isTrailingVisible: true),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.playlist_play_rounded,
                    onTap: () {
                      navigation(const PlaylistScreen(), context, scaffoldKey);
                    },
                    text: 'Play List'),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.favorite,
                    onTap: () {
                      navigation(const FavoriteScreen(), context, scaffoldKey);
                    },
                    text: 'Favorites'),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.search,
                    onTap: () {
                      navigation(const SearchPage(), context, scaffoldKey);
                    },
                    text: 'Search Music '),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.timer,
                    onTap: () {
                      sleepTimerBottomModalSheet(context);
                    },
                    text: 'Sleep Timer'),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.settings,
                    onTap: () {
                      navigation(const Settings(), context, scaffoldKey);
                    },
                    text: 'Settings'),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.contact_page,
                    onTap: () {
                      navigation(const AboutPage(), context, scaffoldKey);
                    },
                    text: 'About'),
                listDrawerItems(
                    context: context,
                    leadingIcon: Icons.settings,
                    onTap: () {
                      navigation(
                          const PrivacyPolicyPage(), context, scaffoldKey);
                    },
                    text: 'Privacy Policy'),
             
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget themeSetter({
  required BuildContext context,
}) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.red),
  );
}

Widget listDrawerItems(
    {required BuildContext context,
    required IconData leadingIcon,
    required void Function() onTap,
    required String text,
    Widget? trailingIcon,
    bool isTrailingVisible = false}) {
  return ListTile(
    onTap: onTap,
    leading: Icon(
      leadingIcon,
      color: Theme.of(context).cardColor,
    ),
    title: Text(
      text,
      
      style: TextStyle(color: Theme.of(context).cardColor,fontFamily: 'rounder'),
    ),
    trailing: isTrailingVisible
        ? ChangeThemeButtonWidget()
        : trailingIcon,
  );
}

void navigation(Widget child, BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey) async {
  await Navigator.push(
    context,
    SearchAnimationNavigation(child),
  );
  scaffoldKey.currentState?.closeDrawer();
}
