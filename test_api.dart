import 'package:dio/dio.dart';

void main() async {
  await testNewAPI();
}

Future<void> testNewAPI() async {
  const String apiURL = "https://places.googleapis.com/v1/places:autocomplete";
  const String apiKey = "your-google-api-key";

  Map<String, dynamic> requestBody = {"input": "restaurant"};

  // Add language code
  requestBody["languageCode"] = "en";

  // Add region code (optional)
  requestBody["regionCode"] = "US";

  try {
    Dio dio = Dio();

    Options options = Options(
      headers: {'Content-Type': 'application/json', 'X-Goog-Api-Key': apiKey},
    );

    print("Making request to: $apiURL");
    print("Request body: $requestBody");
    print("Headers: ${options.headers}");

    Response response = await dio.post(
      apiURL,
      data: requestBody,
      options: options,
    );

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
  } catch (e) {
    print("Error: $e");
    if (e is DioException) {
      print("DioError type: ${e.type}");
      print("DioError message: ${e.message}");
      print("DioError response: ${e.response?.data}");
    }
  }
}
