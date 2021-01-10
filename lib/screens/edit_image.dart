import 'dart:io';
import 'package:flutter/material.dart';
import 'package:client_demo_app/manager/image_processing.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:client_demo_app/screens/post_image.dart';

class EditImage extends StatefulWidget {
  ImageProcessing img;
  int height, width;

  EditImage({this.img});

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  File image;
  int imageIndex;
  List<GestureDetector> imageList = [];

  Widget buildCustomImageSelector(File childImage,int index) {
    return GestureDetector(
      child: Container(
        height: 120.0,
        width: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(childImage)
          )
        ),
      ),

      onTap: () {
        setState(() {
          image = childImage;
          imageIndex=index;
        });
      },
    );
  }

 _generateList(){
    imageList.clear();
    image = widget.img.imageFile[0];
    widget.height=widget.img.images[0].originalHeight;
    widget.width=widget.img.images[0].originalWidth;
   int i=0;
   imageIndex=i;
   for (var img in widget.img.imageFile) {
     imageList.add(buildCustomImageSelector(img,i));
     i++;
   }
 }
  @override
  void initState(){

    _generateList();
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PostImage(img: widget.img);
                }));
              },
              child: Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child:Container(
                height: widget.height.toDouble(),
                width: widget.width.toDouble(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(image)
                  )
                ),
              )
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: imageList,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    textColor: Colors.white,
                    color:Colors.indigo,
                    child: Text('Crop'),
                    onPressed: ()async
                    {
                      File receivedImage=await widget.img.cropImage(image);
                      if(receivedImage!=null)
                        {
                          setState(() {
                            widget.img.imageFile[imageIndex]=receivedImage;
                            _generateList();
                          });

                        }
                    },
                  ),
                  RaisedButton(
                    textColor: Colors.indigo,
                    color: Colors.white,
                    onPressed: ()async {
                      File receivedImage= await widget.img.applyFilter(image, context);
                      if(receivedImage!=null)
                        {
                          setState(() {
                            widget.img.imageFile[imageIndex]=receivedImage;
                            _generateList();
                          });
                        }
                    },
                    child: Text('Effects'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
