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
  if (new Directory('.cache/electron-v${version}-${os}-${arch}').existsSync()) {
    return;
  }

  print('Extracting files (This takes a while)..');
  File archive = new File('.cache/electron-v${version}-${os}-${arch}.zip');

  if (os == OSX) {
    // The archive library fails to resolve sym links on OSX.  Just use the native
    // unzip tool.
    ProcessResult results = Process.runSync(
        'unzip',
        ['${archive.path}', '-d', '.cache/electron-v${version}-${os}-${arch}']
    );
    print(results.stderr);
  } else {
    // Use the archive library to extract on non-OSX environments.
    List<int> bytes = archive.readAsBytesSync();
    Archive runnerArchive;

    runnerArchive = new ZipDecoder().decodeBytes(bytes);
    for (ArchiveFile item in runnerArchive) {
      String name = item.name;
      List<int> data = item.content;
      if (name.endsWith('/')) {
        new Directory('.cache/electron-v${version}-${os}-${arch}/$name')
          ..createSync(recursive: true);
      } else {
        new File('.cache/electron-v${version}-${os}-${arch}/$name')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }
  }

  if (os == LINUX || os == OSX){
    print('Updating file permissions.');
    Process.runSync('chmod', ['777', '.cache/electron-v${version}-${os}-${arch}/electron']);
  }
}