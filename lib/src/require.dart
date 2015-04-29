library electron.require;
import 'dart:js';

// When a class calls 'require', if there's a cached JsObject, we want to return that.
Map _requiredJS = {};


JsObject require(String module) {
  if (_requiredJS.containsKey(module))
    return _requiredJS[module];

  print('require');
  JsFunction requireJS = context['require'];
  _requiredJS[module] = requireJS.apply([module]);
  return _requiredJS[module];
}

