import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes_app/services/cloud/cloud_storage_constants.dart';

// this class is for the actual retrieving or reading the firebase;
// through constructor in which we passed QUERYSNAPSHOTDOCUMENT, use to retrieve each document in the collection;
// we gave a map in which keys are string and values can be anytype;
// retrieve those textfields and assigned to the class variables;

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.text});
  CloudNote.fromsnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>>
          snapshot) // respresents that keys are string and values can be anytype;
      : documentId = snapshot
            .id, // assigning the document id into local varaible which is documentId;
        ownerUserId = snapshot.data()[
            ownerUserIdFieldName], // reading owner id from document, which document??, the above one;
        text = snapshot.data()[textFieldName]; // reading text of user;.....
}
