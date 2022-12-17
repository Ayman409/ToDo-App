import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? db;
  static const int version = 1;
  static const String tableName = 'tasks';
  static Future<void> initdb() async {
    if (db != null) {
      print('not null database already exists');
      return;
    } else {
      try {
        String dbPath = await getDatabasesPath() + 'tasks.db';
        
        db = await openDatabase(dbPath, version: version,
            onCreate: (Database db, int version) async {
          print('crating database');
          // When creating the db, create the table
          await db.execute('CREATE TABLE $tableName ('
              'id INTEGER PRIMARY KEY, '
              'title String, note Text, date String, '
              'startTime String, endTime String, '
              'remind INTEGER, repeat String, '
              'color INTEGER,'
              ' isCompleted INTEGER)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('Insert Function Called');
    return await db!.insert(tableName, task!.tojson());
  }

  static Future<int> delete(Task? task) async {
    print('Delete Function Called');
    return await db!.delete(tableName, where: 'id=?', whereArgs: [task!.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('Query Function Called');
    return await db!.query(tableName);
  }

  static Future<int> update(int id) async {
    print('Update Function Called');
    return await db!.rawUpdate(
        '''
UPDATE tasks 
Set isCompleted = ?
WHERE id= ?
''', [1, id]);
  }
}
