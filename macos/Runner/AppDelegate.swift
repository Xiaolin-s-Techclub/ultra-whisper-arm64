import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let keystrokeChannel = FlutterMethodChannel(name: "com.glassywhisper.keystroke",
                                              binaryMessenger: controller.engine.binaryMessenger)

    keystrokeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      KeystrokeHandler.handleMethodCall(call: call, result: result)
    })

    super.applicationDidFinishLaunching(aNotification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
