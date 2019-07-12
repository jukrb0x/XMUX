import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xmux/config.dart';
import 'package:xmux/globals.dart';
import 'package:xmux/modules/attendance/attendance.dart';
import 'package:xmux/modules/sketch/sketch.dart';
import 'package:xmux/modules/xmux_api/xmux_api_v2.dart';
import 'package:connectivity/connectivity.dart';

class SignInButton extends StatefulWidget {
  /// Current Lesson.
  final Lesson lesson;

  /// The lesson can sign in now if satisfy following condition.
  ///
  /// - Date match.
  /// - LessonStart-30min < CurrentTime < LessonStart+30min.
  final bool _canSign;

  SignInButton(this.lesson)
      : this._canSign = lesson.dayOfWeek == DateTime.now().weekday - 1;

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  Future<Null> _showSignInDialog() async {
    SystemChrome.setPreferredOrientations([...DeviceOrientation.values]);

    var image = await showDialog<ui.Image>(
      context: context,
      builder: (ctx) => _buildSignatureSketch(ctx),
    );

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    var bytes = (await image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();

    var ip = await Connectivity().getWifiIP();
    if (ip == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Cannot get your address. Please connect to WiFi and try again.')));
      return;
    }

    var res = await AttendanceApi(BackendApiConfig.signInAddress).attend(
        store.state.authState.campusID, widget.lesson.courseCode, ip, bytes);

    if (res.status == AttendStatus.failed)
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(res.message)));
  }

  Widget _buildSignatureSketch(BuildContext ctx) {
    var key = GlobalKey<SketchState>();

    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Card(
          margin: const EdgeInsets.all(10.0),
          child: Stack(children: <Widget>[
            SizedBox.expand(child: Sketch(key: key)),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text(
                'Sign your name here | Landscape to get better experience',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Positioned(
              right: 8.0,
              bottom: 8.0,
              child: FloatingActionButton(
                child: Icon(Icons.done),
                onPressed: () async =>
                    Navigator.of(ctx).pop(await key.currentState.image),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget._canSign
      ? FlatButton(
          onPressed: _showSignInDialog,
          child: Text(i18n('Calendar/SignIn', context)),
        )
      : Container();
}
