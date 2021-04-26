import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  User _userFromFirebaseObject(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, fullName: user.displayName, email: user.email)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseObject);
  }

  // Google Sign In
  Future googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;

        FirebaseUser currentUser = await _auth.currentUser();

        assert(user.uid == currentUser.uid);

        if (result.additionalUserInfo.isNewUser) {
          await DatabaseService(uid: currentUser.uid)
              .updateUserData(currentUser.displayName, currentUser.email);
        }

        await user.reload();

        return _userFromFirebaseObject(user);
      } else {
        return null;
      }
    } catch (e) {
      print("ERROR; " + e.toString());
      return null;
    }
  }

  // Facebook Sign In
  Future facebookSignIn() async {
    try {
      if (_facebookLogin != null) {
        FacebookLoginResult facebookLoginResult =
            await _facebookLogin.logIn(['email']);

        if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
          final credential = FacebookAuthProvider.getCredential(
              accessToken: facebookLoginResult.accessToken.token);

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          FirebaseUser currentUser = await _auth.currentUser();

          assert(user.uid == currentUser.uid);

          if (result.additionalUserInfo.isNewUser) {
            await DatabaseService(uid: currentUser.uid)
                .updateUserData(currentUser.displayName, currentUser.email);
          }

          await user.reload();

          return _userFromFirebaseObject(user);
        } else {
          print("STATUS: ${facebookLoginResult.status}");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("ERROR $e");
      return null;
    }
  }

  Future microsoftSignIn() async {
    try {} catch (e) {
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      FirebaseUser user = await _auth.currentUser();

      if (user.providerData[1].providerId == 'google.com') {
        print("GOOGLE LOGOUT");
        await _googleSignIn.disconnect().catchError((onError) {
          print("ERROR: $onError");
        });
      }

      if (await _facebookLogin.isLoggedIn) {
        print("FACEBOOK LOGOUT");
        await _facebookLogin.logOut();
      }

      await user.reload();

      print("REGULAR LOGOUT");
      await _auth.signOut();

      return true;
    } catch (e) {
      return null;
    }
  }
}
