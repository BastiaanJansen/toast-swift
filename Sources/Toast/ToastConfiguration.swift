//
//  ToastConfiguration.swift
//  Toast
//
//  Created by Bastiaan Jansen on 28/06/2021.
//

import Foundation
import UIKit

public struct ToastConfiguration {
    public let direction: Toast.Direction
    public let autoHide: Bool
    public let enablePanToClose: Bool
    public let displayTime: TimeInterval
    public let animationTime: TimeInterval
    public let enteringAnimation: Toast.AnimationType
    public let exitingAnimation: Toast.AnimationType
    
    public let view: UIView?
    
    /// Creates a new Toast configuration object.
    /// - Parameters:
    ///   - direction: The position the toast will be displayed.
    ///   - autoHide: When set to true, the toast will automatically close itself after display time has elapsed.
    ///   - enablePanToClose: When set to true, the toast will be able to close by swiping up.
    ///   - displayTime: The duration the toast will be displayed before it will close when autoHide set to true.
    ///   - animationTime:Duration of the animation
    ///   - enteringAnimation: The entering animation of the toast.
    ///   - exitingAnimation: The exiting animation of the toast.
    ///   - attachTo: The view on which the toast view will be attached.
    public init(
        direction: Toast.Direction = .top,
        autoHide: Bool = true,
        enablePanToClose: Bool = true,
        displayTime: TimeInterval = 4,
        animationTime: TimeInterval = 0.2,
        enteringAnimation: Toast.AnimationType = .default,
        exitingAnimation: Toast.AnimationType = .default,
        attachTo view: UIView? = nil
    ) {
        self.direction = direction
        self.autoHide = autoHide
        self.enablePanToClose = enablePanToClose
        self.displayTime = displayTime
        self.animationTime = animationTime
        self.enteringAnimation = enteringAnimation.isDefault ? Self.defaultEnteringAnimation(with: direction) : enteringAnimation
        self.exitingAnimation = exitingAnimation.isDefault ? Self.defaultExitingAnimation(with: direction) : exitingAnimation
        self.view = view
    }
}

// MARK: Default animations
private extension ToastConfiguration {
    private static func defaultEnteringAnimation(with direction: Toast.Direction) -> Toast.AnimationType {
        switch direction {
        case .top:
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -100)
            )
        case .bottom:
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: 100)
            )
        }
    }
    
    private static func defaultExitingAnimation(with direction: Toast.Direction) -> Toast.AnimationType {
        self.defaultEnteringAnimation(with: direction)
    }
}

fileprivate extension Toast.AnimationType {
    var isDefault: Bool {
        if case .default = self {
            return true
        }
        return false
    }
}
