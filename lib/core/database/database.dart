import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

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

// Tables can mix-in common definitions if needed
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('HostInfo')
class HostInfos extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();

  /// 0: default, 1: Debian, 2: Ubuntu, 3: CentOS, 4: Arch Linux
  IntColumn get type => integer().withDefault(const Constant(0))();
  TextColumn get tagNum => text().map(const IntListConverter())();
  TextColumn get comment => text().nullable()();
  TextColumn get host => text()();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get username => text()();
  IntColumn get passwordType =>
      integer().withDefault(const Constant(0))(); // 0: password, 1: privateKey
  TextColumn get password => text().nullable()();
  IntColumn get privateKeyId =>
      integer().nullable().references(PrivateKeys, #id)();
  DateTimeColumn get lastLoginTime => dateTime().nullable()();
}

@DataClassName('PrivateKey')
class PrivateKeys extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  TextColumn get privateKey => text()();
  TextColumn get password => text().nullable()();
  TextColumn get comment => text().nullable()();
}

@DriftDatabase(tables: [HostInfos, PrivateKeys])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'Terminflow',
      native: const DriftNativeOptions(
        databaseDirectory:
            getApplicationSupportDirectory, // C:\Users\username\AppData\Roaming\com.example\terminflow
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            debugPrint(
              'Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }

  // 添加到AppDatabase类中
  Future updateConnectionTypeAndLastLoginTime(int id, int type) async {
    return transaction(() async {
      return await (update(hostInfos)..where((t) => t.id.equals(id))).write(
        HostInfosCompanion(
          type: Value(type),
          lastLoginTime: Value(DateTime.now()),
        ),
      );
    });
  }

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);

    return database;
  });

  // watchAllHostInfos
  Stream<List<HostInfo>> watchAllHostInfos() {
    return select(hostInfos).watch();
  }

  // watchAllPrivateKeys
  Stream<List<PrivateKey>> watchAllPrivateKeys() {
    return select(privateKeys).watch();
  }

  // getPrivateKeyById
  Future<PrivateKey?> getPrivateKeyById(int id) {
    debugPrint('getPrivateKeyById: $id');
    return (select(privateKeys)..where((t) => t.id.equals(id))).getSingle();
  }

  
}
