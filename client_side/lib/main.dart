import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
  //late var url;
  final urlController = TextEditingController();
  var inquiryRequestResult;

  void _setUrl(String e) {
    print(url);
    setState(() {
      url = e;
    });
  }

  void sendAction(String action, String url) {
    //late var inquiryRequestResult;
    String url_ = url + "/start_action";
    var request = new inquiryRequest(action: action);
    final response = http.post(Uri.parse(url_),
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    // if (response.statusCode == 200) {
    //   setState(() {
    //     inquiryRequestResult = ApiResults.fromJson(json.decode(response.body));
    //   });
    // } else {
    //   throw Exception('Failed');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // TextFormField(
                //     enabled: true,
                //     style: TextStyle(color: Colors.red),
                //     obscureText: false,
                //     maxLines: 1,
                //     onSaved: (value) => () {
                //           _setUrl(
                //               '$value'); // this._formKey.currentState.save()でコールされる
                //           print('$value');
                //         }),
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
                        onPressed: () {}, //sendAction("None", url),
                        child: Text("無し"))),
                // Special Rooms
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('風呂、トイレ等'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("bathing", url),
                      child: Text('入浴'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("toileting", url),
                      child: Text('排泄'),
                    )),
                // Living Room activities
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('リビング'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("cooking", url),
                      child: Text('調理'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("eating", url),
                      child: Text('食事'),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("TV", url),
                      child: Text('テレビ視聴'),
                    )),
                //　Bed Room Activities
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Text('寝室'),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {}, //sendAction("sleeping", url),
                      child: Text('睡眠'),
                    )),
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

class inquiryRequest {
  final String action;
  inquiryRequest({
    this.action = '',
  });
  Map<String, dynamic> toJson() => {
        'action': action,
      };
}
