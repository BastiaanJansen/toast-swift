//
//  ToastConfiguration.swift
//  Toast
//
//  Created by Bastiaan Jansen on 28/06/2021.
//

import Foundation
import UIKit

public struct ToastConfiguration {
    public let autoHide: Bool
    public let displayTime: TimeInterval
    public let swipeUpToHide: Bool
    public let animationTime: TimeInterval
    public let removeFromView: Bool
    
    public let onTap: ((Toast) -> Void)?
    
    public let view: UIView?
    
    public init(
        autoHide: Bool = true,
        displayTime: TimeInterval = 4,
        swipeUpToHide: Bool = true,
        animationTime: TimeInterval = 0.2,
        removeFromView: Bool = false,
        view: UIView? = nil,
        onTap: ((Toast) -> Void)? = nil
    ) {
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.swipeUpToHide = swipeUpToHide
        self.animationTime = animationTime
        self.removeFromView = removeFromView
        self.view = view
        self.onTap = onTap
    }
}
