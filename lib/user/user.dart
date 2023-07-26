class User {
  int id;
  int levelid;
  int sectionid;
  int userid;
  String sid;
  String lrn;
  String firstname;
  String lastname;
  String middlename;
  String suffix;
  String gender;
  String contactno;
  String picurl;
  String street;
  String barangay;
  String city;
  String province;

  String mothername;
  String mcontactno;
  String moccupation;
  String fathername;
  String fcontactno;
  String foccupation;
  String guardianname;
  String gcontactno;

  // String religionname;
  int ismothernum;
  int isfathernum;
  int isguardiannum;
  // int studstatus;
  // String sectionname;

  // Constructor
  User({
    required this.levelid,
    required this.sectionid,
    // required this.foccupation,
    // required this.gcontactno,
    // required this.guardianname,
    // required this.street,
    // required this.studstatus,
    // required this.sectionname,
    required this.ismothernum,
    required this.isfathernum,
    required this.isguardiannum,
    // required this.fcontactno,
    // required this.moccupation,
    required this.lrn,
    required this.id,
    required this.sid,
    required this.userid,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.suffix,
    required this.gender,
    required this.contactno,
    required this.mothername,
    required this.mcontactno,
    required this.moccupation,
    required this.fathername,
    required this.fcontactno,
    required this.foccupation,
    required this.guardianname,
    required this.gcontactno,
    required this.street,
    required this.picurl,
    required this.barangay,
    required this.city,
    required this.province,
    // required this.religionname,
  });

  factory User.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var levelid = json['levelid'] ?? 0;
    var sectionid = json['sectionid'] ?? 0;
    var userid = json['userid'] ?? 0;
    var sid = json['sid'] ?? '';
    var lrn = json['lrn'] ?? '';
    var firstname = json['firstname'] ?? '';
    var middlename = json['middlename'] ?? '';
    var lastname = json['lastname'] ?? '';
    var suffix = json['suffix'] ?? '';
    var gender = json['gender'] ?? 'Not specified';
    var contactno = json['contactno'] ?? 'Not specified';

    var mothername = json['mothername'] ?? 'Not specified';
    var mcontactno = json['mcontactno'] ?? 'Not specified';
    var moccupation = json['moccupation'] ?? 'Not specified';
    var fathername = json['fathername'] ?? 'Not specified';
    var foccupation = json['foccupation'] ?? 'Not specified';
    var fcontactno = json['fcontactno'] ?? 'Not specified';
    var fcontactinfo = json['fcontactinfo'] ?? 'Not specified';
    var gcontactinfo = json['gcontactinfo'] ?? 'Not specified';
    var gcontactno = json['gcontactno'] ?? 'Not specified';
    var goccupation = json['goccupation'] ?? 'Not specified';
    var guardianname = json['guardianname'] ?? 'Not specified';

    var picurl = json['picurl'] ?? '';
    var street = json['street'] ?? 'Not specified';
    var barangay = json['barangay'] ?? 'Not specified';
    var city = json['city'] ?? 'Not specified';
    var province = json['province'] ?? 'Not specified';
    var isguardiannum = json['isguardiannum'] ?? 0;
    var isfathernum = json['isfathernum'] ?? 0;
    var ismothernum = json['ismothernum'] ?? 0;
    // var religionname = json['religionname'] ?? '';
    // var studstatus = json['studstatus'] ?? '';
    // var sectionname = json['sectionname'] ?? '';

    return User(
      id: id,
      levelid: levelid,
      sectionid: sectionid,
      sid: sid,
      userid: userid,
      firstname: firstname,
      middlename: middlename,
      lastname: lastname,
      suffix: suffix,
      gender: gender,
      contactno: contactno, lrn: '',
      // mothername: mothername,
      // mcontactno: mcontactno,
      // fathername: fathername,
      picurl: picurl,
      street: street,

      barangay: barangay,
      city: city,
      province: province, mothername: mothername, mcontactno: mcontactno,
      moccupation: moccupation, fathername: fathername,
      fcontactno: fcontactno, foccupation: foccupation,
      guardianname: guardianname,
      gcontactno: gcontactno,
      ismothernum: ismothernum,
      isfathernum: isfathernum,
      isguardiannum: isguardiannum,
      // religionname: religionname,
      // foccupation: foccupation,
      // lrn: lrn,
      // gcontactno: gcontactinfo,
      // guardianname: goccupation,
      // isguardiannum: isguardiannum,
      // studstatus: studstatus,
      // sectionname: sectionname,
      // isfathernum: isfathername,
      // fcontactno: fcontactinfo,
      // moccupation: moccupation,
      // ismothernum: ismothernum,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sid': sid,
        'lrn': lrn,
        'userid': userid,
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'suffix': suffix,
        'gender': gender,
        ' contactno': contactno,
        // 'mothername': mothername,
        // 'mcontactno': mcontactno,
        // 'fathername': fathername,
        'picurl': picurl,
        'barangay': barangay,
        'city': city,
        'province': province,
        // 'religionname': religionname,
        // 'foccupation': foccupation,
        // 'gcontactno': gcontactno,
      };
}
