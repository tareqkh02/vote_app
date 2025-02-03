import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'toast.dart';


class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  


  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message:'The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        showToast(message:'Invalid email format.');
      } else if (e.code == 'weak-password') {
        showToast(message:'The password provided is too weak.');
      } else {
        showToast(message:'An error occurred: ${e.message}');
      }
    } catch (e) {
      showToast(message:'An unexpected error occurred.');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message:'Invalid email or password.');
      } else {
        showToast(message:'An error occurred: ${e.message}');
      }
    } catch (e) {
      showToast(message:'An unexpected error occurred.');
    }
    return null;
  }
  
  




Future<User?> signInAsAdmin(String adminEmail, String adminPassword) async {
  try {
  
    DocumentSnapshot adminDocSnapshot = await FirebaseFirestore.instance.collection('admin').doc('adminlogin').get();
    
String? storedEmail;
String? storedPassword;

    if (adminDocSnapshot.data() != null) {
  Map<String, dynamic> data = adminDocSnapshot.data() as Map<String, dynamic>;
  storedEmail = data['adminemail'];
  storedPassword = data['adminpass'];



      
      
      if (adminEmail == storedEmail && adminPassword == storedPassword) {
       
        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        
      
        return credential.user;
      } else {
        showToast(message: 'Incorrect email or password.');
        return null;
      }
    } else {
      showToast(message: 'Admin document not found.');
      return null;
    }
  } on FirebaseAuthException catch (e) {
    showToast(message: 'Failed to sign in as admin: ${e.message}');
    return null;
  } catch (e) {
    showToast(message: 'An unexpected error occurred.');
    return null;
  }
}





}
