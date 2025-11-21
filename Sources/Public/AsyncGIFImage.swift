//
//  AsyncGIFImage.swift
//  SwiftUIGIF
//
//  Created by Ruben Martinez Jr. on 11/20/25.
//

import SwiftUI

/// Renders an animated GIF image asynchronously from a remote URL.
public struct AsyncGIFImage<Placeholder: View>: View {
    // MARK: - Private Properties

    @State private var imageData: Data?
    private let url: URL?
    private let urlSession: URLSession
    private let loopCount: Int?
    private let onComplete: (() -> Void)?
    private let placeholder: () -> Placeholder

    // MARK: - Lifecycle

    /// Initialize `AsyncGIFImage` with a URL.
    /// - Parameters:
    ///   - url: The URL of the GIF image.
    ///   - urlSession: The URL session to use for loading the image data.
    ///   - loopCount: Override the number of times to play the animation loop. Default: GIF file loop count.
    ///   - onComplete: Closure called when the animation fully completes.
    ///   - placeholder: A closure that returns a placeholder view to show while the image is loading.
    public init(url: URL?,
                urlSession: URLSession = .shared,
                loopCount: Int? = nil,
                onComplete: (() -> Void)? = nil,
                placeholder: @escaping () -> Placeholder = { EmptyView() })
    {
        self.url = url
        self.urlSession = urlSession
        self.loopCount = loopCount
        self.onComplete = onComplete
        self.placeholder = placeholder
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            if let imageData {
                GIFImage(data: imageData,
                         loopCount: loopCount,
                         onComplete: onComplete)
            } else {
                placeholder()
            }
        }
        .task {
            guard let url else { return }
            do {
                (imageData, _) = try await urlSession.data(from: url)
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var isDone = false
    @Previewable @State var url = URL(string: "https://github.com/rubencodes/SwiftUIGIF/blob/main/Sources/Resources/example.gif?raw=true")

    VStack {
        AsyncGIFImage(url: url)
            .frame(width: 300)

        if isDone {
            Text("Animation Completed!")
        } else {
            AsyncGIFImage(url: url,
                          loopCount: 2)
            {
                isDone = true
            } placeholder: {
                Text("Loading")
            }
            .frame(width: 300)
        }
    }
}
