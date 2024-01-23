import 'package:flutter/material.dart';
import 'package:my_notes_app/utilities/dialogues/generic_dialogue.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure ',
    optionBuilder: () => {
      'Cancel': false,
      'Ok': true,
    },
  ).then((value) => value ?? false);
}
