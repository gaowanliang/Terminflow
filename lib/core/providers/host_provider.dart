import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';

final activeHosts = StateProvider<HostInfo?>((_) => null);
final hostsStreamProvider = StreamProvider.autoDispose<List<HostInfo>>((ref) {
  final db = ref.watch(AppDatabase.provider);
  return db.watchAllHostInfos();
});
