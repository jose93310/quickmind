import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:quickmind/data/db/daos/rounds_dao.dart';
import 'package:quickmind/data/db/daos/stats_dao.dart';
import 'package:quickmind/data/db/daos/user_dao.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get nickname => text()();
  TextColumn get name => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get birthDate => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get avatarPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  IntColumn get gamesPlayed => integer().withDefault(const Constant(0))();
  IntColumn get roundsPlayed => integer().withDefault(const Constant(0))();
  IntColumn get validAnswers => integer().withDefault(const Constant(0))();
  IntColumn get invalidAnswers => integer().withDefault(const Constant(0))();
  IntColumn get bestScore => integer().withDefault(const Constant(0))();
}

class Rounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get category => text()();
  IntColumn get score => integer()();
  IntColumn get timeSpent => integer()(); // segundos
  TextColumn get date => text()();        // ISO8601
}

@DriftDatabase(
  tables: [Users, UserStats, Rounds],
  daos: [UserDao, StatsDao, RoundsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'quickmind.db'));
    return NativeDatabase.createInBackground(file);
  });
}

