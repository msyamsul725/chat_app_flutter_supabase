import 'package:flutter/material.dart';

import '../../../service/supabase_auth_service.dart';
import '../view/login_view.dart';

class LoginController extends State<LoginView> {
  static late LoginController instance;
  late LoginView view;

  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool signUp = true;
  final formKey = GlobalKey<FormState>();
  doLogin() async {
    await AuthServiceSupabase().login(
      email: email.text,
    );
  }

  doCreateUser() async {
    await AuthServiceSupabase().createUser(
        email: email.text, password: password.text, username: username.text);
  }

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
