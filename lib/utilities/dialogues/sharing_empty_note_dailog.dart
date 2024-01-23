import 'package:flutter/widgets.dart';
import 'package:my_notes_app/utilities/dialogues/generic_dialogue.dart';

Future<void> cannotShareAnEmptyNote(BuildContext context) async {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
