//
//  [GIF.AnimationFrame]+Extension.swift
//  SwiftUIGIF
//
//  Created by Ruben Martinez Jr. on 11/20/25.
//

import SwiftUI

extension [GIF.AnimationFrame] {
    /// Total duration of all frames.
    var duration: Double {
        map(\.delay).reduce(0, +)
    }

    /// Reads GIF image frames from the provided source.
    init(source: CGImageSource) {
        var frames = Self()
        for frameIndex in 0 ..< source.frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, frameIndex, nil) {
                let image = UIImage(cgImage: cgImage)
                let delay = source.delayForFrame(at: frameIndex)

                frames.append(.init(image: image, delay: delay))
            }
        }

        self = frames
    }

    /// Returns the frame at a specific time.
    func frame(at time: Double, loopCount: Int? = nil) -> Self.Element? {
        // If time exceeds duration, check if we need to loop.
        guard time <= duration else {
            // Loop around if loopCount is nil or within allowed loopCount.
            guard loopCount == nil || time <= duration * Double(loopCount ?? 0) else {
                return nil
            }

            return frame(at: time.truncatingRemainder(dividingBy: duration),
                         loopCount: loopCount)
        }

        // Find the frame corresponding to the elapsed time.
        return enumerated().first { index, frame in
            let elapsedTime = Array(self[0 ..< index]).duration
            return elapsedTime <= time && time <= elapsedTime + frame.delay
        }?.element
    }
}
