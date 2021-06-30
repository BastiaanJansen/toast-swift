//
//  ToastConfiguration.swift
//  Toast
//
//  Created by Bastiaan Jansen on 28/06/2021.
//

import Foundation
import UIKit

struct ToastConfiguration {
    
    public let autoHide: Bool
    public let displayTime: TimeInterval
    public let swipeUpToHide: Bool
    public let animationTime: TimeInterval
    
    public let onTap: ((_: Toast) -> ())?
    
    public let view: UIView?
    
    public init(
        autoHide: Bool = true,
        displayTime: TimeInterval = 4,
        swipeUpToHide: Bool = true,
        animationTime: TimeInterval = 0.2,
        view: UIView? = nil,
        onTap: ((_: Toast) -> ())? = nil
    ) {
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.swipeUpToHide = swipeUpToHide
        self.animationTime = animationTime
        self.view = view
        self.onTap = onTap
    }
}
