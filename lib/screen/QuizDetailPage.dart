// quiz_detail_page.dart
import 'package:flutter/material.dart';
import 'package:quiz_application/screen/question_controller.dart';

class QuizDetailPage extends StatefulWidget {
  final int quizIndex;
  final dynamic quizData;

  const QuizDetailPage({Key? key, required this.quizIndex, required this.quizData}) : super(key: key);

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  final QuizController _quizController = QuizController();

  @override
  void initState() {
    super.initState();
    _quizController.initialize(widget.quizData['Questions'].length);
  }

  @override
  Widget build(BuildContext context) {
    final quizTitle = widget.quizData['title'] ?? 'No title available';
    final questions = widget.quizData['Questions'] ?? [];
    final question = questions[_quizController.currentQuestionIndex];
    final questionText = question['question_text'] ?? 'No question text';
    final options = question['Options'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Details")),
      body: Column(
        children: [
          // Hero animation for the quiz title
          Hero(
            tag: widget.quizIndex,
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  quizTitle,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the current question
                  Text(
                    'Question ${_quizController.currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    questionText,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),

                  // Display the options for the current question
                  ...options.asMap().entries.map((entry) {
                    final optionIndex = entry.key;
                    final option = entry.value;
                    return ListTile(
                      title: Text(option['option_text'] ?? 'No option text'),
                      leading: Radio<int>(
                        value: optionIndex,
                        groupValue: _quizController.selectedOptions[_quizController.currentQuestionIndex],
                        onChanged: (int? value) {
                          setState(() {
                            _quizController.selectOption(_quizController.currentQuestionIndex, value!);
                          });
                        },
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 16.0),

                  // Show "Next" or "Submit" button
                  ElevatedButton(
                    onPressed: !_quizController.hasSelectedOption(_quizController.currentQuestionIndex)
                        ? null
                        : () {
                            _checkAnswer(options);
                          },
                    child: Text(
                      _quizController.currentQuestionIndex == questions.length - 1 ? 'Submit' : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Check the selected answer
  void _checkAnswer(List<dynamic> options) {
    setState(() {
      final isCorrect = _quizController.checkAnswer(options);

      // Move to the next question or show the score
      if (_quizController.moveToNextQuestion(widget.quizData['Questions'].length)) {
        _quizController.hasAnswered = false; // Reset for the next question
      } else {
        _showScoreDialog(); // Show final score when all questions are answered
      }
    });
  }

  // Show dialog with the final score
  void _showScoreDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap the button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text('You scored ${_quizController.score} out of ${widget.quizData['Questions'].length}'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to the previous page
              },
            ),
          ],
        );
      },
    );
  }
}
