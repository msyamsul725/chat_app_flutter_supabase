import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/service/supabase_auth_service.dart';

class ProfileController extends State<ProfileView> implements MvcController {
  static late ProfileController instance;
  late ProfileView view;
  doLogout() async {
    await AuthServiceSupabase().signOut();
    Get.offAll(LoginView());
  }

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
