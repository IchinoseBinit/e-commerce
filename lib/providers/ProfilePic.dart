import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePictureProvider with ChangeNotifier {
  ProfilePictureProvider() {
    if (_profilePic.file == null) {
      referenceTempFolder().then((oldFile) {
        _profilePic.file = oldFile;
        loadImage();
        profilePic.hasImage = true;
      });
    }
  }

  setImage(PickedFile? pickedImage) async {
    if (pickedImage != null) {
      final imagePath = File(pickedImage.path);
      profilePic.image = imagePath.readAsBytesSync.call();
      await profilePic.file!.writeAsBytes(profilePic.image!);
    }
    notifyListeners();
  }

  loadImage() {
    if (profilePic.image == null) {
      try {
        profilePic.image = profilePic.file!.readAsBytesSync();
      } catch (e) {
        print("Cant find the image file");
      }
    }
  }

  Future<File?> referenceTempFolder() async {
    if (profilePic.file != null) {
      return profilePic.file;
    }
    final appDir = await getTemporaryDirectory();
    profilePic.file = File('${appDir.path}/profile.jpg');
    return profilePic.file;
  }

  ProfilePic _profilePic = new ProfilePic(hasImage: false);

  ProfilePic get profilePic => _profilePic;

  clearProfilePic() {
    _profilePic.file = null;
    _profilePic.hasImage = false;
    _profilePic.image = null;
    notifyListeners();
  }
}

class ProfilePic {
  bool? hasImage;
  Uint8List? image;
  File? file;

  ProfilePic({this.image, this.file, this.hasImage});
}
