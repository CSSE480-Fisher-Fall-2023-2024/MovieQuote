import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/model/firestore_model_utils.dart';

const kUserDatasCollectionPath = "Users";
const kUserDataCreated = "created";
const kUserDataDisplayName = "displayName";
const kUserDataImageUrl = "imageUrl";

class UserData {
  String? documentId;
  Timestamp created;
  String displayName;
  String imageUrl;

  UserData({
    this.documentId,
    required this.created,
    required this.displayName,
    required this.imageUrl,
  });

  UserData.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          created: FirestoreModelUtils.getTimestampField(doc, kUserDataCreated),
          displayName:
              FirestoreModelUtils.getStringField(doc, kUserDataDisplayName),
          imageUrl: FirestoreModelUtils.getStringField(doc, kUserDataImageUrl),
        );

  // Preparing this for MUCH later.
  Map<String, Object?> toMap() => {
        kUserDataCreated: created,
        kUserDataDisplayName: displayName,
        kUserDataImageUrl: imageUrl,
      };

  @override
  String toString() {
    return "Display name: $displayName";
  }
}
