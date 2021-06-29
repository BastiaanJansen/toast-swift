//
//  ToastConfiguration.swift
//  ToastTest
//
//  Created by Bastiaan Jansen on 28/06/2021.
//

import Foundation
import UIKit

struct ToastConfiguration {
    
    public let appearance: ToastAppearance
    
    public let autoHide: Bool
    public let displayTime: TimeInterval
    public let swipeUpToHide: Bool
    public let animationTime: TimeInterval
    
    public let onTap: ((_: Toast) -> ())?
    
    public let view: UIView?
    
    public init(
        appearance: ToastAppearance = DefaultToastAppearance(),
        autoHide: Bool = true,
        displayTime: TimeInterval = 4,
        swipeUpToHide: Bool = true,
        animationTime: TimeInterval = 0.3,
        view: UIView? = nil,
        onTap: ((_: Toast) -> ())? = nil
    ) {
        self.appearance = appearance
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.swipeUpToHide = swipeUpToHide
        self.animationTime = animationTime
        self.view = view
        self.onTap = onTap
    }
}
