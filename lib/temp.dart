import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cowin/idpage.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'idpage.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

var txnid;
var token;
String path = "";
Future<http.Response> postRequest() async {
  print('-------------------------in post------------');
  Map data = {'mobile': '9423119290'};
  //encode Map to JSON
  var body = json.encode(data);
  var url = 'https://cdn-api.co-vin.in/api/v2/auth/public/generateOTP';

  var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: body);
  print('status codes----------------------');
  print("${response.statusCode}");
  print("${response.body}");
  Map<String, dynamic> user = jsonDecode(response.body);
  print(user['txnId']);
  txnid = user['txnId'];
  print(txnid);
  return response;
}

Future<http.Response> postRequest2(String value) async {
  print('otp is');
  print(value);
  print('-------------------------in post2------------');
  var x = sha256.convert(utf8.encode(value));
  print("Value of x is ");
  print(x);
  Map data = {'otp': x.toString(), 'txnId': txnid.toString()};
  //encode Map to JSON
  var body = json.encode(data);
  var url = 'https://cdn-api.co-vin.in/api/v2/auth/public/confirmOTP';

  var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: body);
  print('status codes----------------------');
  print("${response.statusCode}");
  print("${response.body}");
  Map<String, dynamic> user = jsonDecode(response.body);
  print(user['token']);
  token = user['token'];
  /*Map<String, String> r = response.body as Map<String, String>;
  print(r.values.first);*/
  return response;
}

var image;

Future<Uint8List> postRequest3(String id) async {
  print('token is');
  print(token);
  print('id is');
  print(id);
  print('-------------------------in post3------------');
  //encode Map to JSON

  var url =
      'https://cdn-api.co-vin.in/api/v2/registration/certificate/public/download?beneficiary_reference_id=$id';

  final response = await http.get(Uri.parse(url), headers: {
    "Content-Type": "application/pdf",
    'Authorization': 'Bearer $token',
    'responseType': 'blob'
  });
  print('status codes of post 3----------------------');
  print("${response.statusCode}");

  final responseJson = response.bodyBytes;

  return responseJson;
  /* print("${response}");
  var x = response;

  print(x.body);
  print("Text is-----------");
  //print(x.bodyBytes);
  final file = await _localFile;
  List<int> lt = [];
  for (int i = 0; i < 100; i++) {
    lt.add(x.bodyBytes[i]);
  }*/
  //lt.addAll(x.bodyBytes);

  //readCounter();
  //Map<String, dynamic> user = jsonDecode(response.body);

  /*Map<String, String> r = response.body as Map<String, String>;
  print(r.values.first);*/
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/teste.pdf');
}

Future<File> writeCounter(Uint8List stream) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsBytes(stream);
}

/*Future<Uint8List> fetchPost() async {
  var url =
      'https://cdn-api.co-vin.in/api/v2/registration/certificate/public/download?beneficiary_reference_id=$id';

  final response = await http.get(Uri.parse(url));
  final responseJson = response.bodyBytes;

  return responseJson;
}*/
Future<Uint8List> fetchPost() async {
  var url = 'https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf';

  final response = await http.get(Uri.parse(url));
  final responseJson = response.bodyBytes;

  return responseJson;
}

loadPdf() async {
  //writeCounter(await postRequest3('7531153960309'));
  writeCounter(await fetchPost());
  path = (await _localFile).path;
}

void main() {
  PdfView.platform = SurfaceAndroidPdfViewer();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //postRequest(); //method
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _MyAppState());
  }
  //Your code here
}

class _MyAppState extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Create Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Create Data Example'),
            ),
            body: Container(
              child: Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      postRequest();
                    },
                    child: Text('Request OTP'),
                  ),
                  TextField(
                    onSubmitted: (value) => {
                      postRequest2(value),
                    },
                    decoration:
                        new InputDecoration(labelText: "Enter your number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewScreen()));
                      },
                      child: Text('Next Page')),
                  Column(
                    children: <Widget>[
                      if (path != null)
                        Container(
                          height: 300.0,
                          child: PdfView(
                            path: path,
                          ),
                        )
                      else
                        Text("Pdf is not Loaded"),
                      RaisedButton(
                        child: Text("Load pdf"),
                        onPressed: loadPdf,
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
