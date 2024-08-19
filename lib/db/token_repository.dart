import 'package:sembast/sembast.dart';

import 'sembast_service.dart';

class TokenRepository {
  final _store = StoreRef.main();

  Future<void> saveToken(String token) async {
    await _store.record('token').put(SembastService().database, token);
  }

  Future<String?> getToken() async {
    return await _store.record('token').get(SembastService().database)
        as String?;
  }
}
