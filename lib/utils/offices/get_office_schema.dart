class Office {
  int id;
  int location;
  String address;
  String addressEng;
  String postcode;
  int owner;
  int jiraOfficeId;

  Office({
    required this.id,
    required this.location,
    required this.address,
    required this.addressEng,
    required this.postcode,
    required this.owner,
    required this.jiraOfficeId,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'] as int,
      location: json['location'] as int,
      address: json['address'] as String,
      addressEng: json['address_eng'] as String,
      postcode: json['postcode'] as String,
      owner: json['owner'] as int,
      jiraOfficeId: json['jira_office_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['address'] = this.address;
    data['address_eng'] = this.addressEng;
    data['postcode'] = this.postcode;
    data['owner'] = this.owner;
    data['jira_office_id'] = this.jiraOfficeId;
    return data;
  }
}