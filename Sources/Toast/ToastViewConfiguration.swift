//
//  ToastViewConfiguration.swift
//  Toast
//
//  Created by Thomas Maw on 12/9/2023.
//

import Foundation
import UIKit

public struct ToastViewConfiguration {
    public let minHeight: CGFloat
    public let minWidth: CGFloat
    
    public let darkBackgroundColor: UIColor
    public let lightBackgroundColor: UIColor
    
    public init(
        minHeight: CGFloat = 58,
        minWidth: CGFloat = 150,
        darkBackgroundColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00),
        lightBackgroundColor: UIColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    ) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.darkBackgroundColor = darkBackgroundColor
        self.lightBackgroundColor = lightBackgroundColor
    }
}
