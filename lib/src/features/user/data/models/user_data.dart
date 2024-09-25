class UserData {
  UserData({
      num? id, 
      String? code, 
      String? username, 
      dynamic googleId, 
      String? email, 
      String? phone, 
      String? verifyCode, 
      String? expiredCode, 
      dynamic mailCode, 
      dynamic expiredMailCode, 
      num? roleId, 
      dynamic note, 
      String? firstName, 
      String? lastName, 
      String? shortName, 
      String? fullName, 
      dynamic address, 
      dynamic birthday, 
      String? genre, 
      dynamic avatar, 
      dynamic idNumber, 
      num? isActive, 
      num? isSuper, 
      num? deleted, 
      String? createdAt, 
      dynamic createdBy, 
      String? updatedAt, 
      dynamic updatedBy, 
      dynamic deletedAt, 
      dynamic deletedBy,}){
    _id = id;
    _code = code;
    _username = username;
    _googleId = googleId;
    _email = email;
    _phone = phone;
    _verifyCode = verifyCode;
    _expiredCode = expiredCode;
    _mailCode = mailCode;
    _expiredMailCode = expiredMailCode;
    _roleId = roleId;
    _note = note;
    _firstName = firstName;
    _lastName = lastName;
    _shortName = shortName;
    _fullName = fullName;
    _address = address;
    _birthday = birthday;
    _genre = genre;
    _avatar = avatar;
    _idNumber = idNumber;
    _isActive = isActive;
    _isSuper = isSuper;
    _deleted = deleted;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
    _deletedAt = deletedAt;
    _deletedBy = deletedBy;
}

  UserData.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _username = json['username'];
    _googleId = json['google_id'];
    _email = json['email'];
    _phone = json['phone'];
    _verifyCode = json['verify_code'];
    _expiredCode = json['expired_code'];
    _mailCode = json['mail_code'];
    _expiredMailCode = json['expired_mail_code'];
    _roleId = json['role_id'];
    _note = json['note'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _shortName = json['short_name'];
    _fullName = json['full_name'];
    _address = json['address'];
    _birthday = json['birthday'];
    _genre = json['genre'];
    _avatar = json['avatar'];
    _idNumber = json['id_number'];
    _isActive = json['is_active'];
    _isSuper = json['is_super'];
    _deleted = json['deleted'];
    _createdAt = json['created_at'];
    _createdBy = json['created_by'];
    _updatedAt = json['updated_at'];
    _updatedBy = json['updated_by'];
    _deletedAt = json['deleted_at'];
    _deletedBy = json['deleted_by'];
  }
  num? _id;
  String? _code;
  String? _username;
  dynamic _googleId;
  String? _email;
  String? _phone;
  String? _verifyCode;
  String? _expiredCode;
  dynamic _mailCode;
  dynamic _expiredMailCode;
  num? _roleId;
  dynamic _note;
  String? _firstName;
  String? _lastName;
  String? _shortName;
  String? _fullName;
  dynamic _address;
  dynamic _birthday;
  String? _genre;
  dynamic _avatar;
  dynamic _idNumber;
  num? _isActive;
  num? _isSuper;
  num? _deleted;
  String? _createdAt;
  dynamic _createdBy;
  String? _updatedAt;
  dynamic _updatedBy;
  dynamic _deletedAt;
  dynamic _deletedBy;
UserData copyWith({  num? id,
  String? code,
  String? username,
  dynamic googleId,
  String? email,
  String? phone,
  String? verifyCode,
  String? expiredCode,
  dynamic mailCode,
  dynamic expiredMailCode,
  num? roleId,
  dynamic note,
  String? firstName,
  String? lastName,
  String? shortName,
  String? fullName,
  dynamic address,
  dynamic birthday,
  String? genre,
  dynamic avatar,
  dynamic idNumber,
  num? isActive,
  num? isSuper,
  num? deleted,
  String? createdAt,
  dynamic createdBy,
  String? updatedAt,
  dynamic updatedBy,
  dynamic deletedAt,
  dynamic deletedBy,
}) => UserData(  id: id ?? _id,
  code: code ?? _code,
  username: username ?? _username,
  googleId: googleId ?? _googleId,
  email: email ?? _email,
  phone: phone ?? _phone,
  verifyCode: verifyCode ?? _verifyCode,
  expiredCode: expiredCode ?? _expiredCode,
  mailCode: mailCode ?? _mailCode,
  expiredMailCode: expiredMailCode ?? _expiredMailCode,
  roleId: roleId ?? _roleId,
  note: note ?? _note,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  shortName: shortName ?? _shortName,
  fullName: fullName ?? _fullName,
  address: address ?? _address,
  birthday: birthday ?? _birthday,
  genre: genre ?? _genre,
  avatar: avatar ?? _avatar,
  idNumber: idNumber ?? _idNumber,
  isActive: isActive ?? _isActive,
  isSuper: isSuper ?? _isSuper,
  deleted: deleted ?? _deleted,
  createdAt: createdAt ?? _createdAt,
  createdBy: createdBy ?? _createdBy,
  updatedAt: updatedAt ?? _updatedAt,
  updatedBy: updatedBy ?? _updatedBy,
  deletedAt: deletedAt ?? _deletedAt,
  deletedBy: deletedBy ?? _deletedBy,
);
  num? get id => _id;
  String? get code => _code;
  String? get username => _username;
  dynamic get googleId => _googleId;
  String? get email => _email;
  String? get phone => _phone;
  String? get verifyCode => _verifyCode;
  String? get expiredCode => _expiredCode;
  dynamic get mailCode => _mailCode;
  dynamic get expiredMailCode => _expiredMailCode;
  num? get roleId => _roleId;
  dynamic get note => _note;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get shortName => _shortName;
  String? get fullName => _fullName;
  dynamic get address => _address;
  dynamic get birthday => _birthday;
  String? get genre => _genre;
  dynamic get avatar => _avatar;
  dynamic get idNumber => _idNumber;
  num? get isActive => _isActive;
  num? get isSuper => _isSuper;
  num? get deleted => _deleted;
  String? get createdAt => _createdAt;
  dynamic get createdBy => _createdBy;
  String? get updatedAt => _updatedAt;
  dynamic get updatedBy => _updatedBy;
  dynamic get deletedAt => _deletedAt;
  dynamic get deletedBy => _deletedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['username'] = _username;
    map['google_id'] = _googleId;
    map['email'] = _email;
    map['phone'] = _phone;
    map['verify_code'] = _verifyCode;
    map['expired_code'] = _expiredCode;
    map['mail_code'] = _mailCode;
    map['expired_mail_code'] = _expiredMailCode;
    map['role_id'] = _roleId;
    map['note'] = _note;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['short_name'] = _shortName;
    map['full_name'] = _fullName;
    map['address'] = _address;
    map['birthday'] = _birthday;
    map['genre'] = _genre;
    map['avatar'] = _avatar;
    map['id_number'] = _idNumber;
    map['is_active'] = _isActive;
    map['is_super'] = _isSuper;
    map['deleted'] = _deleted;
    map['created_at'] = _createdAt;
    map['created_by'] = _createdBy;
    map['updated_at'] = _updatedAt;
    map['updated_by'] = _updatedBy;
    map['deleted_at'] = _deletedAt;
    map['deleted_by'] = _deletedBy;
    return map;
  }

}