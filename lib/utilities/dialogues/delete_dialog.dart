import 'package:flutter/material.dart';
import 'package:my_notes_app/utilities/dialogues/generic_dialogue.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete',
      content: 'Are you sure to delete',
      optionBuilder: () => {
            'Cancel': false,
            'Ok': true,
          }).then((value) => value ?? false);
}
