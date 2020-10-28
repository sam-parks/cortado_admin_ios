/* import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  Future<String> uploadImageFile(Uint8List image, String coffeeShop,
      {String imageName}) async {
    StorageReference storageRef = FirebaseStorage().ref();
    StorageUploadTask storageUploadTask = storageRef
        .putFile(File('images/$coffeeShop/${Random().nextInt(999999)}.jpg'));

    Uri imageUri = await storageUploadTask.lastSnapshot.ref.getDownloadURL();
    return imageUri.toString();
  }
}
 */
