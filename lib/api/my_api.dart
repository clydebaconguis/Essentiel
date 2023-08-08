import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _mainDomain = "https://dev-essentiel.ckgroup.ph/";
  final String _esDomain =
      "https://dev-essentiel.ckgroup.ph/api/mobile/api_login";
  final String _enrollmentInfo = "api/mobile/api_enrollmentinfo";
  final String _billingInfo = "/api/mobile/api_billinginfo";
  final String _getSchedule = "api/mobile/api_getschedule";
  final String _studLedger = "/api/mobile/api_studledger";
  final String _studGrade = "api/mobile/api_getgrade";
  final String _events = "/api/mobile/api_get_events";
  final String _attendance = "api/mobile/student_attendance";
  final String _schoolinfo = "api/mobile/schoolinfo";

  getSchoolInfo() async {
    var fullUrl = '$_mainDomain$_schoolinfo';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getAttendance(
    studid,
    syid,
    levelid,
  ) async {
    var fullUrl =
        '$_mainDomain$_attendance?studid=$studid&syid=$syid&levelid=$levelid&semid=1';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getEvents(syid) async {
    var fullUrl = '$_mainDomain$_events?syid=$syid';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getStudGrade(studid, gradelevel, syid, sectionid, strand, semid) async {
    var fullUrl =
        '$_mainDomain$_studGrade?studid=$studid&gradelevel=$gradelevel&syid=$syid&sectionid=$sectionid&strand=$strand&semid=$semid';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getStudLedger(studid, syid, semid) async {
    var fullUrl =
        '$_mainDomain$_studLedger?studid=$studid&syid=$syid&semid=$semid';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getEnrollmentInfo(studid) async {
    var fullUrl = '$_mainDomain$_enrollmentInfo?studid=$studid';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getBillingInfo(String studid) async {
    var fullUrl =
        '$_mainDomain$_billingInfo?studid=$studid&syid=1&semid=1&monthid=10';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getSchedule(
    studid,
    syid,
    semid,
    sectionid,
    levelid,
  ) async {
    var fullUrl =
        '$_mainDomain$_getSchedule?studid=$studid&syid=$syid&semid=$semid&sectionid=$sectionid&levelid=$levelid';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getImage() {
    return _mainDomain;
  }

  postData(data, apiUrl) async {
    // var fullUrl = _ckIpv4 + apiUrl;
    // return await http.post(Uri.parse(fullUrl),
    //     body: jsonEncode(data), headers: _setHeaders());
  }
  login(username, pword) async {
    // var token = await getToken();
    var fullUrl = '$_esDomain?username=$username&pword=$pword';
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  // login(data) async {
  //   return await http.post(Uri.parse(_esDomain),
  //       body: jsonEncode(data), headers: _setHeaders());
  // }

  // getData(apiUrl) async {
  //   var fullUrl = _esDomain + await getToken();
  //   return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  // }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return 'token=$token';
  }

  // getArticles(apiUrl) async {}

  getPublicData(apiUrl) async {
    var fullUrl = _esDomain + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }
}
