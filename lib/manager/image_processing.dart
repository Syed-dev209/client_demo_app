import 'dart:io';
import 'package:photofilters/photofilters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';


class ImageProcessing{
  List<Asset> images = List<Asset>();
  List<File> imageFile= List<File>();

  int get numOfSelectedImages{
    return images.length;
  }

  Future<void> pickImages()async
  {
    try {
      final selectedImages = await MultiImagePicker.pickImages(
          maxImages: 3
      );
      images=selectedImages;

      images.forEach((imageAsset) async {
        final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
        File tempFile = File(filePath);
        if (tempFile.existsSync()) {
          imageFile.add(tempFile);
        }
      });
    }on Exception catch(e){
      print(e);
    }

  }

  Future<File> cropImage(File imageSrc)async{
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageSrc.path,
      maxWidth: 1080,
      maxHeight: 1080
    );
    if(croppedImage!=null)
      {
        return croppedImage;
      }
    return null;

  }

  Future<File>applyFilter(File imagesrc,context)async
  {
    String fileName;
    File imageSrc=imagesrc;
    List<Filter> filters = presetFiltersList;
    fileName=basename(imageSrc.path);
    var image = imageLib.decodeImage(imageSrc.readAsBytesSync());
    image=imageLib.copyResize(image,width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Apply Filter"),
          image: image,
          filters: presetFiltersList,
          filename:fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
        imageSrc = imagefile['image_filtered'];
      return imageSrc;
    }
    else{
      return null;
    }
  }





}