import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/scan.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  var isloggedIn = false;

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
    setState(() => isloggedIn = true);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gmail Login"),
      ),
      body:

      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isloggedIn == false
                  ? 'Please google log-in'
                  : 'You are now logged in!',
              style: Theme.of(context).textTheme.headline6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                //minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.google, color:Colors.red),
              label: Text('Sign Up with Google'),
              onPressed: !isloggedIn ?
              signInWithGoogle
                  :null
            ),
            // FlatButton(
            //   color: Colors.grey.withOpacity(0.3),
            //   onPressed: signInWithGoogle,
            //   child: Text("Google Login"),
            // ),
      FlatButton(
        color: Colors.grey.withOpacity(0.3),
        onPressed: isloggedIn ? (){
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => Scan());
          Navigator.push(context, route);
        }: null,
        child: Text("Proceed"),
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



