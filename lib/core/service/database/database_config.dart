// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseConfig {
//   const DatabaseConfig({required this.database});
//
//   final Database database;
//
//   static Future<DatabaseConfig> init() async {
//     final String databasesPath = await getDatabasesPath();
//     final String path = join(databasesPath, 'test1');
//     //await deleteDatabase(path);
//     Database database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//           """CREATE TABLE themeMode (mode TEXT NOT NULL)""",
//         ); // await User.execute(db);
//         //  await db.execute("""CREATE TABLE device (
//         //   id TEXT NOT NULL,
//         //   language TEXT NOT NULL DEFAULT 'uz'
//         //   )
//         //  """);
//       },
//     );
//     return DatabaseConfig(database: database);
//   }
// }
