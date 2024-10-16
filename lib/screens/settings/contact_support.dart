import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title:   Text(
                  'Contact Support',
                  style: TextStyle(
                    // fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'optica',
                    color:Theme.of(context).splashColor,
                  ),
                ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: Text(
                'Get in Touch',
                style: TextStyle(
                    fontFamily: 'optica',

                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).cardColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
             Text(
              'We\'re here to help you! If you have any questions or need support, feel free to reach out to us.',
              style: TextStyle(fontSize: 16, color: Theme.of(context).cardColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
             Text(
              'Contact Us:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Theme.of(context).cardColor),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchEmail(),
              child: const Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.deepPurple),
                  title: Text('Email:'),
                  subtitle: Text('mozmusicfounder@gmail.com'),
                  
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _launchInstagram(),
              child: const Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.deepPurple),
                  title: Text('Instagram: @moz_music_app'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mozmusicfounder@gmail.com',
      query: 'subject=Support Request',
    );
    await launchUrl(Uri.parse(emailLaunchUri.toString()));
  }

  void _launchInstagram() async {
    const instagramUrl = 'https://instagram.com/moz_music_app';
    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    } else {
      throw 'Could not launch $instagramUrl';
    }
  }
}
