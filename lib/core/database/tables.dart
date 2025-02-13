import 'package:drift/drift.dart';

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    return fromDb.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  String toSql(List<int> value) {
    return value.join(',');
  }
}

@DataClassName('SSHConnection')
class SSHConnections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  TextColumn get tagNum => text().map(const IntListConverter())();
  TextColumn get comment => text().nullable()();
  TextColumn get host => text()();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get username => text()();
  TextColumn get password => text()();
  DateTimeColumn get lastLoginTime => dateTime().nullable()();
}
