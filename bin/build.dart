library atomshell.build;
import 'dart:io';
import 'dart:convert';
import 'package:atomshell/src/utils.dart';

Map package;

main([List<String> args]) {  
  configureWithArgs(args);

  // If there is no package file, then abort.
  File packageFile = new File('web/package.json');
  if (packageFile.existsSync() == false) {
    print("Missing 'package.json' in 'web'.");
    print("Aborted.");
    exit(1);
  }
  
  Directory downloadedAtomDir = new Directory('.cache/atom-shell-v${version}-${os}-${arch}');
  if (downloadedAtomDir.existsSync() == false) {
    print("Atom-shell has not been downloaded");
    print("Please run 'pub run atomshell:get (options)'");
    exit(1);
  }
  
  
  
  package = JSON.decode(packageFile.readAsStringSync());  
  
  packageApp();  
}


packageApp() {
  Directory web = new Directory('build/web');
  if (web.existsSync() == false) {
    print("App has not been built, please run 'pub build'.");
    return;
  }
  
  //Clean out old files.
  Directory atomshellDir = new Directory('.cache/atom-shell-v${version}-${os}-${arch}');
  Directory leftovers = new Directory('dist/${os}-${arch}');
  if (leftovers.existsSync()) leftovers.deleteSync(recursive: true);
  copyDirectory(atomshellDir, 'dist/${os}-${arch}');
  
  print('Renaming executable');
  File atomBin;
  if (os == WIN)
    atomBin = new File('dist/${os}-${arch}/atom.exe');
  else
    atomBin = new File('dist/${os}-${arch}/atom');
  atomBin.rename(atomBin.path.replaceAll('atom', package['name']));

  if (os == LINUX || os == OSX){
    print('Updating file permissions.');
    Process.runSync('chmod', ['777', 'dist/${os}-${arch}/${package['name']}']);
  }
  
  // Moving built App.
  Directory app = new Directory('build/web');
  
  
  if (os == WIN || os == LINUX)
    copyDirectory(app, 'dist/${os}-${arch}/resources/app');
  else if (os == OSX)
    copyDirectory(app, 'dist/${os}-${arch}/Atom.app/Contents/Resources/app');
}