import 'package:client_demo_app/screens/edit_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../manager/image_processing.dart';
import 'package:client_demo_app/screens/post_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageProcessing img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Social app'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 50.0),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text('Post'),
                      onPressed: ()async{
                        img=ImageProcessing();
                        try{
                          await img.pickImages();
                          print('${img.numOfSelectedImages}');
                          if(img.numOfSelectedImages==1)
                            {
                              Navigator.push(context,MaterialPageRoute(builder: (context){
                               return PostImage(img: img,);
                              }));
                            }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return EditImage(img: img);
                            }));
                          }
                        }
                        catch(e){
                          print('error is ==='+e);
                        }
                      }
                  ),
                ],
              ),
              StreamBuilder(
                stream: _firestore.collection('posts').snapshots(),
                  builder: (context,snapshot){
                  if(!snapshot.hasData)
                    {
                      return Container(
                        child: Text('No posts yet'),
                      );
                    }
                  final postDetails= snapshot.data.docs;
                  List<Widget> customCards=[];
                  for(var details in postDetails){
                    customCards.add(buildcard(details.data()['username'],details.data()['type'] , details.data()['caption'], details.id));
                  }
                  return Column(
                    children: customCards,
                  );
                  }
              )

            ],
          ),
        ),
      ),
    );
  }
}
Widget buildcard(String name , String type,String caption,String docId){

  List<Widget> listTile=[];

  Widget buildListCard(String url){
      return Expanded(
        child: Container(
          height: 150,
          width: 150,
          child: Image.network(url),
        ),
      );

  }
  return StreamBuilder(
      stream: _firestore.collection('posts').doc(docId).collection('posts').snapshots(),
      builder: (context,snapshot){
        final urls= snapshot.data.docs;
        for(var url in urls){
          listTile.add(buildListCard(url.data()['Url']));
        }
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(
                    color: Colors.black26,
                    width: 1.0
                )
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(caption),
            SizedBox(height: 10.0,),
            Row(
              children: listTile,
            )
            ],
          ),
        );
      }
  );
}