import HexColors

#if canImport(SwiftUI)
import SwiftUI

let black = #color(0x000)
let white = #color("#ffffff")
#endif


#if canImport(UIKit)
import UIKit

let red = #uiColor("#F00")
#endif

#if canImport(AppKit)
import AppKit

let green = #nsColor(0x00FF00)
#endif

#if canImport(CoreGraphics)
import CoreGraphics

let blue = #cgColor("#00F")
#endif

