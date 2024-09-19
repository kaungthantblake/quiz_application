import 'package:flutter/material.dart';
import 'package:quiz_application/Api/api_servic.dart';
import 'package:quiz_application/screen/QuizDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _quizData;

  @override
  void initState() {
    super.initState();
    _quizData = ApiService().getQuizzes(); // Fetch quiz data when widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Home Page")),
      body: FutureBuilder<List<dynamic>>(
        future: _quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quiz data available'));
          } else {
            final quizzes = snapshot.data!;

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, quizIndex) {
                final quiz = quizzes[quizIndex];
                final quizTitle = quiz['title'] ?? 'No title available';
                final quizDescription = quiz['description'] ?? 'No description available';

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizDetailPage(quizIndex: quizIndex, quizData: quiz),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: quizIndex,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.blueGrey, // Placeholder color or use a thumbnail
                              child: Center(
                                child: Text(
                                  'Quiz ${quizIndex + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quizTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                quizDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


