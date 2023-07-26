import 'dart:convert';

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    id: 0,
    lrn: '',
    sid: '',
    userid: 0,
    firstname: 'firstname',
    middlename: 'middlename',
    lastname: 'lastname',
    suffix: 'suffix',
    gender: 'gender',
    contactno: 'contactno', street: '', picurl: '', barangay: '', city: '',
    province: '', mothername: '', mcontactno: '', moccupation: '',
    fathername: '',
    fcontactno: '', foccupation: '', guardianname: '', gcontactno: '',
    ismothernum: 0, isfathernum: 0, isguardiannum: 0, levelid: 0, sectionid: 0,
    // mothername: 'mothername',
    // mcontactno: 'mcontactno',
    // fathername: 'fathername',
    // picurl: 'picurl',
    // barangay: 'barangay',
    // city: 'city',
    // province: 'province',
    // religionname: 'religionname',
    // ismothernum: 0,
    // foccupation: '',
    // lrn: '',
    // gcontactno: '',
    // guardianname: '',
    // street: '',
    // isguardiannum: 0,
    // studstatus: 0,
    // sectionname: '',
    // isfathernum: 0,
    // fcontactno: '',
    // moccupation: '',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static Future<User> getUser() async {
    _preferences = await SharedPreferences.getInstance();
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
