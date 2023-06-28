import 'package:flutter/material.dart';

import '../../../service/SupaHandler.dart';
import '../controller/contact_controller.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  Widget build(context, ContactController controller) {
    controller.view = this;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              builder: (context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Icon(Icons.error);
                    else if (snapshot.data == null)
                      return Icon(Icons.error);
                    else
                      Icon(Icons.error);
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, position) {
                        var item = snapshot.data[position];
                        return GestureDetector(
                          onTap: () async {
                            controller.checkChat(item['id'], item['username']);
                            // _checkChat(snapshot.data[position]['id'], snapshot.data[position]['username']);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://i.ibb.co/S32HNjD/no-image.jpg"),
                                ),
                                title: Text("${item['username']}"),
                                // subtitle: Text("john.doe@gmail.com"),
                                // trailing: Icon(
                                //   Icons.add,
                                //   size: 24.0,
                                // ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                }
              },
              future: SupabaseHandler().getLatestCustomers(),
            ))
          ],
        ),
      ),
    );
  }

  @override
  State<ContactView> createState() => ContactController();
}
