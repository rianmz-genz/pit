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
    required int this.id,
    String? this.Name,
    String? this.Phone,
    String? this.Email,
    String? this.Picture,
    String? this.Area,
    String? this.Kemampuan,
    String? this.Status,
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
    this.id = map['id'];
    this.Name = map['name'];
    this.Phone = map['phone'];
    this.Email = map['email'];
    this.Picture = map['picture'];
    this.Area = map['area'];
    this.Kemampuan = map['kemampuan'];
    this.Status = map['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.Name;
    data['phone'] = this.Phone;
    data['email'] = this.Email;
    data['picture'] = this.Picture;
    data['area'] = this.Area;
    data['kemampuan'] = this.Kemampuan;
    data['status'] = this.Status;

    return data;
  }

  Map<String, Object> toMap() {
    final Map<String, Object> data = new Map<String, Object>();
    data['id'] = this.id;
    data['name'] = this.Name ?? "";
    data['phone'] = this.Phone ?? "";
    data['email'] = this.Email ?? "";
    data['picture'] = this.Picture ?? "";
    data['area'] = this.Area ?? "";
    data['kemampuan'] = this.Kemampuan ?? "";
    data['status'] = this.Status ?? "";

    return data;
  }
}
