import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Annotaion APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "http://127.0.0.1:8080";
  final ipAddressKey = 'ip';
  var currentSessionID;
  //late var url;
  final urlController = TextEditingController();

  void _setUrl(String e) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      url = e;
      prefs.setString(ipAddressKey, e);
    });
  }

  void readIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      url = prefs.getString(ipAddressKey)!;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentSession(url);
    readIpAddress();
  }

  void sendAction(String action, String url) {
    //late var inquiryRequestResult;
    String url_ = url + "/start_action";
    var request = new actionRequest(action: action);
    try {
      final response = http.post(Uri.parse(url_),
          body: json.encode(request.toJson()),
          headers: {"Content-Type": "application/json"});
    } catch (e) {}
  }

  void changeSession(String url) async {
    //late var inquiryRequestResult;
    String url_ = url + "/change_session";
    Navigator.pop(context);
    try {
      final response = await http
          .get(Uri.parse(url_), headers: {"Content-Type": "application/json"});
      setState(() {
        currentSessionID =
            ApiResults.fromJson(json.decode(response.body)).toString();
      });
    } catch (e) {}
  }

  void getCurrentSession(String url) async {
    //late var inquiryRequestResult;
    String url_ = url + "/current_session";
    final response = await http
        .get(Uri.parse(url_), headers: {"Content-Type": "application/json"});
    setState(() {
      currentSessionID = response.body;
    });
  }

  void stopAction(String url) {
    //late var inquiryRequestResult;
    String url_ = url + "/stop_action";
    try {
      final response = http.get(Uri.parse(url_));
    } catch (e) {}
  }

  confirmSessionChange(String url) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("セッションを変えますか？"), actions: <Widget>[
              GestureDetector(
                child: Text('いいえ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: Text('はい'),
                onTap: () => changeSession(url),
              ),
            ]));
  }

  showCurrentSession(String url) async {
    getCurrentSession(url);
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("現在のセッション"), actions: <Widget>[
              Text(currentSessionID),
              GestureDetector(
                child: Text('OK'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: [
          IconButton(
            icon: Icon(Icons.cached),
            onPressed: () => confirmSessionChange(url),
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () => stopAction(url),
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () => showCurrentSession(url),
          ),
        ]),
        body: Center(
          child: ListView(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Server Url"),
                  controller: urlController,
                ),
                ElevatedButton(
                  child: Text("設定"),
                  onPressed: () => _setUrl(urlController.text),
                ),
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('その他'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("other", url),
                      child: Text('その他'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => sendAction("None", url),
                        child: Text("無し"))),
                // Special Rooms
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('----------------'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("cooking", url),
                      child: Text('調理'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("eating", url),
                      child: Text('食事'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("bathing", url),
                      child: Text('入浴'),
                    )),
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('----------------'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("watchingTV", url),
                      child: Text('テレビ視聴'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("toileting", url),
                      child: Text('トイレ'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => sendAction("sleeping", url),
                      child: Text('睡眠'),
                    )),
                Text(url),
                Text(currentSessionID.toString())
              ],
            ),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class ApiResults {
  final String message;
  ApiResults({
    this.message = '',
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      message: json['message'],
    );
  }
}

class actionRequest {
  final String action;
  actionRequest({
    this.action = '',
  });
  Map<String, dynamic> toJson() => {
        'action': action,
      };
}
