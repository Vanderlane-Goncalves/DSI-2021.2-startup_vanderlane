import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup-Vanderlane Generator',
      theme: ThemeData.dark(),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  
  bool _listPair = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Vanderlane Generator'),
          leading: IconButton(
            onPressed: () {
              setState(() {
                _listPair ? _listPair = false : _listPair = true;
              });
            },
            icon: Icon(_listPair ? Icons.grid_view : Icons.list),
          ),
        ),
        body: _buildSuggestions());
  }

  Widget _buildSuggestions() {
    if (_listPair) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4,
          crossAxisCount: 2,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 6.0,
        ),
        itemBuilder: (context, i) {
          if (i >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return Card(child: _buildRow(_suggestions[i]));
        },
      );
    }
  }

  Widget _buildRow(WordPair pair) {
    return Dismissible(
        key: Key(pair.toString()),
        onDismissed: (direction) {
          setState(() {
            _suggestions.remove(pair);
          });
        },
        child: ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        ));
  }
}
