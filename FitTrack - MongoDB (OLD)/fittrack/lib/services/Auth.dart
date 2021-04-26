import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  String uid;

  Future<bool> updateUser(String uid, String email, String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", uid);
      await prefs.setString("email", email);
      await prefs.setString("name", name);

      globals.uid = uid;
      globals.email = email;
      globals.name = name;

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> googleSignIn() async {
    Database _db = Database();

    try {
      bool connectionOpened = await _db.openConnection();
      if (!connectionOpened) {
        return false;
      }

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      String _uid = userCredential.user.uid;
      String email = userCredential.user.email;
      String name = userCredential.user.displayName;
      if (userCredential.additionalUserInfo.isNewUser) {
        bool userCreated = await _db.createUser(_uid, email, name);
        if (!userCreated) {
          return false;
        }
      }

      bool uidUpdated = await updateUser(_uid, email, name);

      if (!uidUpdated) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      await _db.closeConnection();
    }
  }

  Future<bool> facebookSignIn() async {
    Database _db = Database();

    try {
      bool connectionOpened = await _db.openConnection();
      if (!connectionOpened) {
        return false;
      }

      FacebookLoginResult facebookLoginResult =
          await _facebookLogin.logIn(['email']);

      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        OAuthCredential credential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken.token);

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        String _uid = userCredential.user.uid;
        String email = userCredential.user.email;
        String name = userCredential.user.displayName;
        if (userCredential.additionalUserInfo.isNewUser) {
          bool userCreated = await _db.createUser(_uid, email, name);
          if (!userCreated) {
            return false;
          }
        }

        bool uidUpdated = await updateUser(_uid, email, name);

        if (!uidUpdated) {
          return false;
        }
      } else {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      await _db.closeConnection();
    }
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect().catchError((onError) {});

      if (await _facebookLogin.isLoggedIn) {
        await _facebookLogin.logOut();
      }

      await updateUser("", "", "");
      globals.setDefault();

      return true;
    } catch (e) {
      return false;
    }
  }
}
