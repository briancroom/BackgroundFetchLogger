import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!

    var logger: Logger!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateFromLog()
        logger.addObserver { [unowned self] event in
            self.updateFromLog()
        }
    }

    func updateFromLog() {
        let log = logger.events

        textView.text = stringFromLogEvents(log)
        textView.scrollRangeToVisible(NSMakeRange(countElements(textView.text), 0))
        
        infoLabel.text = stringFromLogStats(logStatsFromLog(log))
    }

    func stringFromLogEvents(events: Logger.Log) -> String {
        return (events.map { $0.description } as NSArray).componentsJoinedByString("\n")
    }

    func stringFromLogStats(stats: LogStats) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Short

        let avg: String = (stats.averageBackgroundFetchInterval != nil) ? formatter.stringFromTimeInterval(stats.averageBackgroundFetchInterval!)! : "N/A"
        let min: String = (stats.minBackgroundFetchInterval != nil) ? formatter.stringFromTimeInterval(stats.minBackgroundFetchInterval!)! : "N/A"
        let max: String = (stats.maxBackgroundFetchInterval != nil) ? formatter.stringFromTimeInterval(stats.maxBackgroundFetchInterval!)! : "N/A"

        return ("Background Fetches: \(stats.backgroundFetchCount)\n" +
            "Average interval: \(avg)\n" +
            "Minimum interval: \(min)\n" +
            "Maximum interval: \(max)")
    }
}
