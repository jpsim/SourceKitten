import Foundation

/// Deprecated extension.
@available(*, deprecated, message: "This is deprecated but should still be documented.")
public extension NSString {}

/// 🚲 A two-wheeled, human-powered mode of transportation.
public class Bicycle {
/**
Frame and construction style.

- Road: For streets or trails.
- Touring: For long journeys.
- Cruiser: For casual trips around town.
- Hybrid: For general-purpose transportation.
*/
public enum Style {
case Road, Touring, Cruiser, Hybrid
}

/**
Mechanism for converting pedal power into motion.

- Fixed: A single, fixed gear.
- Freewheel: A variable-speed, disengageable gear.
*/
public enum Gearing {
case Fixed
case Freewheel(speeds: Int)
}

/**
Hardware used for steering.

- Riser: A casual handlebar.
- Café: An upright handlebar.
- Drop: A classic handlebar.
- Bullhorn: A powerful handlebar.
*/
enum Handlebar {
case Riser, Café, Drop, Bullhorn
}

/// The style of the bicycle.
let style: Style

/// The gearing of the bicycle.
let gearing: Gearing

/// The handlebar of the bicycle.
let handlebar: Handlebar

/// The size of the frame, in centimeters.
let frameSize: Int

/// The number of trips travelled by the bicycle.
private(set) var numberOfTrips: Int

/// The total distance travelled by the bicycle, in meters.
private(set) var distanceTravelled: Double

/**
Initializes a new bicycle with the provided parts and specifications.

- parameter style: The style of the bicycle
- parameter gearing: The gearing of the bicycle
- parameter handlebar: The handlebar of the bicycle
- parameter centimeters: The frame size of the bicycle, in centimeters

- returns: A beautiful, brand-new, custom built just for you.
*/
init(style: Style, gearing: Gearing, handlebar: Handlebar, frameSize centimeters: Int) {
self.style = style
self.gearing = gearing
self.handlebar = handlebar
self.frameSize = centimeters

numberOfTrips = 0
distanceTravelled = 0
}

/**
Take a bike out for a spin.

- parameter meters: The distance to travel in meters.
*/
func travel(distance meters: Double) {
if meters > 0.0 {
distanceTravelled += meters
numberOfTrips += 1
}
}
}
