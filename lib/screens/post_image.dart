import 'dart:io';
import 'package:client_demo_app/manager/image_processing.dart';
import 'package:client_demo_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:client_demo_app/entity/firebase_methods.dart';

class PostImage extends StatefulWidget {
  Asset image;
  ImageProcessing img;

  PostImage({this.img});

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  TextEditingController _caption;
  FirebaseEntity control;
  bool showSpinner=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _caption = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Social App'),
      ),
      body: SafeArea(
        child: showSpinner?AlertDialog(
          title: Text('Uploading post'),
          content: Container(
            height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator()
          ),
        )
        :Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _caption,
                  decoration:
                      InputDecoration(hintText: 'Caption', helperText: 'Caption'),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.img.imageFile.length, (index){
                    return Expanded(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Image.file(widget.img.imageFile[index]),
                      ),
                    );
                  }),
                )
            ),
            RaisedButton(
                color: Colors.indigo,
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: ()async {
                  control=FirebaseEntity(widget.img);

                  setState(() {
                    showSpinner=true;
                  });
                 bool check= await control.uploadPost(_caption.text);
                 if(check) {
                   setState(() {
                     showSpinner = false;
                   });
                   Navigator.push(context, MaterialPageRoute(builder: (context){
                     return HomePage();
                   }));
                 }


                })
          ],
        ),
      ),
    );
  }
}
