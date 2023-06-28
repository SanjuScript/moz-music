import 'package:flutter/material.dart';


class CardItem extends StatelessWidget {
  final Color color;
  final String num;
  final String numEng;
  final String content;
  final void Function() onTap;

 const CardItem(this.color, this.num, this.numEng, this.content, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: 220,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0xffFF6594).withOpacity(0.2), blurRadius: 25),
          ],
          color: color.withOpacity(1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tap to view more',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
" We're dedicated to provide you the best of Music, with a focus on dependability and customer service.We're working to turn our passion for music into a booming Music Player. We hope you enjoy our Music as much as we enjoy offering them to you. Sincerely, SANJU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimCard extends StatefulWidget {
  final Color color;
  final String num;
  final String numEng;
  final String content;

  const AnimCard(this.color, this.num, this.numEng, this.content, {super.key});

  @override
  _AnimCardState createState() => _AnimCardState();
}

class _AnimCardState extends State<AnimCard> {
  var padding = 150.0;
  var bottomPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPadding(
          padding: EdgeInsets.only(top: padding, bottom: bottomPadding),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Container(
            child: CardItem(
              widget.color,
              widget.num,
              widget.numEng,
              widget.content,
              () {
                setState(() {
                  padding = padding == 0 ? 150.0 : 0.0;
                  bottomPadding = bottomPadding == 0 ? 150 : 0.0;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 200),
            height: 180,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2), blurRadius: 30)
              ],
              color: Colors.grey.shade200.withOpacity(1.0),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
            "M",
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: "optica",
              fontSize: 60,
              color: const Color(0xffFF6594).withOpacity(1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
                    Icon(Icons.favorite_rounded,
                        color: const Color(0xffFF6594).withOpacity(1.0), size: 70),
                          Text(
            "Z",
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: "optica",
              fontSize: 60,
              color:  const Color(0xffFF6594).withOpacity(1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

