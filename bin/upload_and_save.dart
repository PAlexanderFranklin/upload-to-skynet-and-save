import 'dart:io';
import 'dart:convert';

import 'package:skynet/skynet.dart' as skynet;
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;
// import 'package:upload_and_save/upload_and_save.dart' as upload_and_save;

void main(List<String> arguments) async {
  var logSink =
      File('upload_and_save_log.txt').openWrite(mode: FileMode.append);

  final configJson = await File('upload_and_save_config.json')
      .readAsString()
      .then((String contents) {
    return jsonDecode(contents);
  });

  final skynetRegistrySeed = configJson["skynetRegistrySeed"];
  final source = configJson["source"];
  final destination = configJson["destination"];
  final skynetAPIKey = configJson["skynetAPIKey"];
  final skynetPortal = configJson["skynetPortal"] ?? 'siasky.net';
  final databaseName = configJson["databaseName"] ?? 'MetaData.db';

  final skynetClient = skynet.SkynetClient(portal: skynetPortal);

  if (!(skynetRegistrySeed is String &&
      source is String &&
      destination is String)) {
    print("""Useable config file not found. Ensure you have a file named
      "upload_and_save_config.json" that contains a skynetRegistrySeed,
      source, and destination. Press enter to close.""");
    stdin.readLineSync();
    return null;
  }

  var sourceDirectory = Directory(source);

  try {
    Database db = sqlite3.open(databaseName);
    var sourceList = sourceDirectory.list();
    await for (final FileSystemEntity f in sourceList) {
      if (f is File) {
        print('Uploading ${f.path}');
        String fileNameWithoutExtension = path.basenameWithoutExtension(f.path);

        // Upload
        // skynetClient.upload.uploadFile(f);
        String skylink = "sia://123123";

        // Save Skylink
        db.execute("""
          UPDATE audio
          SET skylink = "$skylink"
          WHERE file_name = "$fileNameWithoutExtension";
        """);

        // Move to destination
        String newPath = '$destination/${path.basename(f.path)}';
        try {
          File(newPath).deleteSync();
        } catch (e) {
          logSink.write('error, probably fine: $e \n');
        }
        f.copySync(newPath);
        f.delete();
      }
    }
    // Upload new DB
    db.dispose();
    String skylink = "sia://123123";

    // Save Skylink To Log File
    logSink.write('Database skylink: $skylink \n');
  } catch (e) {
    print(e.toString());
  }
  // print('Hello world: ${upload_and_save.calculate()}!');
  logSink.close();
  print('press enter to close.');
  stdin.readLineSync();
}
