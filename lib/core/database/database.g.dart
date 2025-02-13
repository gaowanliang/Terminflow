// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PrivateKeysTable extends PrivateKeys
    with TableInfo<$PrivateKeysTable, PrivateKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _privateKeyMeta =
      const VerificationMeta('privateKey');
  @override
  late final GeneratedColumn<String> privateKey = GeneratedColumn<String>(
      'private_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, privateKey, password, comment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_keys';
  @override
  VerificationContext validateIntegrity(Insertable<PrivateKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('private_key')) {
      context.handle(
          _privateKeyMeta,
          privateKey.isAcceptableOrUnknown(
              data['private_key']!, _privateKeyMeta));
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrivateKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      privateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}private_key'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
    );
  }

  @override
  $PrivateKeysTable createAlias(String alias) {
    return $PrivateKeysTable(attachedDatabase, alias);
  }
}

class PrivateKey extends DataClass implements Insertable<PrivateKey> {
  final int id;
  final String name;
  final String privateKey;
  final String? password;
  final String? comment;
  const PrivateKey(
      {required this.id,
      required this.name,
      required this.privateKey,
      this.password,
      this.comment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['private_key'] = Variable<String>(privateKey);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  PrivateKeysCompanion toCompanion(bool nullToAbsent) {
    return PrivateKeysCompanion(
      id: Value(id),
      name: Value(name),
      privateKey: Value(privateKey),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory PrivateKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateKey(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      privateKey: serializer.fromJson<String>(json['privateKey']),
      password: serializer.fromJson<String?>(json['password']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'privateKey': serializer.toJson<String>(privateKey),
      'password': serializer.toJson<String?>(password),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  PrivateKey copyWith(
          {int? id,
          String? name,
          String? privateKey,
          Value<String?> password = const Value.absent(),
          Value<String?> comment = const Value.absent()}) =>
      PrivateKey(
        id: id ?? this.id,
        name: name ?? this.name,
        privateKey: privateKey ?? this.privateKey,
        password: password.present ? password.value : this.password,
        comment: comment.present ? comment.value : this.comment,
      );
  PrivateKey copyWithCompanion(PrivateKeysCompanion data) {
    return PrivateKey(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      privateKey:
          data.privateKey.present ? data.privateKey.value : this.privateKey,
      password: data.password.present ? data.password.value : this.password,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateKey(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('privateKey: $privateKey, ')
          ..write('password: $password, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, privateKey, password, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateKey &&
          other.id == this.id &&
          other.name == this.name &&
          other.privateKey == this.privateKey &&
          other.password == this.password &&
          other.comment == this.comment);
}

class PrivateKeysCompanion extends UpdateCompanion<PrivateKey> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> privateKey;
  final Value<String?> password;
  final Value<String?> comment;
  const PrivateKeysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.password = const Value.absent(),
    this.comment = const Value.absent(),
  });
  PrivateKeysCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String privateKey,
    this.password = const Value.absent(),
    this.comment = const Value.absent(),
  })  : name = Value(name),
        privateKey = Value(privateKey);
  static Insertable<PrivateKey> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? privateKey,
    Expression<String>? password,
    Expression<String>? comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (privateKey != null) 'private_key': privateKey,
      if (password != null) 'password': password,
      if (comment != null) 'comment': comment,
    });
  }

  PrivateKeysCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? privateKey,
      Value<String?>? password,
      Value<String?>? comment}) {
    return PrivateKeysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      privateKey: privateKey ?? this.privateKey,
      password: password ?? this.password,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<String>(privateKey.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateKeysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('privateKey: $privateKey, ')
          ..write('password: $password, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $HostInfosTable extends HostInfos
    with TableInfo<$HostInfosTable, HostInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HostInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tagNumMeta = const VerificationMeta('tagNum');
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> tagNum =
      GeneratedColumn<String>('tag_num', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<int>>($HostInfosTable.$convertertagNum);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
      'host', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(22));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordTypeMeta =
      const VerificationMeta('passwordType');
  @override
  late final GeneratedColumn<int> passwordType = GeneratedColumn<int>(
      'password_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _privateKeyIdMeta =
      const VerificationMeta('privateKeyId');
  @override
  late final GeneratedColumn<int> privateKeyId = GeneratedColumn<int>(
      'private_key_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES private_keys (id)'));
  static const VerificationMeta _lastLoginTimeMeta =
      const VerificationMeta('lastLoginTime');
  @override
  late final GeneratedColumn<DateTime> lastLoginTime =
      GeneratedColumn<DateTime>('last_login_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        tagNum,
        comment,
        host,
        port,
        username,
        passwordType,
        password,
        privateKeyId,
        lastLoginTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'host_infos';
  @override
  VerificationContext validateIntegrity(Insertable<HostInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    context.handle(_tagNumMeta, const VerificationResult.success());
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_type')) {
      context.handle(
          _passwordTypeMeta,
          passwordType.isAcceptableOrUnknown(
              data['password_type']!, _passwordTypeMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('private_key_id')) {
      context.handle(
          _privateKeyIdMeta,
          privateKeyId.isAcceptableOrUnknown(
              data['private_key_id']!, _privateKeyIdMeta));
    }
    if (data.containsKey('last_login_time')) {
      context.handle(
          _lastLoginTimeMeta,
          lastLoginTime.isAcceptableOrUnknown(
              data['last_login_time']!, _lastLoginTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HostInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HostInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      tagNum: $HostInfosTable.$convertertagNum.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_num'])!),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      host: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}password_type'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      privateKeyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}private_key_id']),
      lastLoginTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_login_time']),
    );
  }

  @override
  $HostInfosTable createAlias(String alias) {
    return $HostInfosTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $convertertagNum =
      const IntListConverter();
}

class HostInfo extends DataClass implements Insertable<HostInfo> {
  final int id;
  final String name;

  /// 0: default, 1: Debian, 2: Ubuntu, 3: CentOS, 4: Arch Linux
  final int type;
  final List<int> tagNum;
  final String? comment;
  final String host;
  final int port;
  final String username;
  final int passwordType;
  final String? password;
  final int? privateKeyId;
  final DateTime? lastLoginTime;
  const HostInfo(
      {required this.id,
      required this.name,
      required this.type,
      required this.tagNum,
      this.comment,
      required this.host,
      required this.port,
      required this.username,
      required this.passwordType,
      this.password,
      this.privateKeyId,
      this.lastLoginTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    {
      map['tag_num'] =
          Variable<String>($HostInfosTable.$convertertagNum.toSql(tagNum));
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['password_type'] = Variable<int>(passwordType);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || privateKeyId != null) {
      map['private_key_id'] = Variable<int>(privateKeyId);
    }
    if (!nullToAbsent || lastLoginTime != null) {
      map['last_login_time'] = Variable<DateTime>(lastLoginTime);
    }
    return map;
  }

  HostInfosCompanion toCompanion(bool nullToAbsent) {
    return HostInfosCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      tagNum: Value(tagNum),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      host: Value(host),
      port: Value(port),
      username: Value(username),
      passwordType: Value(passwordType),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      privateKeyId: privateKeyId == null && nullToAbsent
          ? const Value.absent()
          : Value(privateKeyId),
      lastLoginTime: lastLoginTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginTime),
    );
  }

  factory HostInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HostInfo(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      tagNum: serializer.fromJson<List<int>>(json['tagNum']),
      comment: serializer.fromJson<String?>(json['comment']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      passwordType: serializer.fromJson<int>(json['passwordType']),
      password: serializer.fromJson<String?>(json['password']),
      privateKeyId: serializer.fromJson<int?>(json['privateKeyId']),
      lastLoginTime: serializer.fromJson<DateTime?>(json['lastLoginTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'tagNum': serializer.toJson<List<int>>(tagNum),
      'comment': serializer.toJson<String?>(comment),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'passwordType': serializer.toJson<int>(passwordType),
      'password': serializer.toJson<String?>(password),
      'privateKeyId': serializer.toJson<int?>(privateKeyId),
      'lastLoginTime': serializer.toJson<DateTime?>(lastLoginTime),
    };
  }

  HostInfo copyWith(
          {int? id,
          String? name,
          int? type,
          List<int>? tagNum,
          Value<String?> comment = const Value.absent(),
          String? host,
          int? port,
          String? username,
          int? passwordType,
          Value<String?> password = const Value.absent(),
          Value<int?> privateKeyId = const Value.absent(),
          Value<DateTime?> lastLoginTime = const Value.absent()}) =>
      HostInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        tagNum: tagNum ?? this.tagNum,
        comment: comment.present ? comment.value : this.comment,
        host: host ?? this.host,
        port: port ?? this.port,
        username: username ?? this.username,
        passwordType: passwordType ?? this.passwordType,
        password: password.present ? password.value : this.password,
        privateKeyId:
            privateKeyId.present ? privateKeyId.value : this.privateKeyId,
        lastLoginTime:
            lastLoginTime.present ? lastLoginTime.value : this.lastLoginTime,
      );
  HostInfo copyWithCompanion(HostInfosCompanion data) {
    return HostInfo(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      tagNum: data.tagNum.present ? data.tagNum.value : this.tagNum,
      comment: data.comment.present ? data.comment.value : this.comment,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      passwordType: data.passwordType.present
          ? data.passwordType.value
          : this.passwordType,
      password: data.password.present ? data.password.value : this.password,
      privateKeyId: data.privateKeyId.present
          ? data.privateKeyId.value
          : this.privateKeyId,
      lastLoginTime: data.lastLoginTime.present
          ? data.lastLoginTime.value
          : this.lastLoginTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HostInfo(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('tagNum: $tagNum, ')
          ..write('comment: $comment, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('passwordType: $passwordType, ')
          ..write('password: $password, ')
          ..write('privateKeyId: $privateKeyId, ')
          ..write('lastLoginTime: $lastLoginTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, tagNum, comment, host, port,
      username, passwordType, password, privateKeyId, lastLoginTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HostInfo &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.tagNum == this.tagNum &&
          other.comment == this.comment &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.passwordType == this.passwordType &&
          other.password == this.password &&
          other.privateKeyId == this.privateKeyId &&
          other.lastLoginTime == this.lastLoginTime);
}

class HostInfosCompanion extends UpdateCompanion<HostInfo> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> type;
  final Value<List<int>> tagNum;
  final Value<String?> comment;
  final Value<String> host;
  final Value<int> port;
  final Value<String> username;
  final Value<int> passwordType;
  final Value<String?> password;
  final Value<int?> privateKeyId;
  final Value<DateTime?> lastLoginTime;
  const HostInfosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.tagNum = const Value.absent(),
    this.comment = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordType = const Value.absent(),
    this.password = const Value.absent(),
    this.privateKeyId = const Value.absent(),
    this.lastLoginTime = const Value.absent(),
  });
  HostInfosCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    required List<int> tagNum,
    this.comment = const Value.absent(),
    required String host,
    this.port = const Value.absent(),
    required String username,
    this.passwordType = const Value.absent(),
    this.password = const Value.absent(),
    this.privateKeyId = const Value.absent(),
    this.lastLoginTime = const Value.absent(),
  })  : name = Value(name),
        tagNum = Value(tagNum),
        host = Value(host),
        username = Value(username);
  static Insertable<HostInfo> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? tagNum,
    Expression<String>? comment,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<int>? passwordType,
    Expression<String>? password,
    Expression<int>? privateKeyId,
    Expression<DateTime>? lastLoginTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (tagNum != null) 'tag_num': tagNum,
      if (comment != null) 'comment': comment,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (passwordType != null) 'password_type': passwordType,
      if (password != null) 'password': password,
      if (privateKeyId != null) 'private_key_id': privateKeyId,
      if (lastLoginTime != null) 'last_login_time': lastLoginTime,
    });
  }

  HostInfosCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? type,
      Value<List<int>>? tagNum,
      Value<String?>? comment,
      Value<String>? host,
      Value<int>? port,
      Value<String>? username,
      Value<int>? passwordType,
      Value<String?>? password,
      Value<int?>? privateKeyId,
      Value<DateTime?>? lastLoginTime}) {
    return HostInfosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      tagNum: tagNum ?? this.tagNum,
      comment: comment ?? this.comment,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      passwordType: passwordType ?? this.passwordType,
      password: password ?? this.password,
      privateKeyId: privateKeyId ?? this.privateKeyId,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (tagNum.present) {
      map['tag_num'] = Variable<String>(
          $HostInfosTable.$convertertagNum.toSql(tagNum.value));
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordType.present) {
      map['password_type'] = Variable<int>(passwordType.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (privateKeyId.present) {
      map['private_key_id'] = Variable<int>(privateKeyId.value);
    }
    if (lastLoginTime.present) {
      map['last_login_time'] = Variable<DateTime>(lastLoginTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HostInfosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('tagNum: $tagNum, ')
          ..write('comment: $comment, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('passwordType: $passwordType, ')
          ..write('password: $password, ')
          ..write('privateKeyId: $privateKeyId, ')
          ..write('lastLoginTime: $lastLoginTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PrivateKeysTable privateKeys = $PrivateKeysTable(this);
  late final $HostInfosTable hostInfos = $HostInfosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [privateKeys, hostInfos];
}

typedef $$PrivateKeysTableCreateCompanionBuilder = PrivateKeysCompanion
    Function({
  Value<int> id,
  required String name,
  required String privateKey,
  Value<String?> password,
  Value<String?> comment,
});
typedef $$PrivateKeysTableUpdateCompanionBuilder = PrivateKeysCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> privateKey,
  Value<String?> password,
  Value<String?> comment,
});

final class $$PrivateKeysTableReferences
    extends BaseReferences<_$AppDatabase, $PrivateKeysTable, PrivateKey> {
  $$PrivateKeysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HostInfosTable, List<HostInfo>>
      _hostInfosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.hostInfos,
              aliasName: $_aliasNameGenerator(
                  db.privateKeys.id, db.hostInfos.privateKeyId));

  $$HostInfosTableProcessedTableManager get hostInfosRefs {
    final manager = $$HostInfosTableTableManager($_db, $_db.hostInfos)
        .filter((f) => f.privateKeyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hostInfosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PrivateKeysTableFilterComposer
    extends Composer<_$AppDatabase, $PrivateKeysTable> {
  $$PrivateKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  Expression<bool> hostInfosRefs(
      Expression<bool> Function($$HostInfosTableFilterComposer f) f) {
    final $$HostInfosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hostInfos,
        getReferencedColumn: (t) => t.privateKeyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HostInfosTableFilterComposer(
              $db: $db,
              $table: $db.hostInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PrivateKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivateKeysTable> {
  $$PrivateKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));
}

class $$PrivateKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivateKeysTable> {
  $$PrivateKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  Expression<T> hostInfosRefs<T extends Object>(
      Expression<T> Function($$HostInfosTableAnnotationComposer a) f) {
    final $$HostInfosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hostInfos,
        getReferencedColumn: (t) => t.privateKeyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HostInfosTableAnnotationComposer(
              $db: $db,
              $table: $db.hostInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PrivateKeysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrivateKeysTable,
    PrivateKey,
    $$PrivateKeysTableFilterComposer,
    $$PrivateKeysTableOrderingComposer,
    $$PrivateKeysTableAnnotationComposer,
    $$PrivateKeysTableCreateCompanionBuilder,
    $$PrivateKeysTableUpdateCompanionBuilder,
    (PrivateKey, $$PrivateKeysTableReferences),
    PrivateKey,
    PrefetchHooks Function({bool hostInfosRefs})> {
  $$PrivateKeysTableTableManager(_$AppDatabase db, $PrivateKeysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivateKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrivateKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> privateKey = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> comment = const Value.absent(),
          }) =>
              PrivateKeysCompanion(
            id: id,
            name: name,
            privateKey: privateKey,
            password: password,
            comment: comment,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String privateKey,
            Value<String?> password = const Value.absent(),
            Value<String?> comment = const Value.absent(),
          }) =>
              PrivateKeysCompanion.insert(
            id: id,
            name: name,
            privateKey: privateKey,
            password: password,
            comment: comment,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PrivateKeysTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({hostInfosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (hostInfosRefs) db.hostInfos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hostInfosRefs)
                    await $_getPrefetchedData<PrivateKey, $PrivateKeysTable,
                            HostInfo>(
                        currentTable: table,
                        referencedTable: $$PrivateKeysTableReferences
                            ._hostInfosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PrivateKeysTableReferences(db, table, p0)
                                .hostInfosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.privateKeyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PrivateKeysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrivateKeysTable,
    PrivateKey,
    $$PrivateKeysTableFilterComposer,
    $$PrivateKeysTableOrderingComposer,
    $$PrivateKeysTableAnnotationComposer,
    $$PrivateKeysTableCreateCompanionBuilder,
    $$PrivateKeysTableUpdateCompanionBuilder,
    (PrivateKey, $$PrivateKeysTableReferences),
    PrivateKey,
    PrefetchHooks Function({bool hostInfosRefs})>;
typedef $$HostInfosTableCreateCompanionBuilder = HostInfosCompanion Function({
  Value<int> id,
  required String name,
  Value<int> type,
  required List<int> tagNum,
  Value<String?> comment,
  required String host,
  Value<int> port,
  required String username,
  Value<int> passwordType,
  Value<String?> password,
  Value<int?> privateKeyId,
  Value<DateTime?> lastLoginTime,
});
typedef $$HostInfosTableUpdateCompanionBuilder = HostInfosCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> type,
  Value<List<int>> tagNum,
  Value<String?> comment,
  Value<String> host,
  Value<int> port,
  Value<String> username,
  Value<int> passwordType,
  Value<String?> password,
  Value<int?> privateKeyId,
  Value<DateTime?> lastLoginTime,
});

final class $$HostInfosTableReferences
    extends BaseReferences<_$AppDatabase, $HostInfosTable, HostInfo> {
  $$HostInfosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PrivateKeysTable _privateKeyIdTable(_$AppDatabase db) =>
      db.privateKeys.createAlias(
          $_aliasNameGenerator(db.hostInfos.privateKeyId, db.privateKeys.id));

  $$PrivateKeysTableProcessedTableManager? get privateKeyId {
    final $_column = $_itemColumn<int>('private_key_id');
    if ($_column == null) return null;
    final manager = $$PrivateKeysTableTableManager($_db, $_db.privateKeys)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_privateKeyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HostInfosTableFilterComposer
    extends Composer<_$AppDatabase, $HostInfosTable> {
  $$HostInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get tagNum =>
      $composableBuilder(
          column: $table.tagNum,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get passwordType => $composableBuilder(
      column: $table.passwordType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime, builder: (column) => ColumnFilters(column));

  $$PrivateKeysTableFilterComposer get privateKeyId {
    final $$PrivateKeysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.privateKeyId,
        referencedTable: $db.privateKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrivateKeysTableFilterComposer(
              $db: $db,
              $table: $db.privateKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HostInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $HostInfosTable> {
  $$HostInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagNum => $composableBuilder(
      column: $table.tagNum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get passwordType => $composableBuilder(
      column: $table.passwordType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime,
      builder: (column) => ColumnOrderings(column));

  $$PrivateKeysTableOrderingComposer get privateKeyId {
    final $$PrivateKeysTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.privateKeyId,
        referencedTable: $db.privateKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrivateKeysTableOrderingComposer(
              $db: $db,
              $table: $db.privateKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HostInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $HostInfosTable> {
  $$HostInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get tagNum =>
      $composableBuilder(column: $table.tagNum, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<int> get passwordType => $composableBuilder(
      column: $table.passwordType, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginTime => $composableBuilder(
      column: $table.lastLoginTime, builder: (column) => column);

  $$PrivateKeysTableAnnotationComposer get privateKeyId {
    final $$PrivateKeysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.privateKeyId,
        referencedTable: $db.privateKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrivateKeysTableAnnotationComposer(
              $db: $db,
              $table: $db.privateKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HostInfosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HostInfosTable,
    HostInfo,
    $$HostInfosTableFilterComposer,
    $$HostInfosTableOrderingComposer,
    $$HostInfosTableAnnotationComposer,
    $$HostInfosTableCreateCompanionBuilder,
    $$HostInfosTableUpdateCompanionBuilder,
    (HostInfo, $$HostInfosTableReferences),
    HostInfo,
    PrefetchHooks Function({bool privateKeyId})> {
  $$HostInfosTableTableManager(_$AppDatabase db, $HostInfosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HostInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HostInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HostInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<List<int>> tagNum = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String> host = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<int> passwordType = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<int?> privateKeyId = const Value.absent(),
            Value<DateTime?> lastLoginTime = const Value.absent(),
          }) =>
              HostInfosCompanion(
            id: id,
            name: name,
            type: type,
            tagNum: tagNum,
            comment: comment,
            host: host,
            port: port,
            username: username,
            passwordType: passwordType,
            password: password,
            privateKeyId: privateKeyId,
            lastLoginTime: lastLoginTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> type = const Value.absent(),
            required List<int> tagNum,
            Value<String?> comment = const Value.absent(),
            required String host,
            Value<int> port = const Value.absent(),
            required String username,
            Value<int> passwordType = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<int?> privateKeyId = const Value.absent(),
            Value<DateTime?> lastLoginTime = const Value.absent(),
          }) =>
              HostInfosCompanion.insert(
            id: id,
            name: name,
            type: type,
            tagNum: tagNum,
            comment: comment,
            host: host,
            port: port,
            username: username,
            passwordType: passwordType,
            password: password,
            privateKeyId: privateKeyId,
            lastLoginTime: lastLoginTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HostInfosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({privateKeyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (privateKeyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.privateKeyId,
                    referencedTable:
                        $$HostInfosTableReferences._privateKeyIdTable(db),
                    referencedColumn:
                        $$HostInfosTableReferences._privateKeyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HostInfosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HostInfosTable,
    HostInfo,
    $$HostInfosTableFilterComposer,
    $$HostInfosTableOrderingComposer,
    $$HostInfosTableAnnotationComposer,
    $$HostInfosTableCreateCompanionBuilder,
    $$HostInfosTableUpdateCompanionBuilder,
    (HostInfo, $$HostInfosTableReferences),
    HostInfo,
    PrefetchHooks Function({bool privateKeyId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrivateKeysTableTableManager get privateKeys =>
      $$PrivateKeysTableTableManager(_db, _db.privateKeys);
  $$HostInfosTableTableManager get hostInfos =>
      $$HostInfosTableTableManager(_db, _db.hostInfos);
}
