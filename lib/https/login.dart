import 'package:http/http.dart' as http;

class Logins {
  var client = http.Client();
  Future<String> userLogin(Map userMap) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: userMap);
    print("response.body " + response.body);
    return response.body;
  }
}
