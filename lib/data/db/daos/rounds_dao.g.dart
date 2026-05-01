// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rounds_dao.dart';

// ignore_for_file: type=lint
mixin _$RoundsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RoundsTable get rounds => attachedDatabase.rounds;
  RoundsDaoManager get managers => RoundsDaoManager(this);
}

class RoundsDaoManager {
  final _$RoundsDaoMixin _db;
  RoundsDaoManager(this._db);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db.attachedDatabase, _db.rounds);
}
