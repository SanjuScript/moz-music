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
              child: AlertDialog(
                title: Text(
                  mainText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[500],
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: donePress,
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
