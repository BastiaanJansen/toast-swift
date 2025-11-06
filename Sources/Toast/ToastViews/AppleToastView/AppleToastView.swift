//
//  ToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 30/06/2021.
//

import Foundation
import UIKit

public class AppleToastView : UIView, ToastView {
    private let config: ToastViewConfiguration
    
    private let child: UIView
    
    private var toast: Toast?
    
    private let fixedHeight: CGFloat?
    private let fixedWidth: CGFloat?
    
    public init(
        child: UIView,
        config: ToastViewConfiguration = ToastViewConfiguration(),
        fixedHeight: CGFloat? = nil,
        fixedWidth: CGFloat? = nil
    ) {
        self.config = config
        self.child = child
        self.fixedHeight = fixedHeight
        self.fixedWidth = fixedWidth
        super.init(frame: .zero)
        
        addSubview(child)
    }
    
    public override func removeFromSuperview() {
      super.removeFromSuperview()
      self.toast = nil
    }
    
    public func createView(for toast: Toast) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ]
        
        /// Height:
        /// - If a fixed height is provided, enforce an exact height (==).
        /// - Otherwise, only enforce a minimum (≥) so the view can expand with content.
        if let fixedHeight = fixedHeight {
            constraints.append(heightAnchor.constraint(equalToConstant: fixedHeight))
        } else {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualToConstant: config.minHeight))
        }

        /// Width:
        /// - If a fixed width is provided, enforce an exact width (==).
        /// - Otherwise, only enforce a minimum (≥); actual width will be determined
        ///   by content size up to the available space (bounded by leading/trailing).
        if let fixedWidth = fixedWidth {
            constraints.append(widthAnchor.constraint(equalToConstant: fixedWidth))
        } else {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: config.minWidth))
        }
        
        switch toast.config.direction {
        case .bottom:
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        case .top:
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        case .center:
            centerYAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerYAnchor, constant: 0).isActive = true
        }
        
        NSLayoutConstraint.activate(constraints)
        addSubviewConstraints()
        DispatchQueue.main.async {
            self.style()
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }
    
    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerRadius = config.cornerRadius ?? frame.height / 2
        if #available(iOS 12.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .light ? config.lightBackgroundColor : config.darkBackgroundColor
        } else {
            backgroundColor = config.lightBackgroundColor
        }
        
        addShadow()
    }
    
    private func addSubviewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
