//
//  URLProtocolMock.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import Foundation

/// A custom `URLProtocol` subclass used to intercept and mock network requests during testing.
final class URLProtocolMock: URLProtocol {

    /// Static property to hold mock response data to be returned during the test
    static var mockResponseData: Data?

    /// Determines whether this protocol can handle the given request
    /// Always returns true to intercept all requests
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    /// Returns the canonical form of the request (unchanged in this mock)
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    /// Starts loading the mock response
    override func startLoading() {
        if let data = URLProtocolMock.mockResponseData {
            // Create a dummy HTTP response with status code 200
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            // Notify the client with the mock response and data
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }

        // Notify that loading has finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    /// Stops loading (no-op in this mock implementation)
    override func stopLoading() {}
}
