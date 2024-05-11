import 'package:e_commerce_app/providers/ProfilePic.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatefulWidget {
  final bool? isLoggedIn;

  ProfilePicture({
    Key? key,
    this.isLoggedIn,
  }) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final picker = ImagePicker();
  PickedFile? pickedImage;

  late ProfilePictureProvider _profilePictureProvider;
  Future? future;

  @override
  initState() {
    _profilePictureProvider =
        Provider.of<ProfilePictureProvider>(context, listen: false);
    if (_profilePictureProvider.profilePic.hasImage!) {
      future = _profilePictureProvider.loadImage();
    } else {
      future = _profilePictureProvider.referenceTempFolder();
    }
    super.initState();
  }

  _imgFromCamera() async {
    pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _profilePictureProvider.setImage(pickedImage);
    });
  }

  _imgFromGallery() async {
    pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _profilePictureProvider.setImage(pickedImage);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(ctx).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: new Text(
                      'Camera',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          FutureBuilder(
              future: future,
              builder: (context, profileData) {
                if (profileData.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    child: CircularProgressIndicator(),
                  );
                }
                return Consumer<ProfilePictureProvider>(
                  builder: (context, profileData, _) {
                    return CircleAvatar(
                        backgroundImage: _profilePictureProvider.profilePic ==
                                null
                            ? AssetImage("assets/images/Profile Image.png")
                            : (_profilePictureProvider.profilePic.image == null
                                ? AssetImage("assets/images/Profile Image.png")
                                : MemoryImage(_profilePictureProvider.profilePic
                                    .image!)) as ImageProvider<Object>?
                        // Image.file(_image),
                        );
                  },
                );
              }),
          widget.isLoggedIn!
              ? Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      onPressed: () {
                        _showPicker(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).cardTheme.color,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Theme.of(context).cardTheme.color!,
                            ),
                          ),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Camera Icon.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
