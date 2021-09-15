import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Login"),
      ),
      body:


      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              color: Colors.grey.withOpacity(0.3),
              onPressed: signInWithGoogle,
              child: Text("Google Login"),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<UserCredential> signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//   final OAuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

