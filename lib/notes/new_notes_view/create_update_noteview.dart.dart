import 'package:flutter/material.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/services/cloud/cloud_note.dart';
import 'package:my_notes_app/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes_app/utilities/dialogues/sharing_empty_note_dailog.dart';
import 'package:my_notes_app/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _notes;
  // ignore: unused_field
  late final AuthServices _authServices;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;
  Future<CloudNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArguments<CloudNote>();
    if (widgetNote != null) {
      _notes = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _notes;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthServices.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(userId);
    _notes = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty() {
    final note = _notes;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deleteNote(note.documentId);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _notes;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note.documentId, text);
    }
  }

  void _textControllerListener() async {
    final note = _notes;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(note.documentId, text);
  }

  void _setupTextControllerText() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfNotEmpty();
    _textEditingController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(" New Note"),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textEditingController.text;
                if (_notes == null || text.isEmpty) {
                  await cannotShareAnEmptyNote(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: FutureBuilder(
            future: createOrGetNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerText();
                  return TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'start typing your note...',
                    ),
                  );

                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
