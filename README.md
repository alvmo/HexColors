# HexColors

HexColors is a Swift package that provides convenient macros for converting hex colors to the different color types on Apple platforms that are validated at compile time.

```swift
let red = #color("#ff0000") //Macro expands to SwiftUI.Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
```

## Installation

### Xcode 
In Xcode, go to `File > Add Package Dependency` and paste the repository URL:

```
https://github.com/alvmo/HexColors.git
```

### Swift Package Manager

You can use the Swift Package Manager to install HexColors by adding it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/alvmo/HexColors.git", from: "1.0.0")
]
```

And then add the dependency to your targets.

```swift
.target(
        name: <TARGET_NAME>,
        dependencies: [
            .product(name: "HexColors", package: "HexColors"),
            //...
        ]
)
```

## Usage

### Importing the Package

In your Swift file, import the HexColors package:

```swift
import HexColors
```

### Using the macros

To use HexColors, you can use the `#color` macros with either a static hex color string or a hexadecimal integer literal:

```swift
let red = #color("#ff0000") // Macro expands to SwiftUI.Color(red: 1.0, green: 0.0, blue: 0, opacity: 1.0)

let green = #color(0xff00FF55) // Macro expands to SwiftUI.Color(red: 1.0, green: 0.0, blue: 1.000, opacity: 0.3333 )

let blue = #color(0xfff) // Macro expands to SwiftUI.Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0 )
```

There are also macros for non-SwiftUI colors types:

```swift
let uiColor = #uiColor("#ff0055") // Equivalent to UIColor(red: 1.0, green: 0.0, blue: 0.333, alpha: 1.0)
let nsColor = #nsColor(0xff0055) // Equivalent to NSColor(red: 1.0, green: 0.0, blue: 0.333, alpha: 1.0)
let cgColor = #cgColor("#ff0055") // Equivalent to CGColor(red: 1.0, green: 0.0, blue: 0.333, alpha: 1.0)
```
