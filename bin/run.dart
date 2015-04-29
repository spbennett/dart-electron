library electron.run;
import 'dart:io';
import 'src/utils.dart';

main([List<String> args]) {
  configureWithArgs(args);
  // override the configured args. We want to run the correct version for our os.
  detectOS();
  
  
  
  Directory downloadedElectronDir = new Directory('.cache/electron-v${version}-${os}-${arch}');
  if (downloadedElectronDir.existsSync() == false) {
    print("electron has not been downloaded");
    print("Please run 'pub run electron:get'");
    exit(1);
  }
  
  File electronBin;
    if (os == WIN)
      Process.run('.cache/electron-v${version}-${os}-${arch}/electron.exe',['build/web/']);
    else if (os == LINUX)
      Process.run('.cache/electron-v${version}-${os}-${arch}/electron',['build/web/']);
    else if (os == LINUX)
      Process.run('.cache/electron-v${version}-${os}-${arch}/electron',['build/web/']);
}
