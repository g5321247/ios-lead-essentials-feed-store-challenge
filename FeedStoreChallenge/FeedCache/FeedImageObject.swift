//
//  FeedImageObject.swift
//  FeedStoreChallenge
//
//  Created by 劉峻岫 on 2020/12/23.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class FeedImageObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var feedDescription: String? = ""
    @objc dynamic var location: String? = ""
    @objc dynamic var url: String = ""

    convenience init(image: LocalFeedImage) {
        self.init()
        id = image.id.uuidString
        feedDescription = image.description
        location = image.location
        url = image.url.absoluteString
    }
}

extension FeedImageObject {
    var local: LocalFeedImage {
        return LocalFeedImage(id: UUID(uuidString: id)!, description: feedDescription, location: location, url: URL(string: url)!)
    }
}
