import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String? ipAddress;

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  Future<void> _checkConnection() async {
    String url;
    if (ipAddress == null) {
      // Get the IP from the input
      // Assuming you have an TextEditingController for the TextField
    } else {
      url = 'http://$ipAddress:8000/confirm';
      var response = await http.get(Uri.parse(url));

      if (response.body == 'OK') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('接続OK'),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('初期画面')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              ipAddress = value;
            },
            decoration: InputDecoration(labelText: 'IP Address'),
          ),
          ElevatedButton(
              onPressed: () => _navigateToScreen(FirstExperimentScreen(ipAddress!)),
              child: Text('前半実験')),
          ElevatedButton(
              onPressed: () => _navigateToScreen(SecondExperimentScreen(ipAddress!)),
              child: Text('後半実験')),
          ElevatedButton(onPressed: _checkConnection, child: Text('接続確認'))
        ],
      ),
    );
  }
}

class FirstExperimentScreen extends StatefulWidget {
  final String ipAddress;

  FirstExperimentScreen(this.ipAddress);

  @override
  _FirstExperimentScreenState createState() => _FirstExperimentScreenState();
}

class _FirstExperimentScreenState extends State<FirstExperimentScreen> {
  late Timer _timer;
  int _start = 300;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _postAction(String action) async {
    var url = 'http://${widget.ipAddress}:8000/start_action';
    var response = await http.post(Uri.parse(url), body: {'action': action});

    String message;
    if (response.body == 'success') {
      message = '成功';
    } else {
      message = 'エラー';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('前半実験画面')),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                bool? result = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('行動を変えますか?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('OK')),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'))
                        ],
                      );
                    });

                if (result == true) {
                  _postAction('cooking');
                }
              },
              child: Text('調理')),
          // ... Add other buttons here ...
          Text('Time: ${_start.toString()}')
        ],
      ),
    );
  }
}

// You can add the SecondExperimentScreen similarly...
