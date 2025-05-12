//
//  CachedAsyncImage.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import SwiftUI

import SwiftUI

/// A SwiftUI view that asynchronously loads and displays an image from a URL, using URLCache for caching.
public struct CachedAsyncImage: View {
    
    private let url: URL?
    @State private var image: Image? = nil
    @State private var isLoading = false

    /// Initializes the view with an optional image URL
    /// - Parameter url: The URL from which to fetch the image
    public init(url: URL?) {
        self.url = url
    }

    /// The body of the view: shows the image if loaded, otherwise shows a loading spinner
    public var body: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await loadImage()
                    }
                }
        }
    }

    /// Loads the image from cache or network, and stores it in cache if downloaded.
    private func loadImage() async {
        guard let url = url, !isLoading else { return }

        isLoading = true
        let request = URLRequest(url: url)

        // Try to load the image from cache first
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }

        do {
            // Download image from the network
            let (data, response) = try await URLSession.shared.data(for: request)

            // Store the response in cache
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)

            // Convert and display the image
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            // In case of an error, just stop loading (no retry or fallback here)
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

