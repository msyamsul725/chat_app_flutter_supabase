import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/main.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  Widget build(context, DashboardController controller) {
    controller.view = this;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Hi ${supabaseHandler.auth.currentUser!.email}'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Message')),
                  Tab(child: Text('Contact')),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            MessageView(),
            ContactView(),
          ],
        ),
      )),
    );
  }

  @override
  State<DashboardView> createState() => DashboardController();
}
