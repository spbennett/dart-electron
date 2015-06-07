import 'dart:io';
import '../../packages/args/args.dart';

String version = '0.27.2';
String os;
String arch;

const String WIN = 'win32';
const String LINUX = 'linux';
const String OSX = 'darwin';

configureWithArgs(List args) {
  final argParser = new ArgParser()
    ..addOption('os', abbr: 'o', allowed: ['win', 'linux', 'osx'])
    ..addOption('arch',abbr: 'a', allowed: ['32', '64'])
    ..addOption('version', abbr:'v');
  
  // Set the os
  var results = argParser.parse(args);
  if (results['os'] == 'win')
    os = WIN;
  else if (results['os'] == 'linux')
    os = LINUX;
  else if (results['os'] == 'osx')
    os = OSX;
  else
    detectOS();
  
  // Set the arch
  if (os == LINUX) {
    if (results['arch'] == '64')
      arch = 'x64';
    else if (results['arch'] == '32')
      arch = 'ia32';
    else{
      print('Error: 32 or 64bit linux?');
      print("Try with '-a 32' or '-a 64'");
      exit(1);
    }
  }
  else if (os == WIN)
    arch = 'ia32';
  else if (os == OSX)
    arch = 'x64';
}



detectOS() {
  if (Platform.isLinux)
    os = LINUX;
  else if (Platform.isMacOS)
    os = OSX;
  else if (Platform.isWindows)
    os = WIN;
}






/// Copy a [Directory]'s contents to a [String] path.
copyDirectory(Directory from, String to) {
  for (File file in from.listSync(recursive: true).where((e) => e is File)) {
    
    List data = file.readAsBytesSync();
    
    new File(file.path.replaceAll(from.path, to))
      ..createSync(recursive: true)
      ..writeAsBytes(data);
  }
}