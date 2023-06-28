import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../view/message_view.dart';

class MessageController extends State<MessageView> {
  static late MessageController instance;
  late MessageView view;
  var now = DateTime.now();

  // String get kkmmss {
  //   if (currentDate == null) return "_";
  //   return DateFormat("kk:mm:ss").format(currentDate!);
  // }

  String getCurrentTime(String? time) {
    if (time == null) return "_";
    DateTime date = DateTime.parse(time);
    return DateFormat("kk:mm:ss").format(date);
  }

  String getCurrentDate(String? time) {
    if (time == null) return "_";
    DateTime date = DateTime.parse(time);
    return DateFormat("yyyy-MM-dd").format(date);
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
