import Foundation

struct LogEvent : Printable {
    let eventName : String
    let timestamp : NSDate

    static func fromDict(dict: NSDictionary) -> LogEvent {
        return LogEvent(eventName: dict["eventName"] as? String ?? "", timestamp: NSDate(timeIntervalSince1970: (dict["timestamp"] as? NSNumber)?.doubleValue ?? 0))
    }

    func toDict() -> NSDictionary {
        return ["eventName": eventName, "timestamp": timestamp.timeIntervalSince1970]
    }

    private static var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()

    var description: String {
        get {
            return "\(LogEvent.dateFormatter.stringFromDate(timestamp)): \(eventName)"
        }
    }
}

class Logger {
    typealias Log = [LogEvent]
    typealias Observer = LogEvent -> ()

    private let logURL: NSURL
    private var observers: [Observer] = []
    var events: Log = []

    init(logURL: NSURL) {
        self.logURL = logURL
        events = loadEvents()
    }

    func logEvent(eventName: String) {
        let event = LogEvent(eventName: eventName, timestamp: NSDate())
        events.append(event)
        saveEvents()

        notifyObserversOfEvent(event)
    }

    func addObserver(observer: Observer) {
        observers.append(observer)
    }

    private func timestampString() -> String {
        let formatter = NSDateFormatter()
        return formatter.stringFromDate(NSDate())
    }

    private func saveEvents() {
        (events.map { $0.toDict() } as NSArray).writeToURL(logURL, atomically: true)
    }

    private func loadEvents() -> Log {
        let array = NSArray(contentsOfURL: logURL) ?? []
        return (array as [NSDictionary]).map { LogEvent.fromDict($0) }
    }

    private func notifyObserversOfEvent(event: LogEvent) {
        for observer in observers {
            observer(event)
        }
    }
}
