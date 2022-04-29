part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class GetBooksFromDB extends AppEvent {
  @override
  List<Object?> get props => [];
}

class FilterByClassification extends AppEvent {
  final String classification;
  const FilterByClassification(this.classification);

  @override
  List<Object?> get props => [classification];
}

class FilterByAuthor extends AppEvent {
  final String author;
  const FilterByAuthor(this.author);

  @override
  List<Object?> get props => [author];
}
