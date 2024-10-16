import 'dart:ui';
import 'package:flutter/material.dart';

void showPlaylistCreationDialogue({
  required BuildContext context,
  required Key formKey,
  required TextEditingController nameController,
  required String hint,
  required void Function() donePress,
  required String mainText,
  required String validator,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect here
                  child: AlertDialog(
                    backgroundColor: Theme.of(context).splashColor, // Semi-transparent background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Text(
                      mainText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).cardColor, // Match title color to theme
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          autofocus: true,
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: nameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).cardColor, // Focused border color
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor, // Enabled border color
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: hint,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor, // Hint text color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return validator;
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor, // Cancel button color
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: donePress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor.withOpacity(.6), // Button color
                        ),
                        child:  Text('Done',style: TextStyle(color: Theme.of(context).cardColor),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
