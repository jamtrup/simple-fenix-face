import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class epixFaceApp extends Application.AppBase {

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
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new epixFaceView() ] as Array<Views or InputDelegates>;
    }

}
