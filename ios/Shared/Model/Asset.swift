/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A simple class that holds information about an Asset.
 */
import AVFoundation
@available(iOS 11.2, *)
class Asset {
    
    /// The AVURLAsset corresponding to this Asset.
    var urlAsset: AVURLAsset
    
    /// The underlying `Stream` associated with the Asset based on the contents of the `Streams.plist` entry.
    let stream: Stream
    
    
    init(stream: Stream, urlAsset: AVURLAsset) {
        self.urlAsset = urlAsset
        self.stream = stream
        
        if self.stream.isProtected {
            ContentKeyManager.shared.contentKeySession.addContentKeyRecipient(self.urlAsset)
        }
    }
}

/// Extends `Asset` to conform to the `Equatable` protocol.
@available(iOS 11.2, *)
extension Asset: Equatable {
    static func ==(lhs: Asset, rhs: Asset) -> Bool {
        return (lhs.stream == rhs.stream) && (lhs.urlAsset == rhs.urlAsset)
    }
}

/**
 Extends `Asset` to add a simple download state enumeration used by the sample
 to track the download states of Assets.
 */
@available(iOS 11.2, *)
extension Asset {
    enum DownloadState: String {
        
        /// The asset is not downloaded at all.
        case notDownloaded
        
        /// The asset has a download in progress.
        case downloading
        
        /// The asset is downloaded and saved on diek.
        case downloaded
    }
}

/**
 Extends `Asset` to define a number of values to use as keys in dictionary lookups.
 */
@available(iOS 11.2, *)
extension Asset {
    struct Keys {
        /**
         Key for the Asset name, used for `AssetDownloadProgressNotification` and
         `AssetDownloadStateChangedNotification` Notifications as well as
         AssetListManager.
         */
        static let name = "AssetNameKey"
        
        /**
         Key for the Asset download percentage, used for
         `AssetDownloadProgressNotification` Notification.
         */
        static let percentDownloaded = "AssetPercentDownloadedKey"
        
        /**
         Key for the Asset download state, used for
         `AssetDownloadStateChangedNotification` Notification.
         */
        static let downloadState = "AssetDownloadStateKey"
        
        /**
         Key for the Asset download AVMediaSelection display Name, used for
         `AssetDownloadStateChangedNotification` Notification.
         */
        static let downloadSelectionDisplayName = "AssetDownloadSelectionDisplayNameKey"
    }
}

@available(iOS 11.2, *)
extension Asset {
    func toResult(action: String, progress: Float?, state: Asset.DownloadState?) -> NSDictionary {
        let ret = NSDictionary.init()
        ret.setValue(action, forKey: Constants.EVENT_DOWNLOAD_DRM_VIDEO_ACTION)
        ret.setValue(self.stream.name, forKey: Constants.VIDEO_ID)
        ret.setValue(self.stream.playlistURL, forKey: Constants.VIDEO_URL)
        ret.setValue(Utils.getState(state: state ?? .notDownloaded), forKey: Constants.RESULT_PROGRESS)
        return ret
    }
}
