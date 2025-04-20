//
//  StreamViewModel.swift
//  Streamosphere
//
//  Created by Michael Bino on 4/20/25.
//

import Foundation
import AVKit

class StreamViewModel: ObservableObject {
    @Published var streamURL: String
    @Published var isPlayingOnOpen: Bool
    @Published var retryTimeout: Double
    @Published var player: AVPlayer?

    private var retryTimer: Timer?

    init() {
        let defaults = UserDefaults.standard
        self.streamURL = defaults.string(forKey: ContentView.lastStreamURLKey) ?? ""
        self.isPlayingOnOpen = defaults.bool(forKey: ContentView.playOnOpenKey)
        let timeout = defaults.double(forKey: ContentView.retryTimeoutKey)
        self.retryTimeout = timeout == 0 ? 5.0 : timeout
    }

    func updateSettings(isPlayingOnOpen: Bool, retryTimeout: Double) {
        self.isPlayingOnOpen = isPlayingOnOpen
        self.retryTimeout = retryTimeout
        UserDefaults.standard.set(isPlayingOnOpen, forKey: ContentView.playOnOpenKey)
        UserDefaults.standard.set(retryTimeout, forKey: ContentView.retryTimeoutKey)
        restartRetryTimer()
    }

    func updateStreamURL(_ url: String) {
        self.streamURL = url
        UserDefaults.standard.set(url, forKey: ContentView.lastStreamURLKey)
    }

    func playStream() {
        guard let url = URL(string: streamURL) else { return }
        player = AVPlayer(url: url)
        player?.play()
    }

    func startStreamIfNeeded() {
        guard let url = URL(string: streamURL) else { return }
        player = AVPlayer(url: url)
        if isPlayingOnOpen {
            player?.play()
        }
        startRetryTimer()
    }

    func stopRetryTimer() {
        retryTimer?.invalidate()
        retryTimer = nil
    }

    private func restartRetryTimer() {
        stopRetryTimer()
        startRetryTimer()
    }

    private func startRetryTimer() {
        guard retryTimer == nil else { return }
        retryTimer = Timer.scheduledTimer(withTimeInterval: retryTimeout, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.player?.currentItem == nil, let url = URL(string: self.streamURL) {
                    print("Retrying stream: \(self.streamURL)")
                    self.player = AVPlayer(url: url)
                    if self.isPlayingOnOpen {
                        self.player?.play()
                    }
                }
            }
        }
    }
}
