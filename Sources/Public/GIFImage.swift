//
//  GIFImage.swift
//  SwiftUIGIF
//
//  Created by Ruben Martinez Jr. on 11/20/25.
//  Copyright © 2025 SwiftUIGIF. All rights reserved.
//

import SwiftUI

/// Renders an animated GIF image from data or reads it from the file system.
public struct GIFImage: View {
    // MARK: - Private Types

    private struct FileInfo: Equatable {
        let name: String
        let bundle: Bundle
    }

    // MARK: - Private Properties

    @State private var startTime: Date = .init()
    @State private var gif: GIF?
    private var data: Data?
    private var fileInfo: FileInfo?
    private let loopCount: Int?
    private let onComplete: (() -> Void)?

    // MARK: - Lifecycle

    /// Initialize `GIFImage` using data.
    /// - Parameters:
    ///   - data: The GIF image data.
    ///   - loopCount: Override the number of times to play the animation loop. Default: GIF file loop count.
    ///   - onComplete: Closure called when the animation fully completes.
    public init(data: Data,
                loopCount: Int? = nil,
                onComplete: (() -> Void)? = nil)
    {
        self.data = data
        self.loopCount = loopCount
        self.onComplete = onComplete
    }

    /// Initialize `GIFImage` with file name in bundle.
    /// - Parameters:
    ///   - name: The name of the GIF file (without extension).
    ///   - bundle: The bundle where the GIF file is located. Defaults to `.main`.
    ///   - loopCount: Override the number of times to play the animation loop. Default: GIF file loop count.
    ///   - onComplete: Closure called when the animation fully completes.
    public init(name: String,
                bundle: Bundle = .main,
                loopCount: Int? = nil,
                onComplete: (() -> Void)? = nil)
    {
        fileInfo = .init(name: name, bundle: bundle)
        self.loopCount = loopCount
        self.onComplete = onComplete
    }

    // MARK: - Body

    public var body: some View {
        TimelineView(.animation) { context in
            let elapsedSeconds = context.date.timeIntervalSince1970 - startTime.timeIntervalSince1970
            if let gif {
                let loopCount = loopCount ?? gif.loopCount
                let frame = gif.frames.frame(at: elapsedSeconds,
                                             loopCount: loopCount)

                ZStack {
                    if let frame {
                        Image(uiImage: frame.image())
                            .resizable()
                            .scaledToFit()
                    }
                }
                .onChange(of: frame == nil) { isAnimationComplete in
                    guard isAnimationComplete else { return }
                    onComplete?()
                }
            }
        }
        .onChange(of: data) { data in
            guard let data else { return }
            gif = .init(data: data)
        }
        .onChange(of: fileInfo) { fileInfo in
            guard let fileInfo else { return }
            gif = .init(name: fileInfo.name, bundle: fileInfo.bundle)
        }
        .onAppear {
            if let data {
                gif = .init(data: data)
            } else if let fileInfo {
                gif = .init(name: fileInfo.name, bundle: fileInfo.bundle)
            }
        }
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var isDone = false

    VStack {
        GIFImage(name: "example", bundle: .module)
            .frame(height: 300)

        if isDone {
            Text("Animation Completed!")
        } else {
            GIFImage(name: "example", bundle: .module, loopCount: 2) {
                isDone = true
            }
            .frame(height: 300)
        }
    }
}
