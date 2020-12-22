//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
import RealmSwift

class FeedImageObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var feedDescription: String? = ""
    @objc dynamic var location: String? = ""
    @objc dynamic var url: String = ""

    var local: LocalFeedImage {
        return LocalFeedImage(id: UUID(uuidString: id)!, description: feedDescription, location: location, url: URL(string: url)!)
    }

    convenience init(image: LocalFeedImage) {
        self.init()
        id = image.id.uuidString
        feedDescription = image.description
        location = image.location
        url = image.url.absoluteString
    }

}

class FeedImageCacheObject: Object {
    @objc dynamic var timestamp = Date()
    var feedImageObjects = List<FeedImageObject>()

    var feedImage: [LocalFeedImage] {
        return feedImageObjects.compactMap { $0.local }
    }

    static func makeCache(_ feed: [FeedImageObject], timestamp: Date) -> FeedImageCacheObject {
        let cache = FeedImageCacheObject()
        cache.timestamp = timestamp

        for image in feed {
            cache.feedImageObjects.append(image)
        }

        return cache
    }
}

class RealmFeedStore: FeedStore {

    let realm: Realm

    init(config: Realm.Configuration) throws {
        realm = try Realm(configuration: config)
    }

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        try! realm.write {
            realm.deleteAll()
            completion(nil)
        }
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        deleteCachedFeed(completion: { _ in })
        try! realm.write {
            realm.add(FeedImageCacheObject.makeCache(feed.map { FeedImageObject(image: $0)}, timestamp: timestamp))
            completion(nil)
        }
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        if let cache = realm.objects(FeedImageCacheObject.self).first {
            completion(.found(feed: cache.feedImage, timestamp: cache.timestamp))
        } else {
            completion(.empty)
        }
    }
}

class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
    //  ***********************
    //
    //  Follow the TDD process:
    //
    //  1. Uncomment and run one test at a time (run tests with CMD+U).
    //  2. Do the minimum to make the test pass and commit.
    //  3. Refactor if needed and commit again.
    //
    //  Repeat this process until all tests are passing.
    //
    //  ***********************

	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_insert_overridesPreviouslyInsertedCacheValues() {
		let sut = makeSUT()

		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}

	func test_delete_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_delete_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_delete_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_delete_emptiesPreviouslyInsertedCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}

	func test_storeSideEffects_runSerially() {
//		let sut = makeSUT()
//
//		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
        let config = Realm.Configuration(inMemoryIdentifier: String(describing: FeedStoreChallengeTests.self))
        let sut = try! RealmFeedStore(config: config)

        trackForMemoryLeaks(sut: sut,file: file, line: line)

        return sut
	}

}

extension FeedStoreChallengeTests {
    func trackForMemoryLeaks(sut: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
    }
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************

//extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
//
//	func test_retrieve_deliversFailureOnRetrievalError() {
////		let sut = makeSUT()
////
////		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
//	}
//
//	func test_retrieve_hasNoSideEffectsOnFailure() {
////		let sut = makeSUT()
////
////		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
//
//	func test_insert_deliversErrorOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertDeliversErrorOnInsertionError(on: sut)
//	}
//
//	func test_insert_hasNoSideEffectsOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {
//
//	func test_delete_deliversErrorOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
//	}
//
//	func test_delete_hasNoSideEffectsOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
//	}
//
//}
