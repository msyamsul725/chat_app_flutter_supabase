import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

import 'package:supabase/supabase.dart';

import '../../main.dart';

class AuthServiceSupabase {
  late final StreamSubscription<AuthState> authStateSubscription;
  bool _redirecting = false;
  createUser({
    required final String email,
    required final String password,
    required final String username,
  }) async {
    // try {
    //   showLoading();
    final response = await supabaseHandler.auth
        .signUp(email: email, password: password)
        .then((value) => supabaseHandler.from('contact').insert({
              'id': supabaseHandler.auth.currentUser!.id,
              'username': username
            }));

    if (response.user != null) {
      // hideLoading();
      // messageWithSucces('SignUp Succes, Check Confirm Email');
      // await supabase
      //     .from('contact')
      //     .insert({'id': response.user!.id, 'username': username});
      // Get.offAll(LoginView());
    }
    // } on AuthException catch (error) {
    //   final snackBar = SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text('${error.message}'),
    //   );
    //   ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    // } catch (error) {
    //   final snackBar = SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text('Unexpected error occurred'),
    //   );
    //   ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    // } finally {
    //   hideLoading();
  }

  Future<void> login({required final String email}) async {
    try {
      // showLoading();
      await supabaseHandler.auth.signInWithOtp(
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
          email: email);

      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Cek email confirm login..'),
      );
      ScaffoldMessenger.of(Get.currentContext).showSnackBar(snackBar);
      // hideLoading();
    } on AuthException catch (error) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('${error.message}'),
      );
      ScaffoldMessenger.of(Get.currentContext).showSnackBar(snackBar);
    } catch (error) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Unexpected error occurred'),
      );
      ScaffoldMessenger.of(Get.currentContext).showSnackBar(snackBar);
    } finally {
      // hideLoading();
    }
  }

  bool isSignIn() {
    return (supabaseHandler.auth.currentUser == null) ? false : true;
  }

  signOut() async {
    await supabaseHandler.auth.signOut();
  }

  authState() {
    authStateSubscription =
        supabaseHandler.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;

      if (session != null) {
        _redirecting = true;
        Get.offAll(MainNavigationView());
      }
    });
  }
}
