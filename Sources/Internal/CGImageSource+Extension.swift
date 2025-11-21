//
//  CGImageSource+Extension.swift
//  SwiftUIGIF
//
//  Created by Ruben Martinez Jr. on 11/21/25.
//

import SwiftUI

extension CGImageSource {
    /// Returns the number of times the GIF should loop (or `nil` if infinite)
    var loopCount: Int? {
        let defaultLoopCount = 1
        guard let gifProperties = readGIFProperties() else {
            return defaultLoopCount
        }
        let loopWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFLoopCount).toOpaque()),
                                        to: AnyObject.self)
        guard let loopCount = loopWrapper as? Int else {
            return defaultLoopCount
        }
        return loopCount == 0 ? nil : loopCount
    }

    /// Returns the number of frames in the GIF.
    var frameCount: Int {
        CGImageSourceGetCount(self)
    }

    /// Initializes a CGImageSource from GIF data.
    static func create(data: Data) -> CGImageSource? {
        CGImageSourceCreateWithData(data as CFData, nil)
    }

    /// Returns the delay for the frame at the given index.
    func delayForFrame(at index: Int) -> Double {
        let defaultDelay = 1.0

        guard let gifProperties = readGIFProperties(at: index) else { return defaultDelay }
        var delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                              Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                                         to: AnyObject.self)
        if delayWrapper.doubleValue == 0 {
            delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                              Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                         to: AnyObject.self)
        }

        if let delay = delayWrapper as? Double,
           delay > 0
        {
            return delay
        } else {
            return defaultDelay
        }
    }

    /// Reads the GIF image properties from the source.
    func readGIFProperties(at index: Int? = nil) -> CFDictionary? {
        let cfProperties = if let index {
            CGImageSourceCopyPropertiesAtIndex(self, index, nil)
        } else {
            CGImageSourceCopyProperties(self, nil)
        }
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }

        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        guard CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) else {
            return nil
        }

        return unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
    }
}
