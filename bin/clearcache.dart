import 'dart:io';

main() {
  print('Clearing the atomshell cache..');
  Directory cache = new Directory('.cache');
  if (cache.existsSync()) cache.deleteSync(recursive: true);
  print('..Done');
}