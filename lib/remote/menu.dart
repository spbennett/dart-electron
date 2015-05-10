library electron.menu;

import 'dart:js';
import 'dart:html';
import 'package:electron/remote.dart';

class Menu {
  JsObject JsMenu;
  Remote _remote = new Remote();

  Menu() {
    JsObject menu = _remote.require('menu');
    JsMenu = new JsObject(menu);
  }

  append(MenuItem menuItem) {
    JsMenu.callMethod('append', [menuItem.JsMenuItem]);
  }


  popup({int x, int y}) {
    JsMenu.callMethod('popup', [_remote.getCurrentWindow()]);
  }
}



class MenuItem {
  JsObject JsMenuItem;
  Remote _remote = new Remote();

  String type;
  String label;
  String subLabel;
  String accelerator;

  bool visible;
  bool checked;
  Menu subMenu;

  MenuItem(Map options) {
    JsObject menuItem = _remote.require('menu-item');

    // replace the dart subMenu with a JS subMenu
    if (options['submenu'] != null) {
      JsObject sub = options['submenu'].JsMenu;
      options['submenu'] = sub;
    }

    JsMenuItem = new JsObject(menuItem,
    [new JsObject.jsify(options)]);
    print('created menuItem: $options');
  }
}