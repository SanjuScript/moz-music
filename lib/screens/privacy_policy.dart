import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';
import '../COLORS/colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Welcome to Moz Music Player',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color:Theme.of(context).cardColor
                      ),
                    ),
                  ),
                  Text(
                    'These terms and conditions outline the rules and regulations for the use of Moz Music Player. By using this app, we assume you accept these terms and conditions. Do not continue to use Moz Music Player if you do not agree to take all of the terms and conditions stated on this page.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements:',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: themeProvider.gettheme() == darkThemeMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• "Client", "You" and "Your" refers to you, the person who logs on this website and complies with the Company’s terms and conditions.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• "The Company", "Ourselves", "We", "Our" and "Us" refers to our Company.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• "Party", "Parties", or "Us" refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'License',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Unless otherwise stated, Moz Music Player and/or its licensors own the intellectual property rights for all material on Moz Music Player. All intellectual property rights are reserved. You may access this from Moz Music Player for your own personal use subjected to restrictions set in these terms and conditions.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color:Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'You must not:',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• Republish material from Moz Music Player',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• Sell, rent, or sub-license material from Moz Music Player',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• Reproduce, duplicate, or copy material from Moz Music Player',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• Redistribute content',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Theme.of(context).cardColor
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
