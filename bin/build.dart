library electron.build;
import 'dart:io';
import 'dart:convert';
import 'src/utils.dart';

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
  
  Directory downloadedElectronDir = new Directory('.cache/electron-v${version}-${os}-${arch}');
  if (downloadedElectronDir.existsSync() == false) {
    print("electron has not been downloaded");
    print("Please run 'pub run electron:get (options)'");
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
  Directory electronDir = new Directory('.cache/electron-v${version}-${os}-${arch}');
  Directory leftovers = new Directory('dist/${os}-${arch}');
  if (leftovers.existsSync()) leftovers.deleteSync(recursive: true);
  copyDirectory(electronDir, 'dist/${os}-${arch}');
  
  print('Renaming executable');
  File electronBin;
  if (os == WIN)
    electronBin = new File('dist/${os}-${arch}/electron.exe');
  else
    electronBin = new File('dist/${os}-${arch}/electron');
  electronBin.rename(electronBin.path.replaceAll('electron', package['name']));

  if (os == LINUX || os == OSX){
    print('Updating file permissions.');
    Process.runSync('chmod', ['777', 'dist/${os}-${arch}/${package['name']}']);
  }
  
  // Moving built App.
  Directory app = new Directory('build/web');
  
  
  if (os == WIN || os == LINUX)
    copyDirectory(app, 'dist/${os}-${arch}/resources/app');
  else if (os == OSX)
    copyDirectory(app, 'dist/${os}-${arch}/Electron.app/Contents/Resources/app');
}