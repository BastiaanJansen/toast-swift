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
    
    public init(
        child: UIView,
        config: ToastViewConfiguration = ToastViewConfiguration()
    ) {
        self.config = config
        self.child = child
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
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: config.minHeight),
            widthAnchor.constraint(greaterThanOrEqualToConstant: config.minWidth),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        
        switch toast.direction {
        case .bottom:
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            
        case .top:
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        }
        
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
        layer.cornerRadius = frame.height / 2
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
