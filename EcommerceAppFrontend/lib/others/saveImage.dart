import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<String> uploadImage(File imageFile,path) async {
  try{
    await Firebase.initializeApp();
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    await firebaseStorageRef.putFile(imageFile);
    return await firebaseStorageRef.getDownloadURL();
  }catch(error){
    print(error);
  }
}
