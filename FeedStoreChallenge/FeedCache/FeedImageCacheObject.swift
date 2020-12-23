//
//  FeedImageCacheObject.swift
//  FeedStoreChallenge
//
//  Created by 劉峻岫 on 2020/12/23.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class FeedImageCacheObject: Object {
    @objc dynamic var timestamp = Date()
    var feedImageObjects = List<FeedImageObject>()
}

extension FeedImageCacheObject {
    static func cache(_ feed: [FeedImageObject], timestamp: Date) -> FeedImageCacheObject {
        let cache = FeedImageCacheObject()
        cache.timestamp = timestamp

        for image in feed {
            cache.feedImageObjects.append(image)
        }

        return cache
    }
}
