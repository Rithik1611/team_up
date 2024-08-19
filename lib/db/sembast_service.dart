import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastService {
  static final SembastService _singleton = SembastService._internal();
  late Database _database;

  factory SembastService() {
    return _singleton;
  }

  SembastService._internal();

  Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = appDocDir.path + '/my_database.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    _database = await dbFactory.openDatabase(dbPath);
  }

  Database get database => _database;
}
