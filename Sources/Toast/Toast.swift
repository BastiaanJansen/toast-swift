//
//  Toast.swift
//  Toast
//
//  Created by Bastiaan Jansen on 27/06/2021.
//

import UIKit

public class Toast {
    private let view: ToastView

    private let config: ToastConfiguration
    private var isVisible: Bool = false
    
    private var initialTransform: CGAffineTransform {
        return CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -100)
    }
    
    public static func text(
        _ title: String,
        subtitle: String? = nil,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(child: TextToastView(title, subtitle: subtitle))
        return self.init(view: view, config: config)
    }
    
    public static func `default`(
        image: UIImage,
        imageTint: UIColor? = .label,
        title: String,
        subtitle: String?,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(
            child: IconAppleToastView(image: image, imageTint: imageTint, title: title, subtitle: subtitle)
        )
        return self.init(view: view, config: config)
    }
    
    public static func custom(
        view: ToastView,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return self.init(view: view, config: config)
    }
    
    public required init(view: ToastView, config: ToastConfiguration) {
        self.config = config
        self.view = view
    
        config.view?.addSubview(view) ?? topController()?.view.addSubview(view)
        
        view.viewDidLoad()
        
        setupGestureRecognizers()
        
        view.transform = initialTransform
    }
    
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    public func show(after delay: TimeInterval = 0) {
        guard !isVisible else { return }
        
        UIView.animate(withDuration: config.animationTime, delay: delay, options: .curveEaseOut) {
            self.view.transform = .identity
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
    
    public func close(after time: TimeInterval = 0, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: config.animationTime, delay: time, options: .curveEaseIn, animations: {
            self.view.transform = self.initialTransform
        }, completion: { _ in
            self.isVisible = false
            
            if self.config.removeFromView {
                self.remove()
            }
            
            completion?()
        })
    }
    
    public func remove() {
        view.removeFromSuperview()
    }
    
    @objc private func executeOnTapHandler() {
        config.onTap?(self)
    }
    
    private func setupGestureRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(executeOnTapHandler)))
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(close as () -> Void))
        swipeUpGestureRecognizer.direction = .up
        
        view.addGestureRecognizer(swipeUpGestureRecognizer)
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
