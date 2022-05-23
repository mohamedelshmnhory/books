
import 'package:equatable/equatable.dart';

class Book extends Equatable{
  int? id;
  String? name;
  String? author;
  int? status;
  String? date;
  String? classification;
  int numberOfReads = 0;
  double? rate;

  Book({
    this.id,
    this.rate,
    this.numberOfReads = 0,
    this.classification,
    this.date,
    this.name,
    this.author,
    this.status,
  });

  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int?;
    name = map['name'] as String?;
    author = map['author'] as String?;
    date = map['date'] as String?;
    rate = map['rate'] as double?;
    classification = map['category'] as String?;
    status = map['status'] as int?;
    numberOfReads = map['numberOfReads'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'author': author,
      'date': date,
      'category': classification,
      'rate': rate,
      'status': status,
      'numberOfReads': numberOfReads,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  @override
  List<Object?> get props => [id];
}
