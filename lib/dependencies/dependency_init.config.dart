// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/app_bloc/app_bloc.dart' as _i5;
import '../local_storage.dart' as _i3;
import '../utils/backup/storage.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.DBHelper>(_i3.DBHelper());
  gh.factory<_i4.Storage>(() => _i4.Storage());
  gh.factory<_i5.AppBloc>(
      () => _i5.AppBloc(get<_i4.Storage>(), get<_i3.DBHelper>()));
  return get;
}
