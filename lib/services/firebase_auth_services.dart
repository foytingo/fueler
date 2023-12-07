


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fueler_new/helpers/auth_exception_helper.dart';
import 'package:fueler_new/models/fueler_user_model.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {

  final _auth = FirebaseAuth.instance;

  Future<AuthResultStatus> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResultStatus.successful;
    } on FirebaseAuthException catch (error) {
      return AuthExceptionHandler.handleException(error.code);

    }
  }

  Future<AuthResultStatus> sigupWithEmail(String email, String password) async {
    try {
      var credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = FuelerUser(userUid: credential.user!.uid, email: email);
      await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(user.toFirestore());
      await FirebaseFirestore.instance.collection("vehicles").doc(credential.user!.uid).set({"vehicles" : []});
      await FirebaseFirestore.instance.collection("fuels").doc(credential.user!.uid).set({"fuels" : []});
      return AuthResultStatus.successful;
    } on FirebaseAuthException catch (error) {
        return AuthExceptionHandler.handleException(error.code);
    } catch(error) {
        return AuthExceptionHandler.handleException(error);
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      final ref = FirebaseFirestore.instance.collection("users").doc(docId);
      var doc = await ref.get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
 
  Future<AuthResultStatus> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email]);
      final AuthCredential credentialForApple = OAuthProvider("apple.com").credential(accessToken: appleCredential.authorizationCode, idToken: appleCredential.identityToken);

      final credential = await FirebaseAuth.instance.signInWithCredential(credentialForApple);
      var isExsist = await checkIfDocExists(credential.user!.uid);
      
      if (isExsist) {
        return AuthResultStatus.successful;

      } else {
        var user = FuelerUser(userUid: credential.user!.uid, email: credential.user!.email!);
        await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(user.toFirestore());
        await FirebaseFirestore.instance.collection("vehicles").doc(credential.user!.uid).set({"vehicles" : []});
        await FirebaseFirestore.instance.collection("fuels").doc(credential.user!.uid).set({"fuels" : []});
        return AuthResultStatus.successfulWithNoVehicle;
      }
    } on SignInWithAppleAuthorizationException catch (appleError) {
        return AuthExceptionHandler.handleException(appleError.code);
    } on FirebaseAuthException catch (error) {
        return AuthExceptionHandler.handleException(error.code);
    } catch(error) {
        return AuthExceptionHandler.handleException(error);
    }
  }

  Future<AuthResultStatus> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credentialForGoogle = GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      final credential = await FirebaseAuth.instance.signInWithCredential(credentialForGoogle);
      var isExsist = await checkIfDocExists(credential.user!.uid);
        if (isExsist) { 
        return AuthResultStatus.successful;
      } else {
        var user = FuelerUser(userUid: credential.user!.uid, email: credential.user!.email!);
        await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(user.toFirestore());
        await FirebaseFirestore.instance.collection("vehicles").doc(credential.user!.uid).set({"vehicles" : []});
        await FirebaseFirestore.instance.collection("fuels").doc(credential.user!.uid).set({"fuels" : []});
        return AuthResultStatus.successfulWithNoVehicle;
      }
 
    } on FirebaseAuthException catch (error) {
      return AuthExceptionHandler.handleException(error.code);
    } catch(error) {
      return AuthExceptionHandler.handleException(error);
    }

  }

  Future<AuthResultStatus> resetPw(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return AuthResultStatus.successful;
    } on FirebaseAuthException catch (error) {
      return AuthExceptionHandler.handleException(error.code);
    }

  }


}