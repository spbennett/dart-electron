import 'dart:io';

main() {
  print('Clearing the electron cache..');
  Directory cache = new Directory('.cache');
  if (cache.existsSync()) cache.deleteSync(recursive: true);
  print('..Done');
}