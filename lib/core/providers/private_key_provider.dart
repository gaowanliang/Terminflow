import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';

final activePrivateKey = StateProvider<PrivateKey?>((_) => null);
final privateKeyStreamProvider = StreamProvider.autoDispose<List<PrivateKey>>((ref) {
  final db = ref.watch(AppDatabase.provider);
  return db.watchAllPrivateKeys();
});
