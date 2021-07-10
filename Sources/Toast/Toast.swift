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
        
    /// Creates a new Toast with the default Apple style layout with a title and an optional subtitle.
    /// - Parameters:
    ///   - title: Title which is displayed in the toast view
    ///   - subtitle: Optional subtitle which is displayed in the toast view
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func text(
        _ title: String,
        subtitle: String? = nil,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(child: TextToastView(title, subtitle: subtitle))
        return self.init(view: view, config: config)
    }
    
    /// Creates a new Toast with the default Apple style layout with an icon, title and optional subtitle.
    /// - Parameters:
    ///   - image: Image which is displayed in the toast view
    ///   - imageTint: Tint of the image
    ///   - title: Title which is displayed in the toast view
    ///   - subtitle: Optional subtitle which is displayed in the toast view
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
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
    
    /// Creates a new Toast with a custom view
    /// - Parameters:
    ///   - view: A view which is displayed when the toast is shown
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func custom(
        view: ToastView,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return self.init(view: view, config: config)
    }
    
    /// Creates a new Toast with a custom view
    /// - Parameters:
    ///   - view: A view which is displayed when the toast is shown
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public required init(view: ToastView, config: ToastConfiguration) {
        self.config = config
        self.view = view
    
        config.view?.addSubview(view) ?? topController()?.view.addSubview(view)
        
        view.viewDidLoad()
        
        setupGestureRecognizers()
        
        view.transform = initialTransform
    }
    
    /// Show the toast with haptic feedback
    /// - Parameters:
    ///   - type: Haptic feedback type
    ///   - time: Time after which the toast is shown
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    /// Show the toast
    /// - Parameter delay: Time after which the toast is shown
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
    
    /// Close the toast
    /// - Parameters:
    ///   - time: Time after which the toast will be closed
    ///   - completion: A completion handler which is invoked after the toast is hidden
    @objc public func close(after time: TimeInterval = 0, completion: (() -> Void)? = nil) {
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
    
    /// Remove the toast view from the superview. When invoked, the toast cannot be shown again and the reference to this object should be destroyed.
    public func remove() {
        view.removeFromSuperview()
    }
    
    @objc private func executeOnTapHandler() {
        config.onTap?(self)
    }
    
    private func setupGestureRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(executeOnTapHandler)))
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: view, action: #selector(close as (TimeInterval, (() -> Void)?) -> Void))
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
