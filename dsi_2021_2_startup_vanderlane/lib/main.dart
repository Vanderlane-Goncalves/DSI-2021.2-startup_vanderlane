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
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool _listPair = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Vanderlane Generator'),
          actions: [
            IconButton(
              onPressed: _pushSaved,
              icon: const Icon(Icons.favorite),
            ),
          ],
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
          childAspectRatio: 3,
          crossAxisCount: 2,
          crossAxisSpacing: 6,
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
    final saveFavorite = _saved.contains(pair);

    return Dismissible(
        key: Key(pair.toString()),
        onDismissed: (direction) {
          setState(() {
            _suggestions.remove(pair);
            _saved.remove(pair);
          });
        },
        child: ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: IconButton(
            icon: Icon(saveFavorite ? Icons.favorite : Icons.favorite_border),
            color: saveFavorite ? Colors.red : null,
            onPressed: () {
              setState(() {
                if (saveFavorite) {
                  _saved.remove(pair);
                } else {
                  _saved.add(pair);
                }
              });
            },
          ),
        ));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) {
        final tites = _saved.map((pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });
        final divided = tites.isNotEmpty ? 
          ListTile.divideTiles(
                context: context,
                tiles: tites,
                ).toList(): <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorite'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }}