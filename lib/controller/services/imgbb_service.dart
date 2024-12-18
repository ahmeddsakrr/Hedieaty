import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImgbbService {
  final String apiKey = dotenv.env['IMGBB_API_KEY'] ?? '';

  Future<String?> uploadImage(String imagePath) async {
    if (apiKey.isEmpty) {
      throw Exception("API key is missing");
    }

    final uri = Uri.parse("https://api.imgbb.com/1/upload");
    final request = http.MultipartRequest("POST", uri)
      ..fields['key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse['data']['url'];
    } else {
      throw Exception("Failed to upload image");
    }
  }
}
