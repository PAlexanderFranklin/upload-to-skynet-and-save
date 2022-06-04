import 'dart:io';
import 'dart:convert';

// import 'package:upload_and_save/upload_and_save.dart' as upload_and_save;

void main(List<String> arguments) async {
  final configJson = await File('upload_and_save_config.json')
      .readAsString()
      .then((String contents) {
    return jsonDecode(contents);
  });

  final skynetRegistrySeed = configJson["skynetRegistrySeed"];
  final source = configJson["source"];
  final destination = configJson["destination"];

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
    var sourceList = sourceDirectory.list();
    await for (final FileSystemEntity f in sourceList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
  print('press enter to close.');
  stdin.readLineSync();
  // print('Hello world: ${upload_and_save.calculate()}!');
}
