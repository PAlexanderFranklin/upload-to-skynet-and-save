import 'dart:io';

// import 'package:upload_and_save/upload_and_save.dart' as upload_and_save;

void main(List<String> arguments) async {
  var source = Directory('source');

  try {
    var sourceList = source.list();
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
