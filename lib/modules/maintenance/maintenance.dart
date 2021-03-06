import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'cookie_manager.dart';
import 'models.dart';

export 'models.dart';

const _maintenanceUrl = 'https://app.xmu.edu.my/Maintenance';

class Maintenance {
  final _dio = Dio()
    ..interceptors.add(NBCookieManager(CookieJar()))
    ..options.baseUrl = _maintenanceUrl;

  final String _uid, _password;

  /// Future for login procedure.
  Future<void> loginFuture;

  Maintenance(this._uid, this._password);

  /// Ensure login successfully.
  Future<void> ensureSignedIn() async {
    if (loginFuture == null) loginFuture = login();
    await loginFuture;
  }

  /// Login with given credential.
  Future<void> login() async {
    try {
      var loginPage = await _dio.get('/Account/Login');
      var token = parse(loginPage.data)
          .querySelector('[name="__RequestVerificationToken"]')
          .attributes['value'];

      await _dio.post(
        '/Account/Login',
        data: {
          '__RequestVerificationToken': token,
          'CampusID': this._uid,
          'Password': this._password
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          followRedirects: true,
        ),
      );
    } on DioError catch (e) {
      if (e.response == null || e.response.statusCode != 302) rethrow;
      if (e.response.statusCode == 302) return;
    }
  }

  /// Get FAQs in given page.
  static Future<List<FaqQuestion>> getFaq({int page = 1}) async {
    var faqPageResp = await Dio().get('$_maintenanceUrl/?p=$page');

    var faqPage =
        parse(faqPageResp.data).querySelector('.table').querySelectorAll('td');
    List<FaqQuestion> questionList = [];
    for (var i = 0; i < faqPage.length; i += 2)
      questionList.add(FaqQuestion(
        id: int.parse(faqPage[i]
            .nodes[0]
            .text
            .replaceAll(RegExp(r'^\s+|\s+$|\n|\.'), '')),
        date: DateFormat('yyyy-MM-dd').parse(
            faqPage[i].nodes[2].text.replaceAll(RegExp(r'^\s+|\s+$|\n'), '')),
        title: faqPage[i].nodes[1].text.replaceAll(RegExp(r'^\s+|\s+$|\n'), ''),
        answer: faqPage[i + 1]
            .children[0]
            .children
            .map((e) => e.text)
            .join('\n')
            .replaceAll(RegExp(r'^\s+|\s+$'), ''),
      ));

    return questionList;
  }

  /// Get my requests.
  Future<List<MyRequest>> get myRequests async {
    await ensureSignedIn();
    var myRequestPageResp = await _dio.get('/Reader/Ask');

    var myRequestPage = parse(myRequestPageResp.data)
        .querySelector('.table')
        .querySelectorAll('td');
    List<MyRequest> myRequests = [];

    for (var i = 0; i < myRequestPage.length; i += 2) {
      var titles = myRequestPage[i]
          .nodes[1]
          .text
          .replaceAll(RegExp(r'^\s+|\s+$|\n'), '')
          .split(' - ');
      myRequests.add(MyRequest(
        id: myRequestPage[i]
            .nodes[0]
            .text
            .replaceAll(RegExp(r'^\s+|\s+$|\n|\.'), ''),
        date: DateFormat('yyyy/MM/dd HH:mm:ss').parse(myRequestPage[i]
            .nodes[2]
            .text
            .replaceAll(RegExp(r'^\s+|\s+$|\n'), '')),
        title: titles[2],
        category: titles[1],
        usage: titles[0],
        answer: myRequestPage[i + 1]
            .children
            .map((e) => e.text)
            .join('\n')
            .replaceAll(RegExp(r'^\s+|\s+$'), ''),
      ));
    }

    return myRequests;
  }

  /// Get my form.
  Future<RequestForm> get form async {
    await ensureSignedIn();
    var askPageResp = await _dio.get('/Reader/Ask/Create');
    var askPage = parse(askPageResp.data);
    var selections = ['#RoomUsage', '#Category', '#Block', '#Wing']
        .map((d) => askPage
            .querySelector(d)
            .querySelectorAll('option')
            .map((e) => e.text)
            .toList()
              ..removeAt(0))
        .toList();

    return RequestForm(
      usages: selections[0],
      categories: selections[1],
      blocks: selections[2],
      wings: selections[3],
      gender: askPage.querySelector('#Gender').attributes['value'],
      name: askPage.querySelector('#Name').attributes['value'],
      email: askPage.querySelector('#Email').attributes['value'],
      token: askPage
          .querySelector('[name="__RequestVerificationToken"]')
          .attributes['value'],
      phoneNumber: askPage.querySelector('#Telephone').attributes['value'],
    );
  }

  /// Submit form.
  Future<Null> submitForm(RequestForm form) async {
    await ensureSignedIn();
    var formData = FormData.fromMap({
      'agree': 'true',
      '__RequestVerificationToken': form.token,
      'Gender': form.gender,
      'CampusID': _uid,
      'Name': form.name,
      'Email': form.email,
      'RoomUsage': form.usage,
      'Category': form.category,
      'Block': form.block,
      'Wing': form.wing,
      'RoomNo': form.room,
      'Description': form.description,
      'Telephone': form.phoneNumber,
      'RecurringProblem': form.recurringProblem ? 'yes' : 'no',
      if (form.file != null)
        'FileName': await MultipartFile.fromFile(
          form.file.path,
          filename: 'pic.jpg',
          contentType: MediaType.parse('image/jpeg'),
        )
    });

    await _dio.post('/Reader/Ask/Create',
        data: formData, options: Options(validateStatus: (s) => s == 302));
  }
}
