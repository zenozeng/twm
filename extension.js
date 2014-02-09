// File Overview
//
// Define a set of helper functions (log, cat, exec)
// Then load Coffee Compiler, and exec wm/main.coffee

const Main = imports.ui.main;
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;
const ExtensionUtils = imports.misc.extensionUtils;
const Extension = ExtensionUtils.getCurrentExtension();
const helper = Extension.imports.helper;

// global variable to store modules
var modules = {};

// global variable for function call from outside
// exposed to global
global.twm = {
    functions: {},
    modules: {
        helper: helper
    }
};

function init() {
    helper.exec('lib/coffee-script.min.js', function() {
        helper.exec('main.coffee');
    });
}

function enable() {}

function disable() {}
