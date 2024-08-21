import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastService {
  late Database _db;
  bool _isDbInitialized = false;

  // Initialize the database if not already initialized
  Future<void> _initDb() async {
    if (!_isDbInitialized) {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = '${appDir.path}/auth.db';
      final dbFactory = databaseFactoryIo;
      _db = await dbFactory.openDatabase(dbPath);
      _isDbInitialized = true;
      print('Database initialized at: $dbPath');
    }
  }

  // Save the token to the database
  Future<void> saveToken(String token) async {
    await _initDb();
    print('Saving token: $token');
    final store = StoreRef.main();
    await store.record('token').put(_db, token);
    final savedToken = await store.record('token').get(_db) as String?;
    if (savedToken != null && savedToken == token) {
      print('Token saved successfully.');
    } else {
      print('Failed to save token.');
    }
  }

  // Retrieve the token from the database
  Future<String?> getToken() async {
    await _initDb();
    final store = StoreRef.main();
    final token = await store.record('token').get(_db) as String?;
    print('Retrieved token: $token');
    return token;
  }
}
