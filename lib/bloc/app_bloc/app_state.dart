part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  @override
  List<Object> get props => [];
}

class GetBooksLoading extends AppState {
  @override
  List<Object> get props => [];
}

class GetBooksSuccess extends AppState {
  @override
  List<Object> get props => [];
}

class GetBooksError extends AppState {
  final String errorMessage;
  const GetBooksError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
