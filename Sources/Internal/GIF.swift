//
//  GIF.swift
//  SwiftUIGIF
//
//  Created by Ruben Martinez Jr. on 11/20/25.
//

import SwiftUI

/// Represents a GIF animation.
struct GIF {
    // MARK: - Nested Types

    /// Represents a single frame in a GIF animation.
    struct AnimationFrame {
        /// Image for the frame.
        let image: () -> UIImage

        /// Delay in seconds.
        let delay: Double
    }

    // MARK: - Internal Properties

    /// Number of times to loop the GIF animation. `nil` for infinite loop.
    let loopCount: Int?

    /// Frames of the GIF animation.
    let frames: [AnimationFrame]

    // MARK: - Lifecycle

    /// Initializes a GIF by reading image data.
    /// - Parameters:
    ///   - data: The GIF image data.
    init?(data: Data) {
        guard let source = CGImageSource.create(data: data) else {
            return nil
        }

        loopCount = source.loopCount
        frames = .init(source: source)
    }

    /// Initializes a GIF by reading image data from the provided file name in bundle.
    /// - Parameters:
    ///   - name: The name of the GIF file (without extension).
    ///   - bundle: The bundle where the GIF file is located.
    init?(name: String, bundle: Bundle) {
        guard let url = bundle.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let frames = Self(data: data)
        else {
            return nil
        }

        self = frames
    }
}
