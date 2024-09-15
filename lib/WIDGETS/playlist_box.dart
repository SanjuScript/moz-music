import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/id_saver.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import 'package:provider/provider.dart';

class PlaylistCreationBox extends StatelessWidget {
  final Widget artwork;
  final String songCount;
  final String text;
  final bool isArtworkAvailable;
  final List<int> datas;
  final String name;
  const PlaylistCreationBox(
      {super.key,
      required this.artwork,
      required this.text,
      required this.datas,
      required this.name,
      this.isArtworkAvailable = false,
      required this.songCount});

  @override
  Widget build(BuildContext context) {
    return PlaylistHighlighter(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      borderradius: const BorderRadius.all(Radius.circular(10)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.18,
                  width: double.infinity,
                  child: artwork,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  songCount,
                  style: TextStyle(
                      fontFamily: 'coolvetica',
                      letterSpacing: 1,
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).cardColor),
                ),
              ),
              _showText(text,
                  context: context,
                  fontWeight:
                      isArtworkAvailable ? FontWeight.w500 : FontWeight.w400)
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: ShowExportMenu(
              datas: datas,
              name: name,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _showText(String text,
    {required FontWeight fontWeight, required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      text,
      style: TextStyle(
          fontFamily: 'coolvetica',
          fontSize: MediaQuery.of(context).size.height * 0.020,
          letterSpacing: 1.5,
          overflow: TextOverflow.ellipsis,
          fontWeight: fontWeight,
          color: Theme.of(context).cardColor),
    ),
  );
}

class ShowExportMenu extends StatefulWidget {
  final List<int> datas;
  final String name;
  const ShowExportMenu({super.key, required this.datas, required this.name});

  @override
  State<ShowExportMenu> createState() => _ShowExportMenuState();
}

class _ShowExportMenuState extends State<ShowExportMenu> {
  Offset _tapPosition = Offset.zero;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  // void _showMenu(BuildContext context) {

  //   log("Tap found");
   
  // }

  @override
  Widget build(BuildContext context) {
    final eProvider = Provider.of<PlaylistExporter>(context);

    return GestureDetector(
        onTapDown: _storePosition,
        onTap: (){
           final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    showMenu(
        context: context,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        position: RelativeRect.fromLTRB(
          _tapPosition.dx,
          _tapPosition.dy,
          overlay.size.width - _tapPosition.dx,
          overlay.size.height - _tapPosition.dy,
        ),
        items: [
          PopupMenuItem<String>(
            // mouseCursor:MaterialStateMouseCursor.textable,
            onTap: () {
              log('value');
              eProvider.exportIDs(widget.datas, widget.name, context);
            },
            height: 30,
            child: Row(
              children: [
                Text(
                  "Export",
                  style: TextStyle(
                      fontFamily: 'coolvetica',
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                      letterSpacing: 1.5,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      color:Colors.green[400]),
                ),
                Icon(
                  Icons.upload_file_outlined,
                  color: Theme.of(context).scaffoldBackgroundColor,
                )
              ],
            ),
          )
        ]);
        },
        child: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            )));
  }
}
