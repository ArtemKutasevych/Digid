//
//  ListViewModelTests.swift
//  DigidTests
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import XCTest
@testable import Digid

final class ListViewModelTests: XCTestCase {
    
    private var sut: ListViewModel?
    private var networkService = NetworkServiceMock()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListViewModel(networkService: networkService)
    }

    func testGetItemsFail() throws {
        sut?.getItems{}
        XCTAssert(networkService.requestCalled)
    }
    
    func testShowImage() throws {
        sut?.showImage(for: "", completion: { image in
            XCTAssertNotNil(image)
        })
        XCTAssertTrue((networkService.getImageUsingUrlCalled))
    }
    
    func testCancelTask() throws {
        sut?.cancelTaskBy(id: "")
        XCTAssertTrue(networkService.cancelTaskCalled)
    }
}
