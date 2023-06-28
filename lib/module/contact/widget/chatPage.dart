import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_ui/service/SupaHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../model/Message.dart';

class ChatPage extends StatefulWidget {
  static Route<void> route(int roomId, String recId, String recName) {
    return MaterialPageRoute(builder: (_) => ChatPage(roomId, recId, recName));
  }

  final int roomId;
  final String recId;
  final String recName;

  const ChatPage(this.roomId, this.recId, this.recName, {Key? key})
      : super(key: key);

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
  var _listner;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFfcf4e4)),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xFF756d54),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://i.ibb.co/S32HNjD/no-image.jpg",
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.recName,
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: StreamBuilder<List<Message>>(
                    stream: getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Text("Error");
                      // if (snapshot.data!.isEmpty) {
                      //   return const Text("No Data");
                      // }
                      if (snapshot.data == null) return Container();
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        reverse: true,
                        itemBuilder: (_, index) {
                          final message = snapshot.data![index];
                          final user = message.userId;
                          final mtype = message.mtype;
                          final isMyChat =
                              user == supabaseHandler.auth.currentUser!.id;
                          final isTM = mtype == 0;
                          List<Widget> chatContents = [
                            if (!isMyChat) ...[
                              // CircleAvatar(
                              //   radius: 25,
                              //   child: Text(widget.recName),
                              // ),
                              // const SizedBox(
                              //   width: 12,
                              // ),
                            ],
                            Flexible(
                                child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: isMyChat ? Colors.grey : Colors.red,
                              elevation: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        message.message,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Row(
                                          children: [
                                            Text(
                                              getCurrentTime(message.insertedAt
                                                  .toString()),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6.0,
                                            ),
                                            Icon(
                                              Icons.done_all,
                                              size: 16.0,
                                              color: message.asRead == true
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            )),
                          ];
                          if (isMyChat) {
                            chatContents = chatContents.reversed.toList();
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: isMyChat
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: chatContents,
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                      );
                    })),
            _MessageInput(
                roomId: widget.roomId,
                onSend: (message) {
                  setState(() {
                    _messages.insert(0, message);
                  });
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // getChats();
    doAsRead();
  }

  doAsRead() async {
    await SupabaseHandler().doAsReadAll(widget.roomId);
  }

  String getCurrentTime(String? time) {
    if (time == null) return "_";
    DateTime date = DateTime.parse(time);
    return DateFormat("kk:mm").format(date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _listner.unsubscribe();
  }

  Stream<List<Message>> getMessages() {
    return supabaseHandler
        .from("chatmessages")
        .stream(primaryKey: ['id'])
        .eq('chat_id', widget.roomId)
        .order('created_at')
        .map((event) => Message.fromRows(event));
  }

  // setState(() {
  //   _messages = messages;
  //   _isLoading = false;
  // });
}

class _MessageInput extends StatefulWidget {
  const _MessageInput({
    Key? key,
    required this.roomId,
    required this.onSend,
  }) : super(key: key);

  final int roomId;
  final void Function(Message) onSend;

  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  TextEditingController textController = TextEditingController();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(),
                child: TextFormField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Tulis Pesan',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: IconButton(
                onPressed: () async {
                  final message = textController.text;
                  if (message.isEmpty) {
                    return;
                  }

                  final sendingMessage = Message(
                    id: 0,
                    userId: supabaseHandler.auth.currentUser!.id,
                    insertedAt: DateTime.now(),
                    message: message,
                    asRead: false,
                    mtype: 0,
                  );
                  widget.onSend(sendingMessage);
                  final result =
                      await supabaseHandler.from('chatmessages').insert({
                    'content': message,
                    'sender': supabaseHandler.auth.currentUser!.id,
                    'chat_id': widget.roomId,
                    'mtype': 0
                  }).execute();
                  textController.clear();
                  await SupabaseHandler().getRoom(widget.roomId);

                  await SupabaseHandler().doAsReadAll(widget.roomId);

                  if (result.data != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("error occured")));
                  }
                  textController.clear();
                },
                icon: const Icon(
                  Icons.send_outlined,
                  size: 36,
                ),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {});
        _upload();
      }
    }
  }

  Future<void> _upload() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final response = await supabaseHandler.storage
        .from('chat')
        .updateBinary(filePath, bytes);

    final error = response;
    Fluttertoast.showToast(msg: 'error');
    return;

    // final imageUrlResponse = supabaseHandler.storage.from('chat').getPublicUrl(filePath);
    // _onUpload(imageUrlResponse);
  }

  // Future<void> _onUpload(String imageUrl) async {
  //   final response = await supabaseHandler.from('chatMessages').insert({
  //     'content':imageUrl,
  //     'sender':1,
  //     'chatid':widget.roomId,
  //     'mtype':1
  //   }).execute();

  //   final error = response;
  //   if(error != null) {
  //     Fluttertoast.showToast(msg: 'error');
  //     return;
  //   }
  //   Fluttertoast.showToast(msg: 'Uploaded Image!');
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // textController.dispose();
    super.dispose();
  }
}
