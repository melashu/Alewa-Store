import 'package:http/http.dart' as http;

class OrgProfHttp {
  var client = http.Client();
  Future<String> insertOrgProf(Map orgMap) async {
    orgMap['action'] = 'insertorg';
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: orgMap);
    return response.body;
  }



}
