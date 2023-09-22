import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchRandomDogImage();
  }

  Future<void> _fetchRandomDogImage() async {
    final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newImageUrl = data['message'];

      if (newImageUrl != null && newImageUrl.isNotEmpty) {
        setState(() {
          imageUrl = newImageUrl;
        });
      }
    }
  }

  void _copyImageUrlToClipboard() {
    Clipboard.setData(ClipboardData(text: imageUrl))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image URL has been copied to clipboard.'),
        ),
      );
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not copy image URL: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DogImage(imageUrl),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchRandomDogImage,
              child: const Text('Generate random image'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _copyImageUrlToClipboard,
              child: const Text('Copy URL to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class DogImage extends StatelessWidget {
  final String imageUrl;

  DogImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: 500,
      height: 300,
      fit: BoxFit.cover,
    );
  }
}
