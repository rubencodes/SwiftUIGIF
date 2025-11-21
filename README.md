# SwiftUIGIF

SwiftUI library for rendering looping GIFs from data, local assets, or remote URLs, with no webviews or external dependencies.

![Preview](https://github.com/rubencodes/SwiftUIGIF/blob/main/Examples/example.gif?raw=true)

## Installation

This library can be installed through Swift Package Manager.

To add this package to your project, go to `File` -> `Swift Package Manager` -> `Add Package Dependency...` in Xcode's menu, and paste the Github page URL into the search bar.

You can also import `SwiftUIGIF` by adding it as a dependecy on your Package.swift file:

```
dependencies: [
    .package(url: "https://github.com/rubencodes/SwiftUIGIF.git", from: "1.0.0")
],
targets: [
    .target(
      name: "MyProject",
      dependencies: [
        "SwiftUIGIF"
      ]
    )
]
```

## Example Usage

For a simple repeating GIF animation, drag and drop the GIF file into your bundle. Then, you can render it using the `GIFImage` view like so:

```swift
import SwiftUIGIF

struct ExampleView: View {
  var body: some View {
    VStack {
      // Loads a GIF asset from main bundle.
      GIFImage(name: "example")
        .frame(height: 300)

      // Loads a GIF asset from module bundle.
      GIFImage(name: "example", bundle: .module)
        .frame(height: 300)
    }
  }
}
```

By default animations repeat the number of times specified by the GIF file. To override the animation loop count, include the optional `loopCount` parameter. You may also add an optional `onComplete` callback to execute an action after all loops complete:

```swift
import SwiftUIGIF

struct ExampleView: View {

  @State private var isDone: Bool = false

  var body: some View {
    VStack {
      // Repeats the example animation twice.
      if isDone {
        Text("Animation Completed!")
      } else {
        GIFImage(name: "example", loopCount: 2) {
          isDone = true
        }
        .frame(height: 300)
      }
    }
  }
}
```

![Preview](https://github.com/rubencodes/SwiftUIGIF/blob/main/Examples/example-repetitions.gif?raw=true)

To load an image from an asynchronous URL, use the `AsyncGIFImage` view:

```swift
import SwiftUIGIF

struct ExampleView: View {

  private let remoteUrl = "https://github.com/rubencodes/SwiftUIGIF/blob/main/Sources/Resources/example.gif"

  var body: some View {
    VStack {
      // Loads a GIF asset from a remote URL.
      AsyncGIFImage(url: URL(string: remoteUrl))
        .frame(height: 300)
    }
  }
}
```

The `AsyncGIFImage` view supports the same parameters as `GIFImage`, and adds an optional loading state placeholder parameter:

```swift
import SwiftUIGIF

struct ExampleView: View {

  private let remoteUrl = "https://github.com/rubencodes/SwiftUIGIF/blob/main/Sources/Resources/example.gif"

  var body: some View {
    VStack {
      // Renders "Loading..." text while the asset is loading.
      AsyncGIFImage(url: URL(string: remoteUrl)) {
        Text("Loading...")
      }
      .frame(height: 300)
    }
  }
}
```

![Preview](https://github.com/rubencodes/SwiftUIGIF/blob/main/Examples/example-async.gif?raw=true)

## Changelog

- 1.0.0 - Initial release.
