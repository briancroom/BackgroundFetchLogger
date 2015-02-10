import Foundation

struct LogStats {
    let backgroundFetchCount: NSInteger
    let averageBackgroundFetchInterval: NSTimeInterval?
    let minBackgroundFetchInterval: NSTimeInterval?
    let maxBackgroundFetchInterval: NSTimeInterval?
}

func logStatsFromLog(log: Logger.Log) -> LogStats {
    let backgroundFetchTimestamps = log.filter { $0.eventName == AppDelegate.LogEvents.BackgroundFetch }.map { $0.timestamp.timeIntervalSinceReferenceDate }
    let intervals = deltas(backgroundFetchTimestamps)

    let count = backgroundFetchTimestamps.count
    return LogStats(
        backgroundFetchCount: backgroundFetchTimestamps.count,
        averageBackgroundFetchInterval: intervals.avg(),
        minBackgroundFetchInterval: intervals.min(),
        maxBackgroundFetchInterval: intervals.max())
}
