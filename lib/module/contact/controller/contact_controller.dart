import 'package:flutter/material.dart';
import 'package:hyper_ui/shared/util/show_loading/show_loading.dart';

import '../../../main.dart';
import '../view/contact_view.dart';
import '../widget/chatPage.dart';

class ContactController extends State<ContactView> {
  static late ContactController instance;
  late ContactView view;

  bool loading = false;

  checkChat(String id, String name) async {
    final result = await supabaseHandler
        .from('chat')
        .select('*')
        .or('sender.eq.${id},sender.eq.${supabaseHandler.auth.currentUser!.id}')
        .or('rec.eq.${supabaseHandler.auth.currentUser!.id},rec.eq.${id}');

    List datalist = result;

    var item;

    if (datalist.length > 0) {
      for (var i = 0; i < datalist.length; i++) {
        item = datalist[i];
        print('cekk yaa ${datalist}');
      }
      Navigator.of(context).push(ChatPage.route(item['id'], id, name));
    } else {
      showLoading();
      final res = await supabaseHandler
          .from("profiles")
          .select("id,username")
          .eq('id', supabaseHandler.auth.currentUser!.id)
          .limit(50)
          .single();
      final value = await supabaseHandler.from("chat").insert({
        'rec': id,
        'sender': supabaseHandler.auth.currentUser!.id,
        'sendname': res['username'],
        'recname': name,
      });

      final chatValue = await supabaseHandler
          .from('chat')
          .select('*')
          .or('sender.eq.${id},sender.eq.${supabaseHandler.auth.currentUser!.id}')
          .or('rec.eq.${supabaseHandler.auth.currentUser!.id},rec.eq.${id}')
          .single();
      hideLoading();
      Navigator.of(context).push(ChatPage.route(chatValue['id'], id, name));

      // final res = await supabaseHandler
      //     .from("profiles")
      //     .select("id,username")
      //     .eq('id', supabaseHandler.auth.currentUser!.id)
      //     .limit(50)
      //     .then((value) => supabaseHandler.from("chat").insert({
      //           'rec': id,
      //           'sender': supabaseHandler.auth.currentUser!.id,
      //           'sendname': value[0]['username'],
      //           'recname': name
      //         }).then((value) => supabaseHandler
      //             .from('chat')
      //             .select('*')
      //             .or(
      //                 'sender.eq.${id},sender.eq.${supabaseHandler.auth.currentUser!.id}')
      //             .or(
      //                 'rec.eq.${supabaseHandler.auth.currentUser!.id},rec.eq.${id}')
      //             .then((value) => Navigator.of(context)
      //                 .push(ChatPage.route(value[0]['id'], id, name)))));
    }
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
