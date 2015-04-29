library electron.remote;

import 'dart:js';
import 'src/require.dart' as Require;

class Remote {
  JsObject _remote;
  Map _remoteRequiredJS = {};

  Remote() {
    _remote = Require.require('remote');
  }

  JsObject require(String module) {
    // if it's cached just return the cached JsObject
    if (_remoteRequiredJS.containsKey(module))
      return _remoteRequiredJS[module];

    print('remote.require');

    _remoteRequiredJS[module] = _remote.callMethod('require', [module]);

    return _remoteRequiredJS[module];
  }

  JsObject getCurrentWindow() {
    print('getCurrentWindow');
    return _remote.callMethod('getCurrentWindow');
  }

  String getGlobal(String name) {
    return _remote.callMethod('getGlobal', [name]);
  }

  // TODO
  get process => {};
}