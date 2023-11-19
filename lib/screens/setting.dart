import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/buttons/theme_button_widget.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:provider/provider.dart';
import '../DATABASE/playlistDb.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context).theme == darkThemeMode;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // body: Column(
      //   children: [
      //     const SizedBox(
      //       height: 70,
      //     ),
      //     Center(
      //       child: InkWell(
      //         overlayColor: MaterialStateProperty.all(Colors.transparent),
      //         splashColor: Colors.transparent,
      //         onTap: () {
      //           Navigator.pushNamed(context, '/about');
      //         },
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.contact_page,
      //               color: Theme.of(context).cardColor,
      //             ),
      //             Text(
      //               "About",
      //               style: TextStyle(
      //                 fontSize: 20,
      //                 color: Theme.of(context).cardColor,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 30,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Center(
      //           child: InkWell(
      //             overlayColor: MaterialStateProperty.all(Colors.transparent),
      //             splashColor: Colors.transparent,
      //             onTap: () {
      //                Navigator.pushNamed(context, '/privacyPage');
      //             },
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.lock,
      //                   color: Theme.of(context).cardColor,
      //                 ),
      //                 Text(
      //                   "Privacy Policy",
      //                   style: TextStyle(
      //                     fontSize: 20,
      //                     color: Theme.of(context).cardColor,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     const SizedBox(
      //       height: 30,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Center(
      //           child: InkWell(
      //             overlayColor: MaterialStateProperty.all(Colors.transparent),
      //             splashColor: Colors.transparent,
      //             onTap: () {
      //               showPlaylistDeleteDialogue(
      //                   context: context,
      //                   text1: "Do you really want to Reset Moz Music ?",
      //                   onPress: () {
      //                     PlayListDB.resetAPP(context);
      //                     GetSongs.player.stop();
      //                   });
      //             },
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.refresh,
      //                   color: Theme.of(context).cardColor,
      //                 ),
      //                 Text(
      //                   "Tap To Reset",
      //                   style: TextStyle(
      //                     fontSize: 20,
      //                     color: Theme.of(context).cardColor,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     ListTile(
      //       title: Text("Theme Mode"),
      //       leading: Icon(darkMode ? Icons.dark_mode:Icons.light_mode),
      //       subtitle: Text(darkMode ? 'darkMode':'lightMode'),
      //     ),
      //     const SizedBox(
      //       height: 30,
      //     ),
      //     Text(
      //       '''make sure that you are using
      //        the latest version of moz music'''
      //           .toUpperCase(),
      //       style: TextStyle(
      //         fontSize: 10,
      //         color: Colors.grey[400],
      //       ),
      //     ),
      //   ],
      // ),

      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height - 50,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.deepPurple[300]!.withOpacity(.3),
                            Colors.deepPurple[500]!.withOpacity(.5),
                            // Theme.of(context).scaffoldBackgroundColor,
                            // Theme.of(context).scaffoldBackgroundColor,
                          ].cast(),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: darkMode
                                  ? Color.fromARGB(114, 191, 114, 196)
                                  : Theme.of(context).primaryColorDark,
                              offset: const Offset(-8, 8),
                              blurRadius: darkMode ? 6 : 7,
                              spreadRadius: -5),
                          BoxShadow(
                              color: darkMode
                                  ? Color.fromARGB(255, 17, 17, 17)
                                  : Theme.of(context).primaryColorLight,
                              offset: const Offset(7, -7),
                              blurRadius: darkMode ? 15 : 7,
                              spreadRadius: -5),
                        ]),
                    margin:
                        EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Theme Mode",
                          style: TextStyle(
                              shadows: const [
                                BoxShadow(
                                  color: Color.fromARGB(90, 63, 63, 63),
                                  blurRadius: 15,
                                  offset: Offset(-2, 2),
                                ),
                              ],
                              fontSize: 23,
                              fontFamily: 'rounder',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).cardColor),
                        ),
                        Text(
                          darkMode ? "DarkMode" : "LightMode",
                          style: TextStyle(
                            letterSpacing: 1,
                            fontFamily: "appollo",
                            fontSize: 14,
                            color: darkMode
                                ? Colors.grey
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ChangeThemeButtonWidget(
                          changeICon: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
// Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text(
//                           "Theme Mode",
//                           style: TextStyle(
//                               shadows: const [
//                                 BoxShadow(
//                                   color: Color.fromARGB(90, 63, 63, 63),
//                                   blurRadius: 15,
//                                   offset: Offset(-2, 2),
//                                 ),
//                               ],
//                               fontSize: 23,
//                               fontFamily: 'rounder',
//                               letterSpacing: 1,
//                               fontWeight: FontWeight.w700,
//                               color: Theme.of(context).cardColor),
//                         ),
//                         Text(
//                           darkMode ? "DarkMode" : "LightMode",
//                           style: TextStyle(
//                             letterSpacing: 1,
//                             fontFamily: "appollo",
//                             fontSize: 14,
//                             color: darkMode
//                                 ? Colors.grey
//                                 : Theme.of(context).cardColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         ChangeThemeButtonWidget(
//                           changeICon: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),