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
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:pdf_text/pdf_text.dart';
import 'package:flutter/material.dart';

bool flag = false;
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

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

var p;
Future<File> get _localFile async {
  final path = await _localPath;
  //print('the path is----------');
  //print(path);
  p = path;
  return File('$path/example.pdf');
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
Future<String> readcontent(File file) async {
  print('The content is here');
  try {
    // Read the file
    print('The content is here 2');
    String contents = await file.readAsString();
    print('The content is');
    print(contents);
    return contents;
  } catch (e) {
    // If there is an error reading, return a default String
    return 'Error';
  }
}

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

  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(response.body),
        );
      }));

  final file = await _localFile;
  await file.writeAsBytes(await pdf.save());
  print('reding content now');
  //readcontent(file);
  //PDFDoc _pdfDoc;
  String _text;
  print('path is -------------------');
  print(p);
  //await launch('https://www.example.com/example.pdf');
  print('DONE');
  //_pdfDoc = await PDFDoc.fromPath('$p/example.pdf');
  //_text = await _pdfDoc.text;
  //print('Printing from the pdf');
  //print(_text);
  flag = true;
  return response.bodyBytes;
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

/*foo() async {
  print('in foo');
  print('value of p is');
  print(p);

  final file = File('$p/example.pdf');

  return await PDFDocument.fromFile(file);
}*/

void main() {
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
                  /* Center(
                      child: flag
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              height: 100, child: PDFViewer(document: foo()))),*/
                ],
              ),
            )));
  }
}
