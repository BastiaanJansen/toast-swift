//
//  ToastConfiguration.swift
//  Toast
//
//  Created by Bastiaan Jansen on 28/06/2021.
//

import Foundation
import UIKit

struct ToastConfiguration {
    private static let DEFAULT_AUTO_HIDE: Bool = true
    private static let DEFAULT_SWIPE_UP_TO_HIDE: Bool = true
    private static let DEFAULT_DISPLAY_TIME: TimeInterval = 4
    public static let DEFAULT_ANIMATION_TIME: TimeInterval = 0.3
    
    public let icon: UIImage?
    public let autoHide: Bool
    public let displayTime: TimeInterval
    public let swipeUpToHide: Bool
    public let animationTime: TimeInterval
    public let onTap: ((_: Toast) -> ())?
    
    public let view: UIView?
    
    public init(
        icon: UIImage? = nil,
        autoHide: Bool = DEFAULT_AUTO_HIDE,
        displayTime: TimeInterval = DEFAULT_DISPLAY_TIME,
        swipeUpToHide: Bool = DEFAULT_SWIPE_UP_TO_HIDE,
        animationTime: TimeInterval = DEFAULT_ANIMATION_TIME,
        view: UIView? = nil,
        onTap: ((_: Toast) -> ())? = nil
    ) {
        self.icon = icon
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.swipeUpToHide = swipeUpToHide
        self.animationTime = animationTime
        self.view = view
        self.onTap = onTap
    }
}
