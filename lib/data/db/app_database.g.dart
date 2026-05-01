// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    nickname,
    name,
    country,
    city,
    birthDate,
    gender,
    avatarPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String nickname;
  final String? name;
  final String? country;
  final String? city;
  final String? birthDate;
  final String? gender;
  final String? avatarPath;
  const User({
    required this.id,
    required this.email,
    required this.nickname,
    this.name,
    this.country,
    this.city,
    this.birthDate,
    this.gender,
    this.avatarPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      nickname: Value(nickname),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      nickname: serializer.fromJson<String>(json['nickname']),
      name: serializer.fromJson<String?>(json['name']),
      country: serializer.fromJson<String?>(json['country']),
      city: serializer.fromJson<String?>(json['city']),
      birthDate: serializer.fromJson<String?>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'nickname': serializer.toJson<String>(nickname),
      'name': serializer.toJson<String?>(name),
      'country': serializer.toJson<String?>(country),
      'city': serializer.toJson<String?>(city),
      'birthDate': serializer.toJson<String?>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'avatarPath': serializer.toJson<String?>(avatarPath),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? nickname,
    Value<String?> name = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> birthDate = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    nickname: nickname ?? this.nickname,
    name: name.present ? name.value : this.name,
    country: country.present ? country.value : this.country,
    city: city.present ? city.value : this.city,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      name: data.name.present ? data.name.value : this.name,
      country: data.country.present ? data.country.value : this.country,
      city: data.city.present ? data.city.value : this.city,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nickname: $nickname, ')
          ..write('name: $name, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('avatarPath: $avatarPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    nickname,
    name,
    country,
    city,
    birthDate,
    gender,
    avatarPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.nickname == this.nickname &&
          other.name == this.name &&
          other.country == this.country &&
          other.city == this.city &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.avatarPath == this.avatarPath);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> nickname;
  final Value<String?> name;
  final Value<String?> country;
  final Value<String?> city;
  final Value<String?> birthDate;
  final Value<String?> gender;
  final Value<String?> avatarPath;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.nickname = const Value.absent(),
    this.name = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String nickname,
    this.name = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       nickname = Value(nickname);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? nickname,
    Expression<String>? name,
    Expression<String>? country,
    Expression<String>? city,
    Expression<String>? birthDate,
    Expression<String>? gender,
    Expression<String>? avatarPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (nickname != null) 'nickname': nickname,
      if (name != null) 'name': name,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? nickname,
    Value<String?>? name,
    Value<String?>? country,
    Value<String?>? city,
    Value<String?>? birthDate,
    Value<String?>? gender,
    Value<String?>? avatarPath,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      country: country ?? this.country,
      city: city ?? this.city,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nickname: $nickname, ')
          ..write('name: $name, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTable extends UserStats
    with TableInfo<$UserStatsTable, UserStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gamesPlayedMeta = const VerificationMeta(
    'gamesPlayed',
  );
  @override
  late final GeneratedColumn<int> gamesPlayed = GeneratedColumn<int>(
    'games_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _roundsPlayedMeta = const VerificationMeta(
    'roundsPlayed',
  );
  @override
  late final GeneratedColumn<int> roundsPlayed = GeneratedColumn<int>(
    'rounds_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _validAnswersMeta = const VerificationMeta(
    'validAnswers',
  );
  @override
  late final GeneratedColumn<int> validAnswers = GeneratedColumn<int>(
    'valid_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invalidAnswersMeta = const VerificationMeta(
    'invalidAnswers',
  );
  @override
  late final GeneratedColumn<int> invalidAnswers = GeneratedColumn<int>(
    'invalid_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestScoreMeta = const VerificationMeta(
    'bestScore',
  );
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
    'best_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    gamesPlayed,
    roundsPlayed,
    validAnswers,
    invalidAnswers,
    bestScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('games_played')) {
      context.handle(
        _gamesPlayedMeta,
        gamesPlayed.isAcceptableOrUnknown(
          data['games_played']!,
          _gamesPlayedMeta,
        ),
      );
    }
    if (data.containsKey('rounds_played')) {
      context.handle(
        _roundsPlayedMeta,
        roundsPlayed.isAcceptableOrUnknown(
          data['rounds_played']!,
          _roundsPlayedMeta,
        ),
      );
    }
    if (data.containsKey('valid_answers')) {
      context.handle(
        _validAnswersMeta,
        validAnswers.isAcceptableOrUnknown(
          data['valid_answers']!,
          _validAnswersMeta,
        ),
      );
    }
    if (data.containsKey('invalid_answers')) {
      context.handle(
        _invalidAnswersMeta,
        invalidAnswers.isAcceptableOrUnknown(
          data['invalid_answers']!,
          _invalidAnswersMeta,
        ),
      );
    }
    if (data.containsKey('best_score')) {
      context.handle(
        _bestScoreMeta,
        bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      gamesPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_played'],
      )!,
      roundsPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds_played'],
      )!,
      validAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_answers'],
      )!,
      invalidAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invalid_answers'],
      )!,
      bestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_score'],
      )!,
    );
  }

  @override
  $UserStatsTable createAlias(String alias) {
    return $UserStatsTable(attachedDatabase, alias);
  }
}

