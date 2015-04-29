library electron.menu;

import 'dart:js';
import 'dart:html';
import 'package:electron/remote.dart';

// TODO , This is a WIP understanding of how dart can work with the menu-item api

testMenu() {

  context['jsTrigger_'] = new JsFunction.withThis(() => print('test'));

  Remote remote = new Remote();

  JsObject Menu = remote.require('menu');

  JsObject MenuItem = remote.require('menu-item');

  var menu = new JsObject(Menu);

  print('new JsObject Menu');

  menu.callMethod('append',
    [new JsObject
      (
          MenuItem,
        [
          new JsObject.jsify({
            'label': 'MenuItem 1',
            'click': context['jsTrigger_'].apply()
          })
        ]
      )
    ]
  );


  window.addEventListener('contextmenu', (e) {
    e.preventDefault();
    menu.callMethod('popup',[remote.getCurrentWindow()]);
  });

}
