import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:typed_data';

const NULL = 0;

const MAX_PATH = 260;
// SHFOLDERAPI SHGetFolderPathW(
//   HWND   hwnd,
//   int    csidl,
//   HANDLE hToken,
//   DWORD  dwFlags,
//   LPWSTR pszPath
// );
typedef shGetFolderPathNative = Int32 Function(Int64 hwnd, Int32 csidl,
    Int64 hToken, Int32 dwFlags, Pointer<Uint16> pszPath);
typedef shGetFolderPathDart = int Function(
    int hwnd, int csidl, int hToken, int dwFlags, Pointer<Uint16> pszPath);
final shell32 = DynamicLibrary.open('shell32.dll');

final SHGetFolderPath =
    shell32.lookupFunction<shGetFolderPathNative, shGetFolderPathDart>(
        'SHGetFolderPathW');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    // Find user document folder
    final CSIDL_PERSONAL = 0x0005;
    final CSIDL_FLAG_CREATE = 0x8000;
    Pointer<Uint16> path = allocate<Uint16>(count: MAX_PATH);
    final result = SHGetFolderPath(
        NULL, CSIDL_PERSONAL | CSIDL_FLAG_CREATE, NULL, 0, path);
    print(result.toString());
    Uint16List pathData = path.asTypedList(MAX_PATH);
    print(String.fromCharCodes(
        path.asTypedList(MAX_PATH), 0, pathData.indexOf(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
