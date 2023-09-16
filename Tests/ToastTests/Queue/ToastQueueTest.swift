//
//  ToastQueuetest.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import XCTest
@testable import Toast

final class ToastQueueTest: XCTestCase {
    
    private var queue: ToastQueue!

    override func setUpWithError() throws {
        queue = ToastQueue()
    }

    override func tearDownWithError() throws {
        
    }

    func test_whenEnqueuingToast_sizeIsOne() throws {
        let toast = Toast.text("Toast")
        
        queue.enqueue(toast)
        
        XCTAssertEqual(queue.size(), 1)
    }
    
    func test_whenEnqueuingMultipleToasts_sizeIsThree() throws {
        let toast = Toast.text("Toast")
        let toast2 = Toast.text("Toast")
        let toast3 = Toast.text("Toast")
        
        queue.enqueue([toast, toast2, toast3])
        
        XCTAssertEqual(queue.size(), 3)
    }

}
