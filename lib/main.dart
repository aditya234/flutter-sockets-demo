import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(
        channel: IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final WebSocketChannel channel;

  const Home({Key key, this.channel}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Socket Demo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(labelText: "Send a message"),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, dataSnapshot) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      (dataSnapshot.hasData) ? "${dataSnapshot.data}" : ""),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.text.isNotEmpty) {
            widget.channel.sink.add(controller.text);
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
