class Status {
  int? id;
  String? title;
  Status({this.id, this.title});

  Status.fromJMap(Map<String, dynamic> json) {
    title = json['title'] as String?;
    id = json['id'] as int?;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }
}

List<Status> statusList = [
  Status(id: 0, title: 'Reading'),
  Status(id: 1, title: 'To read'),
  Status(id: 2, title: 'Read'),
];
