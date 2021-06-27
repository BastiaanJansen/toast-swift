//
//  Toast.swift
//  Toast
//
//  Created by Bastiaan Jansen on 27/06/2021.
//

import UIKit

class Toast: UIView {
    
    private static let DEFAULT_AUTO_HIDE: Bool = true
    private static let DEFAULT_SWIPE_UP_TO_HIDE: Bool = true
    private static let DEFAULT_DISPLAY_TIME: TimeInterval = 4
    
    private let minHeight: CGFloat = 58
    private let minWidth: CGFloat = 150
    private let hStack: UIStackView
    private let spacing: CGFloat = 10
    
    private let autoHide: Bool
    private let swipeUpToHide: Bool
    private let displayTime: TimeInterval
    
    private let startingYPoint: CGFloat = -100
    private let animationTime: TimeInterval = 0.3
    
    private let onTap: ((_ toast: Toast) -> ())?
    
    public init(
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        autoHide: Bool = DEFAULT_AUTO_HIDE,
        displayTime: TimeInterval = DEFAULT_DISPLAY_TIME,
        swipeUpToHide: Bool = DEFAULT_SWIPE_UP_TO_HIDE,
        onTap: ((_: Toast) -> ())? = nil) {
        self.hStack = UIStackView()
        self.onTap = onTap
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.swipeUpToHide = swipeUpToHide
        super.init(frame: CGRect.zero)
        
        // Add to top controllers view
        topController()?.view.addSubview(self)
        
        backgroundColor = .white
        
        hStack.axis = .horizontal
        hStack.spacing = spacing
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        vStack.addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subTitleLabel = UILabel()
            subTitleLabel.text = subtitle
            subTitleLabel.font = .systemFont(ofSize: 11, weight: .light)
            vStack.addArrangedSubview(subTitleLabel)
        }
        
        if let icon = icon {
            let imageView = UIImageView()
            imageView.image = icon
            imageView.tintColor = .label
            
            hStack.addArrangedSubview(imageView)
        }
        
        hStack.addArrangedSubview(vStack)
        
        addSubview(hStack)
    
        setupGestureRecognizers()
        setupConstraints()
        setupShadow()
        
        transform = CGAffineTransform(translationX: 0, y: startingYPoint)
    }
    
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    public func show(after delay: TimeInterval = 0) {
        UIView.animate(withDuration: animationTime, delay: delay, options: .curveEaseOut) {
            self.transform = CGAffineTransform(translationX: 0, y: 10)
        } completion: { [self] _ in
            if autoHide {
                close(after: displayTime)
            }
        }

    }
    
    @objc public func close() {
        close(after: 0)
    }
    
    public func close(after time: TimeInterval) {
        UIView.animate(withDuration: animationTime, delay: time, options: .curveEaseOut) {
            self.transform = CGAffineTransform(translationX: 0, y: self.startingYPoint)
        } completion: { [self] _ in
            removeFromSuperview()
        }
    }
    
    @objc private func executeOnTap() {
        self.onTap?(self)
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(executeOnTap)))
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(close as () -> Void))
        swipeUpGestureRecognizer.direction = .up
        
        addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: minHeight)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: minWidth)

        let centerConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1, constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .leadingMargin, multiplier: 1, constant: 10)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .trailingMargin, multiplier: 1, constant: -10)
        
        clipsToBounds = true
        layer.cornerRadius = minHeight / 2
        superview?.addConstraints([heightConstraint, widthConstraint, centerConstraint, topConstraint, leadingConstraint, trailingConstraint])
        
        hStackConstraints()
    }
    
    private func hStackConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            hStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 25),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -25),
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
    }
    
    private func topController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
