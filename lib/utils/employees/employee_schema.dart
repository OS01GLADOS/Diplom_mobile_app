class Employee {
  int id;
  String nameEng;
  String surnameEng;
  String preferredName;
  String email;
  String department;

  @override
  String toString(){
    return preferredName;
  }

  Employee({
    required this.id,
    required this.nameEng,
    required this.surnameEng,
    required this.preferredName,
    required this.email,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      nameEng: json['name_eng'] as String,
      surnameEng: json['surname_eng'] as String,
      preferredName: json['preferred_name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name_eng'] = this.nameEng;
    data['surname_eng'] = this.surnameEng;
    data['preferred_name'] = this.preferredName;
    data['email'] = this.email;
    data['department'] = this.department;
    return data;
  }
}