var app = require('app');
var BrowserWindow = require('browser-window');
var fs = require('fs');

var mainWindow = null;

app.on('window-all-closed', function() {
    if (process.platform != 'darwin')
        app.quit();
});

app.on('ready', function() {

    if (fs.existsSync(__dirname + '/../../menu.json')) {
        var menuJson = JSON.parse(fs.readFileSync(__dirname + '/../../menu.json'));
        var Menu = require('menu');
        menu = Menu.buildFromTemplate(menuJson);
        Menu.setApplicationMenu(menu);
    }

    mainWindow = new BrowserWindow({width: 800, height: 600});

    mainWindow.loadUrl('file://' + __dirname + '/../../index.html');

    mainWindow.toggleDevTools();

    mainWindow.on('closed', function() {
        mainWindow = null;
    });
});


function message(string) {
    mainWindow.postMessage(string, '*');
}