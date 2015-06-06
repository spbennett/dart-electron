library electron.get;
import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart';
import 'src/utils.dart';

main([List<String> args]) {
  configureWithArgs(args);
  downloadShell().then((_) {
    unzipShell();
  });
}

Future downloadShell() {
  if (new File('.cache/electron-v${version}-${os}-${arch}.zip').existsSync()) {
    return new Future(() => print('Found in cache.'));
  }
  new Directory('.cache').createSync(recursive: true);

  String url =
      'https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-${os}-${arch}.zip';

  print('Downloading electron..');
  return new HttpClient().getUrl(Uri.parse(url))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) => response.pipe(new File('.cache/electron-v${version}-${os}-${arch}.zip').openWrite()))
      .then((_) => print('..done'));
}

unzipShell() {
  String out = '.cache/electron-v${version}-${os}-${arch}';

  if (new Directory(out).existsSync()) {
    print('Electron already unzipped.  Skipping.');
    return;
  }

  // Read the Zip file from disk.
  File zip = new File('$out.zip');
  List<int> bytes = zip.readAsBytesSync();

  print('Extracting files (This takes a while)..');
  Archive archive = new ZipDecoder().decodeBytes(bytes);
  for (ArchiveFile item in archive) {
    String name = item.name;
    List<int> data = item.content;
    // We need to check if current item is a file or directory.
    if (!name.endsWith('/')) {
      // Current item is a file.
      File currentFile = new File('$out/$name');
      try {
        currentFile.createSync(recursive: true);
        currentFile.writeAsBytesSync(data);
      } catch (e) {
        print('Error: $e');
        print('Deleting intermediate data.');
        new Directory(out).deleteSync(recursive: true);
        exit(1);
      }
    } else {
      // Current item a directory.
      Directory currentDirectory = new Directory('$out/$name');
      try {
        currentDirectory.createSync(recursive: true);
      } catch (e) {
        print('Error: $e');
        print('Deleting intermediate data.');
        new Directory(out).deleteSync(recursive: true);
        exit(1);
      }
    }
  }

  if (os == LINUX || os == OSX){
    print('Updating file permissions.');
    Process.runSync('chmod', ['777', '.cache/electron-v${version}-${os}-${arch}/electron']);
  }
}
