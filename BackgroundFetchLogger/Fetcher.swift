import UIKit

protocol Fetcher {
    func fetch(completionHandler: (UIBackgroundFetchResult) -> Void)
}

class DownloadFetcher : Fetcher {
    struct LogEvents {
        static let FetchSucceeded = "Fetch Succeeded"
        static let FetchFailed = "Fetch Failed"
    }

    let URL: NSURL
    let logger: Logger

    init(URL: NSURL, logger: Logger) {
        self.URL = URL
        self.logger = logger
    }

    func fetch(completionHandler: (UIBackgroundFetchResult) -> Void) {
        let request = NSURLRequest(URL: URL, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 60)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (error != nil) {
                    self.logger.logEvent(LogEvents.FetchFailed)
                    completionHandler(.Failed)
                }
                else {
                    self.logger.logEvent(LogEvents.FetchSucceeded)
                    completionHandler(.NewData)
                }
            })
        }).resume()
    }
}
