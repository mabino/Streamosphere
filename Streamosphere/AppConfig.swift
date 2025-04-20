//
//  AppConfig.swift
//  Streamosphere
//
//  Created by Michael Bino on 4/20/25.

import Foundation

struct AppConfigKeys {
    static let playOnOpen = "PlayOnAppOpen"
    static let retryTimeout = "RetryTimeout"
    static let streamURL = "StreamURL"
}

class AppConfig {
    static func applyConfiguration() {
        guard let managedConfig = UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed") as? [String: Any] else {
            print("No managed configuration found.")
            return
        }

        if let playOnOpenValue = managedConfig[AppConfigKeys.playOnOpen] as? Bool {
            UserDefaults.standard.set(playOnOpenValue, forKey: ContentView.playOnOpenKey)
            print("Applied managed PlayOnAppOpen: \(playOnOpenValue)")
        }

        if let retryTimeoutValue = managedConfig[AppConfigKeys.retryTimeout] as? Double {
            UserDefaults.standard.set(retryTimeoutValue, forKey: ContentView.retryTimeoutKey)
            print("Applied managed RetryTimeout: \(retryTimeoutValue)")
        }

        if let streamURLValue = managedConfig[AppConfigKeys.streamURL] as? String {
            UserDefaults.standard.set(streamURLValue, forKey: ContentView.lastStreamURLKey)
            print("Applied managed StreamURL: \(streamURLValue)")
        }
    }
}
