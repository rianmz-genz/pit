class UserQuery {
  static const String TABLE_NAME = "User";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, "
      " name TEXT, email TEXT, phone TEXT, picture TEXT, area TEXT, kemampuan TEXT,status TEXT) ";
  static const String SELECT = "select * from $TABLE_NAME";
}

class User {
  int id = 0;
  String? Name = "";
  String? Phone = "";
  String? Email = "";
  String? Picture = "";
  String? Area = "";
  String? Kemampuan = "";
  String? Status = "";
  // int? userActive = 0;

  User({
    required this.id,
    this.Name,
    this.Phone,
    this.Email,
    this.Picture,
    this.Area,
    this.Kemampuan,
    this.Status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      Name: json['name'] ?? "",
      Phone: json['phone'] ?? "",
      Email: json['email'] ?? "",
      Picture: json['picture'] ?? "",
      Area: json['area'] ?? "",
      Kemampuan: json['kemampuan'] ?? "",
      Status: json['status'] ?? "",
    );
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    Name = map['name'];
    Phone = map['phone'];
    Email = map['email'];
    Picture = map['picture'];
    Area = map['area'];
    Kemampuan = map['kemampuan'];
    Status = map['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = Name;
    data['phone'] = Phone;
    data['email'] = Email;
    data['picture'] = Picture;
    data['area'] = Area;
    data['kemampuan'] = Kemampuan;
    data['status'] = Status;

    return data;
  }

  Map<String, Object> toMap() {
    final Map<String, Object> data = <String, Object>{};
    data['id'] = id;
    data['name'] = Name ?? "";
    data['phone'] = Phone ?? "";
    data['email'] = Email ?? "";
    data['picture'] = Picture ?? "";
    data['area'] = Area ?? "";
    data['kemampuan'] = Kemampuan ?? "";
    data['status'] = Status ?? "";

    return data;
  }
}
