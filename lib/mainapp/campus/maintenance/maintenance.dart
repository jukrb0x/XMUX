import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:xmux/components/page_routes.dart';
import 'package:xmux/globals.dart';
import 'package:xmux/modules/maintenance/maintenance.dart';

part 'faq.dart';
part 'my_requests.dart';
part 'request_form.dart';

class MaintenancePage extends StatelessWidget {
  final maintenance = Maintenance(
      store.state.authState.campusID, store.state.authState.campusIDPassword)
    ..ensureLogin();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Maintenance'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'My Requests'),
              Tab(text: 'FAQ'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MyRequestsPage(maintenance),
            FaqPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(FadePageRoute(
            child: RequestFormPage(maintenance),
            fullscreenDialog: true,
          )),
        ),
      ),
    );
  }
}
