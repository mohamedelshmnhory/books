import 'package:bloc_test/bloc_test.dart';
import 'package:books/bloc/app_bloc/app_bloc.dart';
import 'package:books/local_storage.dart';
import 'package:books/models/book_model.dart';
import 'package:books/utils/backup/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_bloc_test.mocks.dart';

@GenerateMocks([DBHelper, Storage])
void main() {
  late AppBloc appBloc;
  late MockDBHelper mockDBHelper;
  late MockStorage mockStorage;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockDBHelper = MockDBHelper();
    mockStorage = MockStorage();
    appBloc = AppBloc(mockStorage, mockDBHelper);
  });

  test('initialState should be AppInitial', () {
    expect(appBloc.state, equals(AppInitial()));
  });

  group(
    'description',
    () {
      blocTest<AppBloc, AppState>(
        'Loading',
        build: () => appBloc,
        setUp: () async {
          when(mockDBHelper.getData(booksT))
              .thenAnswer((realInvocation) async => []);
        },
        act: (bloc) async {
          bloc.add(GetBooksFromDB());
        },
        verify: (bloc) {
          mockDBHelper(booksT);
        },
        expect: () => [
          GetBooksLoading(),
          GetBooksSuccess(),
        ],
      );

      blocTest<AppBloc, AppState>(
        'add book',
        build: () => appBloc,
        setUp: () async {
          when(mockDBHelper.insert(booksT, book))
              .thenAnswer((realInvocation) async => 0);
          when(mockDBHelper.getData(booksT))
              .thenAnswer((realInvocation) async => listOfBooks);
        },
        act: (bloc) async {
          bloc.add(GetBooksFromDB());
        },
        verify: (bloc) async {
          mockDBHelper(booksT);
          List result = await mockDBHelper.getData(booksT);
          expect(result, listOfBooks);
        },
        expect: () => [GetBooksLoading(), GetBooksSuccess()],
      );
    },
  );
}

List<Map<String, dynamic>> get listOfBooks => [book.toMap()];

Book get book => Book(id: 0, name: '1', date: '1', author: '1');
