import 'package:flutter/material.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class WordPair {
  final String english;
  final String russian;

  WordPair(this.english, this.russian);
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<WordPair> _vocabulary = [];
  final _formKey = GlobalKey<FormState>();
  final _engController = TextEditingController();
  final _rusController = TextEditingController();

  void _addOrEditWord({int? index}) {
    bool isEdit = index != null;
    if (isEdit) {
      _engController.text = _vocabulary[index].english;
      _rusController.text = _vocabulary[index].russian;
    } else {
      _engController.clear();
      _rusController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Word' : 'New Word'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _engController,
                decoration: const InputDecoration(labelText: 'English'),
                validator: (val) => val!.trim().isEmpty ? 'Enter a word' : null,
              ),
              TextFormField(
                controller: _rusController,
                decoration: const InputDecoration(labelText: 'Russian'),
                validator: (val) =>
                    val!.trim().isEmpty ? 'Enter a translation' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final eng = _engController.text.trim();
                final rus = _rusController.text.trim();

                final duplicate = _vocabulary.any((word) =>
                    word.russian == rus &&
                    (!isEdit || _vocabulary[index].russian != rus));
                if (duplicate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This translation already exists'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else {
                  setState(() {
                    if (isEdit) {
                      _vocabulary[index] = WordPair(eng, rus);
                    } else {
                      _vocabulary.add(WordPair(eng, rus));
                    }
                  });
                  Navigator.pop(context);
                }
              }
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _sortByEnglish() {
    setState(() {
      _vocabulary.sort(
          (a, b) => a.english.toLowerCase().compareTo(b.english.toLowerCase()));
    });
  }

  void _sortByRussian() {
    setState(() {
      _vocabulary.sort(
          (a, b) => a.russian.toLowerCase().compareTo(b.russian.toLowerCase()));
    });
  }

  @override
  void dispose() {
    _engController.dispose();
    _rusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              icon: const Icon(Icons.sort_by_alpha),
              onPressed: _sortByEnglish,
              tooltip: 'Sort by English'),
          IconButton(
              icon: const Icon(Icons.translate),
              onPressed: _sortByRussian,
              tooltip: 'Sort by Russian'),
        ],
      ),
      body: _vocabulary.isEmpty
          ? const Center(child: Text('No words added yet'))
          : ListView.builder(
              itemCount: _vocabulary.length,
              itemBuilder: (_, i) {
                final word = _vocabulary[i];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(word.english,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Translation: ${word.russian}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _addOrEditWord(index: i);
                        } else if (value == 'delete') {
                          setState(() => _vocabulary.removeAt(i));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditWord(),
        backgroundColor: Colors.indigo,
        tooltip: 'Add Words',
        child: const Icon(Icons.add),
      ),
    );
  }
}
