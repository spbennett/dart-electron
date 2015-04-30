library electron.run;
import 'dart:io';
import 'src/utils.dart';

main([List<String> args]) async {
  configureWithArgs(args);
  // override the configured args. We want to run the correct version for our os.
  detectOS();

  print('running `pub build`...');
  await Process.run('pub', ['build']);
  print('done.');

  Directory downloadedElectronDir = new Directory('.cache/electron-v${version}-${os}-${arch}');
  if (downloadedElectronDir.existsSync() == false) {
    print("electron has not been downloaded");
    print("Please run 'pub run electron:get'");
    exit(1);
  }

  print('electron v${version}-${os}-${arch}');
  print('Close electron window to refresh build. \n Press Ctrl+C to exit.');
  File electronBin;
    if (os == WIN) {
      await Process.runSync('.cache/electron-v${version}-${os}-${arch}/electron.exe', ['build/web/']);
      main(args);
    }
    else if (os == LINUX) {
      await Process.runSync('.cache/electron-v${version}-${os}-${arch}/electron', ['build/web/']);
      main(args);
    }
    else if (os == LINUX) {
      await Process.runSync('.cache/electron-v${version}-${os}-${arch}/electron', ['build/web/']);
      main(args);
    }
}
