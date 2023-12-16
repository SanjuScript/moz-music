import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/main_container_for_settings.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_text.dart';
import 'package:provider/provider.dart';

class PrivacypolicyShown extends StatelessWidget {
  const PrivacypolicyShown({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context).theme == darkThemeMode;

    return SettingsContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          singleTextS(context: context, text: 'Privacy Pact'),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text(
                maxLines:6,
                
                "These terms and conditions outline the rules and regulations for the use of Moz Music Player. By using this app, we assume you accept these terms and conditions. Do not continue to use Moz Music Player if you do not agree to take all of the terms and conditions stated on this page.",
               
              //  textAlign: TextAlign.justify,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  letterSpacing: .3,
                  fontFamily: "appollo",
                  fontSize: 11,
                  color: darkMode ?  Color.fromARGB(55, 158, 158, 158) :  Color.fromARGB(132, 60, 60, 60),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    ) ;
  }
}