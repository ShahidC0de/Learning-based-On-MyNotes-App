import 'package:flutter/material.dart';
import 'package:my_notes_app/utilities/dialogues/generic_dialogue.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error Occured',
    content: text,
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
