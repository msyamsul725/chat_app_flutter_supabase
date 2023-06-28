import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../service/SupaHandler.dart';
import '../../contact/widget/chatPage.dart';
import '../controller/message_controller.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  Widget build(context, MessageController controller) {
    controller.view = this;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              builder: (context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List filteredList = snapshot.data.where((data) {
                      // Kondisi filter di sini
                      return (data['sender'] ==
                                  supabaseHandler.auth.currentUser!.id ||
                              data['rec'] ==
                                  supabaseHandler.auth.currentUser!.id) &&
                          data['latest_messages_created_at'] != null;
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, position) {
                        var item = filteredList[position];
                        bool isMine =
                            supabaseHandler.auth.currentUser!.id == item["rec"];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(ChatPage.route(
                                item["id"],
                                isMine ? item['sender'] : item['rec'],
                                isMine ? item['sendname'] : item['recname']));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(
                                              "https://i.ibb.co/S32HNjD/no-image.jpg"),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  isMine
                                                      ? item['sendname'] ?? ""
                                                      : item['recname'] ?? "",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  item['mark_as_read'] == true
                                                      ? ""
                                                      : item['mark_as_read'] ==
                                                              null
                                                          ? ''
                                                          : "( Pesan Baru )",
                                                  style: TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              item['latest_message'] ?? "",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              controller.getCurrentDate(item[
                                                  'latest_messages_created_at']),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12.0,
                                            ),
                                            Text(
                                              controller.getCurrentTime(item[
                                                  'latest_messages_created_at']),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Text(item['content'],
                                    //     style: TextStyle(fontSize: 12.0))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                }
              },
              stream: SupabaseHandler().response,
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<MessageView> createState() => MessageController();
}
