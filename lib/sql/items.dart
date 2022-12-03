class Account {
  int? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? createAt;

  Account(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.password,
      this.createAt});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
    };
  }
}

class Category {
  int? idCate;
  String? category;
  String? email;
  String? createdAt;

  Category({this.idCate, this.category, this.email, this.createdAt});

  Category.fromMap(dynamic obj) {
    idCate = obj['idCate'];
    category = obj['category'];
    email = obj['email'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'idCate': idCate,
      'category': category,
      'email': email,
    };
    return map;
  }
}

class Status {
  int? idStatus;
  String? status;
  String? email;
  String? createdAt;

  Status({this.idStatus, this.status, this.email, this.createdAt});

  Status.fromMap(dynamic obj) {
    idStatus = obj['idStatus'];
    status = obj['status'];
    email = obj['email'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'idStatus': idStatus,
      'status': status,
      'email': email,
    };
    return map;
  }
}

class Priority {
  int? idPriority;
  String? priority;
  String? email;
  String? createdAt;

  Priority({this.idPriority, this.priority, this.email, this.createdAt});

  Priority.fromMap(dynamic obj) {
    idPriority = obj['idPriority'];
    priority = obj['priority'];
    email = obj['email'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
    'idPriority': idPriority,
    'priority': priority,
      'email': email,
    };
    return map;
  }
}

class Note {
  int? idNote;
  String? noteName;
  String? category;
  String? priority;
  String? status;
  String? date;
  String? email;
  String? createdAt;

  Note(
      {this.idNote,
      this.noteName,
      this.category,
      this.priority,
      this.status,
      this.date,
      this.email,
      this.createdAt});

  Note.fromMap(dynamic obj) {
    idNote = obj['idNote'];
    noteName = obj['noteName'];
    date = obj['date'];
    createdAt = obj['createdAt'];
    category = obj['category'];
    priority = obj['priority'];
    status = obj['status'];
    email = obj['email'];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'idNote': idNote,
      'noteName': noteName,
      'category': category,
      'priority': priority,
      'status': status,
      'date': date,
      'email' : email,
    };

    return map;

  }
}
