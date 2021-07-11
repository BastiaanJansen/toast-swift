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
    public let animationTime: TimeInterval
    
    public let view: UIView?
    
    
    /// Creates a new Toast configuration object.
    /// - Parameters:
    ///   - autoHide: When set to true, the toast will automatically close itself after display time has elapsed.
    ///   - displayTime: The duration the toast will be displayed before it will close when autoHide set to true.
    ///   - animationTime:Duration of the animation
    ///   - attachTo: The view on which the toast view will be attached.
    public init(
        autoHide: Bool = true,
        displayTime: TimeInterval = 4,
        animationTime: TimeInterval = 0.2,
        attachTo view: UIView? = nil
    ) {
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.animationTime = animationTime
        self.view = view
    }
}
