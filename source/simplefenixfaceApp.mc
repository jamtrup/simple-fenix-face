using Toybox.Application;
using Toybox.Lang;

class simplefenixfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Lang.Dictionary?) {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Lang.Dictionary?) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new simplefenixfaceView() ];
    }

}