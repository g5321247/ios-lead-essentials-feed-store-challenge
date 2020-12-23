//
//  RealmFeedStore.swift
//  FeedStoreChallenge
//
//  Created by 劉峻岫 on 2020/12/23.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmFeedStore: FeedStore {

    let realm: Realm

    public init(config: Realm.Configuration) throws {
        realm = try Realm(configuration: config)
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        try! realm.write {
            realm.deleteAll()
            completion(nil)
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        deleteCachedFeed(completion: { _ in })
        try! realm.write {
            realm.add(FeedImageCacheObject.cache(feed.map { FeedImageObject(image: $0)}, timestamp: timestamp))
            completion(nil)
        }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        if let cache = realm.objects(FeedImageCacheObject.self).first {
            completion(.found(feed: cache.feedImageObjects.toLocalFeedImage(), timestamp: cache.timestamp))
        } else {
            completion(.empty)
        }
    }
}

private extension List where Element == FeedImageObject {
    func toLocalFeedImage() -> [LocalFeedImage] {
        return compactMap { $0.local }
    }
}
