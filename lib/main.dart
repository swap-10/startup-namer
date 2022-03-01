import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RootWidget(),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  final Set<WordPair> _saved = {};

  @override
  Widget build(BuildContext context) {
    return RandomWords(
      saved: _saved,
    );
  }
}

class RandomWords extends StatefulWidget {
  final Set<WordPair> saved;
  const RandomWords({Key? key, required this.saved}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    _suggestions.addAll(widget.saved);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }

        final index = i ~/ 2; // Divides i by 2 and returns int (ceil)
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = widget.saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? "Remove from Saved" : "Save",
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            widget.saved.remove(pair);
          } else {
            widget.saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FavoriteWords(saved: widget.saved);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Startup Name Generator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: _pushSaved,
            tooltip: "Saved suggestions",
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

//
//
//
//
//
class FavoriteWords extends StatefulWidget {
  final Set<WordPair> saved;
  const FavoriteWords({Key? key, required this.saved}) : super(key: key);

  @override
  _FavoriteWordsState createState() => _FavoriteWordsState();
}

class _FavoriteWordsState extends State<FavoriteWords> {
  final _biggerFont = const TextStyle(fontSize: 18);
  Widget _listTile(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.cancel_rounded, color: Colors.black),
        onPressed: () {
          setState(() {
            widget.saved.remove(pair);
          });
        },
      ),
    );
  }

  Widget _buildFavoriteList() {
    final _favoriteList = widget.saved.toList();
    // final _favoriteList = widget.saved.toList();
    return ListView.builder(
      itemCount: _favoriteList.length * 2,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }

        final index = i ~/ 2; // Divides i by 2 and returns int (ceil)

        return _listTile(_favoriteList[index]);
      },
    );
  }

  void _pushMainScreen() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return RandomWords(saved: widget.saved);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Suggestions"),
        leading: (IconButton(
          icon: const Icon(Icons.list, color: Colors.white),
          onPressed: _pushMainScreen,
          tooltip: "Suggestions List",
        )),
      ),
      body: _buildFavoriteList(),
    );
  }
}
