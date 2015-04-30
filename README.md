# dart-electron

To use this package, add it to your pubspec.yaml.

   electron:
      git:
        ref: master
        url: https://github.com/ppvk/dart-electron.git

# API

Eventually, I expect there will be some libs here to interface with electron's
JavaScript APIs. For now, however, all we have are these packaging commands.


# Commands

From the command line 'cd' into your project.
There are four commands you can run to build and test with electron.

### Options
All the commands that take options, take the same options.
They are:

    ... -v (--version in 0.0.0 format) -o (--os linux, osx, or win) -a (--arch 32 or 64,)

'arch' is only relevant if you are using a linux system. Electron only distributes
32bit binaries for windows, and 64bit binaries for OSX.

If you do not specify these, they will assume that you want the version for your
current os, and v0.20.6. Linux users, for now, MUST specify which '-a' they are using

### :get

    pub run electron:get (options)
This command tries to download a precompiled version of electron into a .cache
folder. It would be a good idea to add this to your '.gitignore' file. You can
specify what version you want to download by using the previously defined arguments.

If you don't specify any options, the command will detect your OS and
download an appropriate version.

### :run

    pub run electron:run (options)
This command will do a 'pub build' and then try to run whatever is in your /build folder with a previously
downloaded electron binary. You can use this to test your app on your system
before running the ':build' command. If you try to specify a
machine in the options different from what you actually have, it'll just ignore you.
The only meaningful options to set here are '-v' and '-a'.

Additionally, this command will automatically re-run itself when you close the electron window, 
allowing for a slightly faster edit-build-test cycle. Turn this off by pressing Ctrl-C in the terminal window.

### :build

    pub run electron:build (options)
Copies a cached version of electron to a /dist folder and injects your built app
into it. Be sure to run 'pub build' before this command. You can specify the particular
operating system you wish to build for.

### :clearcache

    pub run electron:clearcache
This command does not take any arguments. It simply deletes any previously downloaded
and cached electron distributions.

## To Note
This package will rename the electron binary to the name of your project by
default (incidentally disabling node-modules), and it does not change icons.
