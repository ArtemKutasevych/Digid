//
//  NetworkServiceMock.swift
//  DigidTests
//
//  Created by Artem Kutasevych on 19.10.2023.
//

import Foundation
import UIKit
@testable import Digid

final class NetworkServiceMock: NetworkService {
    
    var requestCallsCount = 0
    var requestCalled: Bool {
        return requestCallsCount > 0
    }
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, HTTPError>) -> Void) {
        requestCallsCount += 1
    }
    
    var getImageUsingUrlCallsCount = 0
    var getImageUsingUrlCalled: Bool {
        return getImageUsingUrlCallsCount > 0
    }
    var getImageUsingUrlReceivedValue: String?

    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        getImageUsingUrlCallsCount += 1
        let image = UIImage()
        completion(image)
    }
    
    
    var cancelTaskCallsCount = 0
    var cancelTaskCalled: Bool {
        return cancelTaskCallsCount > 0
    }

    func cancelTaskBy(id: String) {
        cancelTaskCallsCount += 1
    }
}
