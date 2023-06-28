import 'dart:io';

import 'package:flutter/material.dart';

import '../main.dart';

class SupabaseHandler {
  static String supabaseURL = "https://isycyynxhwdoyripictp.supabase.co";
  static String supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeWN5eW54aHdkb3lyaXBpY3RwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODczMzkzMzIsImV4cCI6MjAwMjkxNTMzMn0.VKA8y7Z37TrynBQahUrgXIcxwcBBdhfGXnMctb73MCk";

  // final client = SupabaseClient(supabaseURL, supabaseKey);

  var response = supabaseHandler.from("chat").stream(primaryKey: ['id']);

  getRoom(int id) async {
    await supabaseHandler
        .rpc('update_latest_message_created_at', params: {'chat_id_param': id});
  }

  doAsReadAll(int roomId) async {
    await supabaseHandler.rpc('update_rec_mark_as_read_new',
        params: {'chat_id_param': roomId, 'mark_as_read_param': true});

    await supabaseHandler
        .rpc('update_read_message', params: {'room_id': roomId});
  }

  uploadImageFile(File image, String filename) {
    supabaseHandler.storage
        .from("chat")
        .upload(image.path, image)
        .then((value) => {debugPrint("line24 ${value.toString()}")});
  }

  // getChatMessages(String chatId) async {
  //   var response = await supabaseHandler
  //       .from('chatMessages')
  //       .select()
  //       // .eq("chatid",chatId)
  //       .execute();

  //   final datalist = response.data as List;
  //   return datalist;
  // }

  getLatestCustomers() async {
    var response = await supabaseHandler
        .from("profiles")
        .select("id,username")
        .neq('id', supabaseHandler.auth.currentUser!.id)
        .limit(50)
        .execute();
    debugPrint("line24 ${response.toString()}");
    final datalist = response.data as List;
    return datalist;
  }
}
