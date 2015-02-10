import UIKit

class BatteryStateObserver {
     struct LogEvents {
        static let BatteryUnplugged = "Battery Unplugged"
        static let BatteryCharging = "Battery Charging"
        static let BatteryFull = "Battery Full"

        static func eventFromBatteryState(state: UIDeviceBatteryState) -> String? {
            switch state {
            case .Unplugged: return BatteryUnplugged
            case .Charging: return BatteryCharging
            case .Full: return BatteryFull
            default: return nil
            }
        }
    }

    let logger: Logger
    var notificationToken: AnyObject?

    init(logger: Logger) {
        self.logger = logger
    }

    deinit {
        if let notificationToken: AnyObject = notificationToken {
            NSNotificationCenter.defaultCenter().removeObserver(notificationToken)
        }
    }

    func beginObserving() {
        notificationToken = NSNotificationCenter.defaultCenter().addObserverForName(UIDeviceBatteryStateDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification -> Void in
            if let event = LogEvents.eventFromBatteryState(UIDevice.currentDevice().batteryState) {
                self.logger.logEvent(event)
            }
        }

        UIDevice.currentDevice().batteryMonitoringEnabled = true
    }
}