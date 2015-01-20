library atomshell.run;
import 'dart:io';
import 'package:atomshell/src/utils.dart';

main([List<String> args]) {
  configureWithArgs(args);
  // override the configured args. We want to run the correct version for our os.
  detectOS();
  
  
  
  Directory downloadedAtomDir = new Directory('.cache/atom-shell-v${version}-${os}-${arch}');
  if (downloadedAtomDir.existsSync() == false) {
    print("Atom-shell has not been downloaded");
    print("Please run 'pub run atomshell:get'");
    exit(1);
  }
  
  File atomBin;
    if (os == WIN)
      Process.run('.cache/atom-shell-v${version}-${os}-${arch}/atom.exe',['build/web/']);
    else if (os == LINUX)
      Process.run('.cache/atom-shell-v${version}-${os}-${arch}/atom',['build/web/']);
    else if (os == LINUX)
      Process.run('.cache/atom-shell-v${version}-${os}-${arch}/atom',['build/web/']);
}
