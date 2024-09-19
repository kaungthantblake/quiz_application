// quiz_controller.dart

class QuizController {
  int currentQuestionIndex = 0;
  int score = 0;
  bool hasAnswered = false;
  List<int?> selectedOptions = [];

  void initialize(int questionCount) {
    selectedOptions = List<int?>.filled(questionCount, null);
  }

  void selectOption(int questionIndex, int optionIndex) {
    if (!hasAnswered) {
      selectedOptions[questionIndex] = optionIndex;
    }
  }

  bool checkAnswer(List<dynamic> options) {
    hasAnswered = true;
    final isCorrect = options[selectedOptions[currentQuestionIndex]!]['is_correct'] == true;
    if (isCorrect) {
      score++;
    }
    return isCorrect;
  }

  bool moveToNextQuestion(int totalQuestions) {
    if (currentQuestionIndex < totalQuestions - 1) {
      currentQuestionIndex++;
      hasAnswered = false; // Reset for the next question
      return true;
    }
    return false;
  }

  bool hasSelectedOption(int questionIndex) {
    return selectedOptions[questionIndex] != null;
  }
}
