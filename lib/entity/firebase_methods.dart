import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:client_demo_app/manager/image_processing.dart';
import 'package:path/path.dart' as Path;

class FirebaseEntity{
  ImageProcessing img;
  FirebaseEntity(this.img);
  FirebaseFirestore _firestore= FirebaseFirestore.instance;

  Future<String> postDetails(String caption)async{
   DocumentReference ref=  _firestore.collection('posts').doc();
   await ref.set({
     'username':'Jack',
     'length':img.imageFile.length,
     'caption':caption,
     'type':'images'
   });
   return ref.id;

  }
  void post(String docId,String imageUrl)
  {
    _firestore.collection('posts').doc(docId).collection('posts').doc().set({
      'Url':imageUrl
    });
  }
  Future<bool> uploadPost(String caption)async{
    String id= await postDetails(caption);
    for(var images in img.imageFile)
      {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(images.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(images);
        StorageTaskSnapshot result= await uploadTask.onComplete;
        print('File Uploaded');
        String uploadedImgUrl= await result.ref.getDownloadURL();
        print('Image URl :- $uploadedImgUrl');
        post(id, uploadedImgUrl);
      }
    return true;
  }
}