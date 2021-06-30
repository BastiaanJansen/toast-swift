//
//  Toast.swift
//  Toast
//
//  Created by Bastiaan Jansen on 27/06/2021.
//

import UIKit

class Toast: UIView {
    
    private let view: UIView

    private let config: ToastConfiguration
    private var isVisible: Bool = false
    
    private var startingYPoint: CGFloat {
        return -frame.height - 30
    }
    
    public static func text(_ title: String, subtitle: String? = nil, config: ToastConfiguration = ToastConfiguration()) -> Toast {
        return self.init(view: TextToastView(title, subtitle: subtitle), config: config)
    }
    
    public static func `default`(
        image: UIImage,
        title: String,
        subtitle: String?,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return self.init(view: DefaultToastView(image: image, title: title, subtitle: subtitle), config: config)
    }
    
    public static func custom(view: UIView, config: ToastConfiguration = ToastConfiguration()) -> Toast {
        return self.init(view: view, config: config)
    }
    
    public required init(view: UIView, config: ToastConfiguration) {
        self.config = config
        self.view = view
        super.init(frame: CGRect.zero)
    
        config.view?.addSubview(self) ?? topController()?.view.addSubview(self)
        
        addSubview(view)
        
        config.appearance.addConstraints(to: self)
        
        addViewConstraints(to: view)
        
        config.appearance.style(view: self)
        
        setupGestureRecognizers()
        
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: startingYPoint)
    }
    
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    public func show(after delay: TimeInterval = 0) {
        if isVisible { return }
        
        UIView.animate(withDuration: config.animationTime, delay: delay, options: .curveEaseOut) {
            self.transform = .identity
        } completion: { [self] _ in
            isVisible = true
            if config.autoHide {
                close(after: config.displayTime)
            }
        }
    }
    
    @objc public func close() {
        close()
    }
    
    public func close(after time: TimeInterval = 0, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: config.animationTime, delay: time, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.startingYPoint)
        }) { [self] _ in
            isVisible = false
            completion?()
        }
    }
    
    @objc private func executeOnTapHandler() {
        config.onTap?(self)
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(executeOnTapHandler)))
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(close as () -> Void))
        swipeUpGestureRecognizer.direction = .up
        
        addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    private func addViewConstraints(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 25),
            view.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -25),
        ])
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
