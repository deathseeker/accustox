import 'color_scheme.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'dart:io';
import 'controllers.dart';

class ImageContainer extends StatefulWidget {
  ImageContainer({Key? key, this.imageURL, this.imageFile}) : super(key: key);

  final String? imageURL;
  ImageFile? imageFile;

  final ImageDataController _imageDataController = ImageDataController();

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  Image image = Image.asset(
    'assets/Image upload-bro.png',
    fit: BoxFit.cover,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _imageContainer(image),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          _imageSourceChips(
            () {
              _addImage(isSourceCamera: true, isCropStyleCircle: false);
            },
            () {
              _addImage(isSourceCamera: false, isCropStyleCircle: false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) async {
    File file = await widget._imageDataController.getImage(
      isSourceCamera: isSourceCamera,
      isCropStyleCircle: isCropStyleCircle,
    );
    Image _image = Image.file(
      file,
      fit: BoxFit.cover,
    );
    setState(() {
      image = _image;
    });
    widget.imageFile!.file = file;
  }
}

Widget _imageContainer(Image image) {
  return Container(
    height: 150.0,
    width: 150.0,
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    foregroundDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: lightColorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8.0))),
    child: image,
  );
}

Widget _profileImageContainer(Image image) {
  return Container(
    height: 150.0,
    width: 150.0,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: lightColorScheme.outline),
        image: DecorationImage(image: image.image)),
  );
}

class EditImageContainer extends StatefulWidget {
  EditImageContainer({Key? key, this.imageURL, this.imageFile})
      : super(key: key);

  final String? imageURL;
  ImageFile? imageFile;

  final ImageDataController _imageDataController = ImageDataController();

  @override
  _EditImageContainerState createState() => _EditImageContainerState();
}

class _EditImageContainerState extends State<EditImageContainer> {
  late Image image;

  @override
  void initState() {
    image = Image.network(
      widget.imageURL!,
      fit: BoxFit.cover,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _imageContainer(image),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          _imageSourceChips(
            () {
              _addImage(isSourceCamera: true, isCropStyleCircle: false);
            },
            () {
              _addImage(isSourceCamera: false, isCropStyleCircle: false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) async {
    File file = await widget._imageDataController.getImage(
      isSourceCamera: isSourceCamera,
      isCropStyleCircle: isCropStyleCircle,
    );
    Image _image = Image.file(
      file,
      fit: BoxFit.cover,
    );
    setState(() {
      image = _image;
    });
    widget.imageFile!.file = file;
  }
}

/*Widget _addImageButton(VoidCallback onPressed) {
  return Positioned(
    top: 4.0,
    right: 4.0,
    child: Container(
      decoration: const BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.add_a_photo_outlined,
            color: onPrimary,
          )),
    ),
  );
}*/

Widget _imageSourceChips(VoidCallback takePhoto, VoidCallback addFromGallery) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ActionChip(
          avatar: const Icon(
            Icons.camera_alt_outlined,
          ),
          label: const Text(
            'Photo',
          ),
          onPressed: takePhoto),
      const Padding(padding: EdgeInsets.only(left: 16.0)),
      ActionChip(
          avatar: const Icon(
            Icons.add_photo_alternate_outlined,
          ),
          label: const Text(
            'Gallery',
          ),
          onPressed: addFromGallery),
    ],
  );
}

class ProfileImageContainer extends StatefulWidget {
  ProfileImageContainer({Key? key, this.profileImageURL, this.imageFile})
      : super(key: key);

  final String? profileImageURL;
  ImageFile? imageFile;

  final ImageDataController _imageDataController = ImageDataController();

  @override
  _ProfileImageContainerState createState() => _ProfileImageContainerState();
}

class _ProfileImageContainerState extends State<ProfileImageContainer> {
  Image image = Image.asset(
    'assets/Image upload-bro.png',
    fit: BoxFit.cover,
  );

  @override
  void initState() {
    widget.profileImageURL != null
        ? image = Image.network(
            widget.profileImageURL!,
            fit: BoxFit.cover,
          )
        : null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _profileImageContainer(image),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          _imageSourceChips(
            () {
              _addImage(isSourceCamera: true, isCropStyleCircle: true);
            },
            () {
              _addImage(isSourceCamera: false, isCropStyleCircle: true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) async {
    File file = await widget._imageDataController.getImage(
      isSourceCamera: isSourceCamera,
      isCropStyleCircle: isCropStyleCircle,
    );
    Image _image = Image.file(
      file,
      fit: BoxFit.cover,
    );
    setState(() {
      image = _image;
    });
    widget.imageFile!.file = file;
  }
}
