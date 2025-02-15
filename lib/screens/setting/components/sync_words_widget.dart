import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:word_generator/word_generator.dart';

class SyncWordsWidget extends StatefulWidget {
  const SyncWordsWidget({super.key});

  @override
  State<SyncWordsWidget> createState() => _SyncWordsWidgetState();
}

class _SyncWordsWidgetState extends State<SyncWordsWidget> {
  final storage = FlutterSecureStorage();
  static List<Color> colors = [
    Colors.red,
    Colors.deepOrange,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  bool _isBlurred = true;

  Future<String> getSyncWords() async {
    debugPrint('getSyncWords');

    try {
      String? value = await storage.read(key: 'syncWords');
      debugPrint('value: $value');
      if (value != null) {
        return value;
      } else {
        final wordGenerator = WordGenerator();
        final words = wordGenerator.randomSentence(16);
        await storage.write(key: 'syncWords', value: words);
        return words;
      }
    } catch (e) {
      debugPrint('error: $e');
      return '123 456 789 123 456 789 123 456 789 123 456 789 123 456 789 123 456 789';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ImageFiltered(
                imageFilter: _isBlurred
                    ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _isBlurred = !_isBlurred;
                    });
                  },
                  child: FutureBuilder(
                      future: getSyncWords(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final wordsList = snapshot.data.toString().split(' ');
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            wordsList.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                wordsList[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors[index % colors.length],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                  _isBlurred ? Icons.remove_red_eye : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isBlurred = !_isBlurred;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
