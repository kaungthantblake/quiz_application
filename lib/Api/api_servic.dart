import 'dart:convert';
import 'package:http/http.dart' as http;


   const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator


class ApiService {        

  Future<List<dynamic>> getQuizQuestions() async {
  final response = await http.get(Uri.parse('$baseUrl/quizzes/questions'));

  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load quiz data');
  }
}

  Future<List<dynamic>>getQuizzes() async {
    final response = await http.get(Uri.parse('$baseUrl/quizzes/getQuizzes'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quiz data');
    }
  }

}

