import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final Widget child;
  final bool isneeded;
  const SettingsContainer(
      {super.key, required this.child, this.isneeded = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Colors.deepPurple[300]!.withOpacity(.5),
              // Colors.deepPurple[500]!.withOpacity(.6),
              // const Color.fromARGB(255, 47, 45, 50),
              //    const Color.fromARGB(255, 47, 45, 50),
              Theme.of(context).focusColor.withOpacity(.7),
              Theme.of(context).focusColor.withOpacity(.7),
            ].cast(),
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow:  const [
            // BoxShadow(
            //     color: Theme.of(context).primaryColorDark,
            //     offset: const Offset(-6, 6),
            //     blurRadius: 7,
            //     spreadRadius: -5),
            // BoxShadow(
            //     color: Theme.of(context).primaryColorLight,
            //     offset: const Offset(5, -5),
            //     blurRadius: 7,
            //     spreadRadius: -5),
          ]),
      margin: EdgeInsets.only(top: isneeded ? 0:10, right: 5, left: 5, bottom:  10),
      child: child,
    );
  }
}
