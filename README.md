# BackgroundFetchLogger
Gather data on how often iOS wakes apps via Background Fetch

There seems to be very little information out there describing how frequent iOS actually wakes apps which have registered for the background fetch capability. This simple app registers for backgroun fetching and logs the timestamps of various relevant events, including foregrounding/backgrounding, being woken to perform a background fetch, as well as the battery charging status.

Preliminary results on an iPhone 5 running iOS 8.1.2 indicate that fetches are performed frequently (~10-15 minutes, when configured with UIApplicationBackgroundFetchIntervalMinimum) as long as the device's battery is charging, however that background fetching is effectively disabled when the device is discharging. Note that over a longer period of continued usage of the app, iOS may begin to allow more background fetching even while discharging, but timed in a way so as to line up with when you generally launch the app.

This code is known to build on Xcode 6.1.1.