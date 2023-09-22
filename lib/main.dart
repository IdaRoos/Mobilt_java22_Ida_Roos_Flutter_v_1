import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nextPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home page'),
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
  String _text = "";
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }


  Future<void> _loadSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _text = prefs.getString('savedText') ?? "";
      _textController.text = _text; // Uppdaterar TextFormTextField med den sparade texten
    });
  }

  Future<void> _saveText(String newText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedText', newText);
  }

  void _updateText(String newText) {
    setState(() {
      _text = newText;
      _saveText(newText); // Sparar texten när användaren ändrar TextFormField
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text('Welcome!'),
            ),

            TextFormField(
              controller: _textController, // Kopplar TextFormTextField till controller
              decoration: const InputDecoration(
                labelText: 'Write something',),
              onChanged: (value) {
                _updateText(value);
              },
            ),


            Row(
              children: <Widget>[
                const Text("Recent input: "),
                Text(_text), // Visa den uppdaterade texten
              ],
            ),



            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()),
                );
              },
              child: const Text('Go to next page'),
            ),

            const Center(
              child: Align(
                alignment: Alignment.topRight,
                child: Text('Top right item.'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
