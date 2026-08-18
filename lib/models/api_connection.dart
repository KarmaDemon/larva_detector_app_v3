
class ApiConnection {
  // final String? base_url = dotenv.env['BASE_API'];
  // final String? base_url = dotenv.env['BASE_API_dev'];
  // final String? base_url = 'http://10.0.2.2:5000';
  // final String? base_url = 'http://10.0.2.2:80';
  // Wi-Fi network
  // adb reverse tcp:5000 tcp:5000
  final String? base_url = 'http://localhost:80';

  getHelloWorld() {
    print('$base_url/hello');
    return '$base_url/hello';
  }

  getAnalysisDetail() {
    print('$base_url/objectdetection');
    return '$base_url/objectdetection';
  }

  getAnalysisPicture() {
    print('$base_url/objectdetection_img');
    return '$base_url/objectdetection_img';
  }

  getAnalysisPictureBase64() {
    print('$base_url/objectdetection_img_base64');
    return '$base_url/objectdetection_img_base64';
  }
}
