
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> AuthSignIn(String email, String password) async {
   
    try {
    final a =  await _auth.signInWithEmailAndPassword(email: email, password: password);     
    return a.user; 
    } on FirebaseAuthException  catch(e){
      print(e);
    }
  }

  static Future<String> AuthSignUp(String email, String password) async {
    try {
      
     final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
     ;
     return user.user!.uid;     
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return "email-already-in-use";
      }
    } catch(e){
      print(e);
    }
    return "";
  }
  static Future AuthSignOut() async {
    try {
     await _auth.signOut();    
    } on FirebaseAuthException catch(e){
      print(e);
    }
  }
}
