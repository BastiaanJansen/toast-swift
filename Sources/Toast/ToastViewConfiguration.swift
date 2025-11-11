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
    
    public let titleNumberOfLines: Int
    public let subtitleNumberOfLines: Int
    
    public let cornerRadius: CGFloat?

    public let textAlignment: UIStackView.Alignment

    public let shadowOffset: CGSize
    public let shadowColor: UIColor
    public let shadowOpacity: Float

    public init(
        minHeight: CGFloat = 58,
        minWidth: CGFloat = 150,
        darkBackgroundColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00),
        lightBackgroundColor: UIColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00),
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 1,
        cornerRadius: CGFloat? = nil,
        textAlignment: UIStackView.Alignment = .center,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowColor: UIColor = .black.withAlphaComponent(0.08),
        shadowOpacity: Float = 1
    ) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.darkBackgroundColor = darkBackgroundColor
        self.lightBackgroundColor = lightBackgroundColor
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.cornerRadius = cornerRadius
        self.textAlignment = textAlignment
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
    }
}
