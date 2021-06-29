//
//  DefaultToastAppearance.swift
//  ToastTest
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

class DefaultToastAppearance : ToastAppearance {
    
    private let minHeight: CGFloat
    private let minWidth: CGFloat

    private let darkBackgroundColor: UIColor
    private let lightBackgroundColor: UIColor
    
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
    
    func addConstraints(to view: Toast) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: minHeight)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: minWidth)

        let centerConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: view.superview, attribute: .topMargin, multiplier: 1, constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view.superview, attribute: .leadingMargin, multiplier: 1, constant: 10)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: view.superview, attribute: .trailingMargin, multiplier: 1, constant: -10)

        view.superview?.addConstraints([heightConstraint, widthConstraint, centerConstraint, topConstraint, leadingConstraint, trailingConstraint])
    }
    
    func style(view: Toast) {
        view.layoutIfNeeded()
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = view.traitCollection.userInterfaceStyle == .light ? lightBackgroundColor : darkBackgroundColor
        
        addShadow(to: view)
    }
    
    private func addShadow(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1
    }
}