class UserStat extends DataClass implements Insertable<UserStat> {
  final int id;
  final String userId;
  final int gamesPlayed;
  final int roundsPlayed;
  final int validAnswers;
  final int invalidAnswers;
  final int bestScore;
  const UserStat({
    required this.id,
    required this.userId,
    required this.gamesPlayed,
    required this.roundsPlayed,
    required this.validAnswers,
    required this.invalidAnswers,
    required this.bestScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['games_played'] = Variable<int>(gamesPlayed);
    map['rounds_played'] = Variable<int>(roundsPlayed);
    map['valid_answers'] = Variable<int>(validAnswers);
    map['invalid_answers'] = Variable<int>(invalidAnswers);
    map['best_score'] = Variable<int>(bestScore);
    return map;
  }

  UserStatsCompanion toCompanion(bool nullToAbsent) {
    return UserStatsCompanion(
      id: Value(id),
      userId: Value(userId),
      gamesPlayed: Value(gamesPlayed),
      roundsPlayed: Value(roundsPlayed),
      validAnswers: Value(validAnswers),
      invalidAnswers: Value(invalidAnswers),
      bestScore: Value(bestScore),
    );
  }

  factory UserStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStat(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      gamesPlayed: serializer.fromJson<int>(json['gamesPlayed']),
      roundsPlayed: serializer.fromJson<int>(json['roundsPlayed']),
      validAnswers: serializer.fromJson<int>(json['validAnswers']),
      invalidAnswers: serializer.fromJson<int>(json['invalidAnswers']),
      bestScore: serializer.fromJson<int>(json['bestScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'gamesPlayed': serializer.toJson<int>(gamesPlayed),
      'roundsPlayed': serializer.toJson<int>(roundsPlayed),
      'validAnswers': serializer.toJson<int>(validAnswers),
      'invalidAnswers': serializer.toJson<int>(invalidAnswers),
      'bestScore': serializer.toJson<int>(bestScore),
    };
  }

  UserStat copyWith({
    int? id,
    String? userId,
    int? gamesPlayed,
    int? roundsPlayed,
    int? validAnswers,
    int? invalidAnswers,
    int? bestScore,
  }) => UserStat(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    roundsPlayed: roundsPlayed ?? this.roundsPlayed,
    validAnswers: validAnswers ?? this.validAnswers,
    invalidAnswers: invalidAnswers ?? this.invalidAnswers,
    bestScore: bestScore ?? this.bestScore,
  );
  UserStat copyWithCompanion(UserStatsCompanion data) {
    return UserStat(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      gamesPlayed: data.gamesPlayed.present
          ? data.gamesPlayed.value
          : this.gamesPlayed,
      roundsPlayed: data.roundsPlayed.present
          ? data.roundsPlayed.value
          : this.roundsPlayed,
      validAnswers: data.validAnswers.present
          ? data.validAnswers.value
          : this.validAnswers,
      invalidAnswers: data.invalidAnswers.present
          ? data.invalidAnswers.value
          : this.invalidAnswers,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStat(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('roundsPlayed: $roundsPlayed, ')
          ..write('validAnswers: $validAnswers, ')
          ..write('invalidAnswers: $invalidAnswers, ')
          ..write('bestScore: $bestScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    gamesPlayed,
    roundsPlayed,
    validAnswers,
    invalidAnswers,
    bestScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStat &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.gamesPlayed == this.gamesPlayed &&
          other.roundsPlayed == this.roundsPlayed &&
          other.validAnswers == this.validAnswers &&
          other.invalidAnswers == this.invalidAnswers &&
          other.bestScore == this.bestScore);
}

class UserStatsCompanion extends UpdateCompanion<UserStat> {
  final Value<int> id;
  final Value<String> userId;
  final Value<int> gamesPlayed;
  final Value<int> roundsPlayed;
  final Value<int> validAnswers;
  final Value<int> invalidAnswers;
  final Value<int> bestScore;
  const UserStatsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.gamesPlayed = const Value.absent(),
    this.roundsPlayed = const Value.absent(),
    this.validAnswers = const Value.absent(),
    this.invalidAnswers = const Value.absent(),
    this.bestScore = const Value.absent(),
  });
  UserStatsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.gamesPlayed = const Value.absent(),
    this.roundsPlayed = const Value.absent(),
    this.validAnswers = const Value.absent(),
    this.invalidAnswers = const Value.absent(),
    this.bestScore = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserStat> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? gamesPlayed,
    Expression<int>? roundsPlayed,
    Expression<int>? validAnswers,
    Expression<int>? invalidAnswers,
    Expression<int>? bestScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (gamesPlayed != null) 'games_played': gamesPlayed,
      if (roundsPlayed != null) 'rounds_played': roundsPlayed,
      if (validAnswers != null) 'valid_answers': validAnswers,
      if (invalidAnswers != null) 'invalid_answers': invalidAnswers,
      if (bestScore != null) 'best_score': bestScore,
    });
  }

  UserStatsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<int>? gamesPlayed,
    Value<int>? roundsPlayed,
    Value<int>? validAnswers,
    Value<int>? invalidAnswers,
    Value<int>? bestScore,
  }) {
    return UserStatsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      validAnswers: validAnswers ?? this.validAnswers,
      invalidAnswers: invalidAnswers ?? this.invalidAnswers,
      bestScore: bestScore ?? this.bestScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (gamesPlayed.present) {
      map['games_played'] = Variable<int>(gamesPlayed.value);
    }
    if (roundsPlayed.present) {
      map['rounds_played'] = Variable<int>(roundsPlayed.value);
    }
    if (validAnswers.present) {
      map['valid_answers'] = Variable<int>(validAnswers.value);
    }
    if (invalidAnswers.present) {
      map['invalid_answers'] = Variable<int>(invalidAnswers.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('roundsPlayed: $roundsPlayed, ')
          ..write('validAnswers: $validAnswers, ')
          ..write('invalidAnswers: $invalidAnswers, ')
          ..write('bestScore: $bestScore')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, Round> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSpentMeta = const VerificationMeta(
    'timeSpent',
  );
  @override
  late final GeneratedColumn<int> timeSpent = GeneratedColumn<int>(
    'time_spent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    category,
    score,
    timeSpent,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Round> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('time_spent')) {
      context.handle(
        _timeSpentMeta,
        timeSpent.isAcceptableOrUnknown(data['time_spent']!, _timeSpentMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSpentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Round map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Round(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      timeSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }
}

class Round extends DataClass implements Insertable<Round> {
  final int id;
  final String userId;
  final String category;
  final int score;
  final int timeSpent;
  final String date;
  const Round({
    required this.id,
    required this.userId,
    required this.category,
    required this.score,
    required this.timeSpent,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['category'] = Variable<String>(category);
    map['score'] = Variable<int>(score);
    map['time_spent'] = Variable<int>(timeSpent);
    map['date'] = Variable<String>(date);
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      score: Value(score),
      timeSpent: Value(timeSpent),
      date: Value(date),
    );
  }

  factory Round.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Round(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      category: serializer.fromJson<String>(json['category']),
      score: serializer.fromJson<int>(json['score']),
      timeSpent: serializer.fromJson<int>(json['timeSpent']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'category': serializer.toJson<String>(category),
      'score': serializer.toJson<int>(score),
      'timeSpent': serializer.toJson<int>(timeSpent),
      'date': serializer.toJson<String>(date),
    };
  }

  Round copyWith({
    int? id,
    String? userId,
    String? category,
    int? score,
    int? timeSpent,
    String? date,
  }) => Round(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    score: score ?? this.score,
    timeSpent: timeSpent ?? this.timeSpent,
    date: date ?? this.date,
  );
  Round copyWithCompanion(RoundsCompanion data) {
    return Round(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      score: data.score.present ? data.score.value : this.score,
      timeSpent: data.timeSpent.present ? data.timeSpent.value : this.timeSpent,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Round(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('score: $score, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, category, score, timeSpent, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Round &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.score == this.score &&
          other.timeSpent == this.timeSpent &&
          other.date == this.date);
}

class RoundsCompanion extends UpdateCompanion<Round> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> category;
  final Value<int> score;
  final Value<int> timeSpent;
  final Value<String> date;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.score = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.date = const Value.absent(),
  });
  RoundsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String category,
    required int score,
    required int timeSpent,
    required String date,
  }) : userId = Value(userId),
       category = Value(category),
       score = Value(score),
       timeSpent = Value(timeSpent),
       date = Value(date);
  static Insertable<Round> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? category,
    Expression<int>? score,
    Expression<int>? timeSpent,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (score != null) 'score': score,
      if (timeSpent != null) 'time_spent': timeSpent,
      if (date != null) 'date': date,
    });
  }

  RoundsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? category,
    Value<int>? score,
    Value<int>? timeSpent,
    Value<String>? date,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      score: score ?? this.score,
      timeSpent: timeSpent ?? this.timeSpent,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (timeSpent.present) {
      map['time_spent'] = Variable<int>(timeSpent.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('score: $score, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserStatsTable userStats = $UserStatsTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final StatsDao statsDao = StatsDao(this as AppDatabase);
  late final RoundsDao roundsDao = RoundsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    userStats,
    rounds,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required String nickname,
      Value<String?> name,
      Value<String?> country,
      Value<String?> city,
      Value<String?> birthDate,
      Value<String?> gender,
      Value<String?> avatarPath,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> nickname,
      Value<String?> name,
      Value<String?> country,
      Value<String?> city,
      Value<String?> birthDate,
      Value<String?> gender,
      Value<String?> avatarPath,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                nickname: nickname,
                name: name,
                country: country,
                city: city,
                birthDate: birthDate,
                gender: gender,
                avatarPath: avatarPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String nickname,
                Value<String?> name = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                nickname: nickname,
                name: name,
                country: country,
                city: city,
                birthDate: birthDate,
                gender: gender,
                avatarPath: avatarPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$UserStatsTableCreateCompanionBuilder =
    UserStatsCompanion Function({
      Value<int> id,
      required String userId,
      Value<int> gamesPlayed,
      Value<int> roundsPlayed,
      Value<int> validAnswers,
      Value<int> invalidAnswers,
      Value<int> bestScore,
    });
typedef $$UserStatsTableUpdateCompanionBuilder =
    UserStatsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<int> gamesPlayed,
      Value<int> roundsPlayed,
      Value<int> validAnswers,
      Value<int> invalidAnswers,
      Value<int> bestScore,
    });

class $$UserStatsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundsPlayed => $composableBuilder(
    column: $table.roundsPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validAnswers => $composableBuilder(
    column: $table.validAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invalidAnswers => $composableBuilder(
    column: $table.invalidAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundsPlayed => $composableBuilder(
    column: $table.roundsPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validAnswers => $composableBuilder(
    column: $table.validAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invalidAnswers => $composableBuilder(
    column: $table.invalidAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roundsPlayed => $composableBuilder(
    column: $table.roundsPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get validAnswers => $composableBuilder(
    column: $table.validAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invalidAnswers => $composableBuilder(
    column: $table.invalidAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);
}

class $$UserStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTable,
          UserStat,
          $$UserStatsTableFilterComposer,
          $$UserStatsTableOrderingComposer,
          $$UserStatsTableAnnotationComposer,
          $$UserStatsTableCreateCompanionBuilder,
          $$UserStatsTableUpdateCompanionBuilder,
          (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
          UserStat,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableManager(_$AppDatabase db, $UserStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> gamesPlayed = const Value.absent(),
                Value<int> roundsPlayed = const Value.absent(),
                Value<int> validAnswers = const Value.absent(),
                Value<int> invalidAnswers = const Value.absent(),
                Value<int> bestScore = const Value.absent(),
              }) => UserStatsCompanion(
                id: id,
                userId: userId,
                gamesPlayed: gamesPlayed,
                roundsPlayed: roundsPlayed,
                validAnswers: validAnswers,
                invalidAnswers: invalidAnswers,
                bestScore: bestScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                Value<int> gamesPlayed = const Value.absent(),
                Value<int> roundsPlayed = const Value.absent(),
                Value<int> validAnswers = const Value.absent(),
                Value<int> invalidAnswers = const Value.absent(),
                Value<int> bestScore = const Value.absent(),
              }) => UserStatsCompanion.insert(
                id: id,
                userId: userId,
                gamesPlayed: gamesPlayed,
                roundsPlayed: roundsPlayed,
                validAnswers: validAnswers,
                invalidAnswers: invalidAnswers,
                bestScore: bestScore,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTable,
      UserStat,
      $$UserStatsTableFilterComposer,
      $$UserStatsTableOrderingComposer,
      $$UserStatsTableAnnotationComposer,
      $$UserStatsTableCreateCompanionBuilder,
      $$UserStatsTableUpdateCompanionBuilder,
      (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
      UserStat,
      PrefetchHooks Function()
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      required String userId,
      required String category,
      required int score,
      required int timeSpent,
      required String date,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> category,
      Value<int> score,
      Value<int> timeSpent,
      Value<String> date,
    });

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpent => $composableBuilder(
    column: $table.timeSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpent => $composableBuilder(
    column: $table.timeSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get timeSpent =>
      $composableBuilder(column: $table.timeSpent, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          Round,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (Round, BaseReferences<_$AppDatabase, $RoundsTable, Round>),
          Round,
          PrefetchHooks Function()
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> timeSpent = const Value.absent(),
                Value<String> date = const Value.absent(),
              }) => RoundsCompanion(
                id: id,
                userId: userId,
                category: category,
                score: score,
                timeSpent: timeSpent,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String category,
                required int score,
                required int timeSpent,
                required String date,
              }) => RoundsCompanion.insert(
                id: id,
                userId: userId,
                category: category,
                score: score,
                timeSpent: timeSpent,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      Round,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (Round, BaseReferences<_$AppDatabase, $RoundsTable, Round>),
      Round,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
}
