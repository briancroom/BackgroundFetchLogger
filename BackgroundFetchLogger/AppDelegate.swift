import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    struct LogEvents {
        static let DidFinishLaunching = "Finished Launching"
        static let DidEnterBackground = "Entered Background"
        static let WillEnterForeground = "Entering Foreground"
        static let WillTerminate = "Terminating"
        static let BackgroundFetch = "Background Fetch"
    }

    var window: UIWindow?

    // Apple QuickTime sample file. ~75kb
    let sampleURL = NSURL(string: "http://a1408.g.akamai.net/5/1408/1388/2005110406/1a1a1ad948be278cff2d96046ad90768d848b41947aa1986/sample_sorenson.mov.zip")!

    lazy var logger: Logger = {
        let baseURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
        return Logger(logURL: baseURL.URLByAppendingPathComponent("events.log"))
    }()

    lazy var fetcher: Fetcher = { return DownloadFetcher(URL: self.sampleURL, logger: self.logger) }()

    lazy var batteryStateObserver: BatteryStateObserver = { return BatteryStateObserver(logger: self.logger) }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);

        (window?.rootViewController as? ViewController)?.logger = logger

        logger.logEvent(LogEvents.DidFinishLaunching)
        batteryStateObserver.beginObserving()

        return true
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        logger.logEvent(LogEvents.BackgroundFetch)
        fetcher.fetch(completionHandler)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        logger.logEvent(LogEvents.DidEnterBackground)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        logger.logEvent(LogEvents.WillEnterForeground)
    }

    func applicationWillTerminate(application: UIApplication) {
        logger.logEvent(LogEvents.WillTerminate)
    }
}
