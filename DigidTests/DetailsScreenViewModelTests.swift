//
//  DetailScreenViewModelTests.swift
//  DigidTests
//
//  Created by Artem Kutasevych on 20.10.2023.
//

import XCTest
@testable import Digid

final class DetailScreenViewModelTests: XCTestCase {

    private var sut: DetailScreenViewModel?
    private var networkService = NetworkServiceMock()

    override func setUpWithError() throws {
        try super.setUpWithError()
        let model = Item(text: "", confidence: 0.5, imageUrl: "", id: "adfsfaaf")
        sut = DetailScreenViewModel(networkService: networkService, model: model)
    }
    
    func testShowImage() throws {
        sut?.showImage { image in
            XCTAssertNotNil(image)
        }
        XCTAssertTrue((networkService.getImageUsingUrlCalled))
    }
}
