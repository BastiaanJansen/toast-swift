//
//  Toast.swift
//  Toast
//
//  Created by Bastiaan Jansen on 27/06/2021.
//

import UIKit

public class Toast {
    
    public let view: ToastView
        
    private var closeTimer: Timer?
    
    /// This is for pan gesture to close.
    private var startY: CGFloat = 0
    private var startShiftY: CGFloat = 0
    
    public static var defaultImageTint: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }

    private var multicast = MulticastDelegate<ToastDelegate>()
    
    private let config: ToastConfiguration
    
    private(set) var direction: Direction
    
    /// Creates a new Toast with the default Apple style layout with a title and an optional subtitle.
    /// - Parameters:
    ///   - title: Attributed title which is displayed in the toast view
    ///   - subtitle: Optional attributed subtitle which is displayed in the toast view
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func text(
        _ title: NSAttributedString,
        subtitle: NSAttributedString? = nil,
        viewConfig: ToastViewConfiguration = ToastViewConfiguration(),
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(child: TextToastView(title, subtitle: subtitle), config: viewConfig)
        return self.init(view: view, config: config)
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
        viewConfig: ToastViewConfiguration = ToastViewConfiguration(),
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(child: TextToastView(title, subtitle: subtitle), config: viewConfig)
        return self.init(view: view, config: config)
    }
    
    /// Creates a new Toast with the default Apple style layout with an icon, title and optional subtitle.
    /// - Parameters:
    ///   - image: Image which is displayed in the toast view
    ///   - imageTint: Tint of the image
    ///   - title: Attributed title which is displayed in the toast view
    ///   - subtitle: Optional attributed subtitle which is displayed in the toast view
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func `default`(
        image: UIImage,
        imageTint: UIColor? = defaultImageTint,
        title: NSAttributedString,
        subtitle: NSAttributedString? = nil,
        viewConfig: ToastViewConfiguration = ToastViewConfiguration(),
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(
            child: IconAppleToastView(image: image, imageTint: imageTint, title: title, subtitle: subtitle),
            config: viewConfig
        )
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
        imageTint: UIColor? = defaultImageTint,
        title: String,
        subtitle: String? = nil,
        viewConfig: ToastViewConfiguration = ToastViewConfiguration(),
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = AppleToastView(
            child: IconAppleToastView(image: image, imageTint: imageTint, title: title, subtitle: subtitle),
            config: viewConfig
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
        self.direction = config.direction
                
        if config.enablePanToClose {
            enablePanToClose()
        }
    }
    
#if !os(tvOS)
    /// Show the toast with haptic feedback
    /// - Parameters:
    ///   - type: Haptic feedback type
    ///   - time: Time after which the toast is shown
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
#endif
    
    /// Show the toast
    /// - Parameter delay: Time after which the toast is shown
    public func show(after delay: TimeInterval = 0) {
        config.view?.addSubview(view) ?? topController()?.view.addSubview(view)
        view.createView(for: self)
        
        multicast.invoke { $0.willShowToast(self) }

        config.enteringAnimation.apply(to: self.view)
        UIView.animate(withDuration: config.animationTime, delay: delay, options: [.curveEaseOut, .allowUserInteraction]) {
            self.config.enteringAnimation.undo(from: self.view)
        } completion: { [self] _ in
            multicast.invoke { $0.didShowToast(self) }
            closeTimer = Timer.scheduledTimer(withTimeInterval: .init(config.displayTime), repeats: false) { [self] _ in
                if config.autoHide {
                    close()
                }
            }
        }
    }
    
    /// Close the toast
    /// - Parameters:
    ///   - completion: A completion handler which is invoked after the toast is hidden
    public func close(completion: (() -> Void)? = nil) {
        multicast.invoke { $0.willCloseToast(self) }

        UIView.animate(withDuration: config.animationTime,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
            self.config.exitingAnimation.apply(to: self.view)
        }, completion: { _ in
            self.view.removeFromSuperview()
            completion?()
            self.multicast.invoke { $0.didCloseToast(self) }
        })
    }
    
    public func addDelegate(delegate: ToastDelegate) -> Void {
        multicast.add(delegate)
    }
    
    private func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    private func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else {
                    continue
                }
                if windowScene.windows.isEmpty {
                    continue
                }
                guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                    continue
                }
                return window
            }
            return nil
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Toast {
    private func enablePanToClose() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(toastOnPan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc private func toastOnPan(_ gesture: UIPanGestureRecognizer) {
        guard let topVc = topController() else {
            return
        }
        
        switch gesture.state{
        case .began:
            startY = self.view.frame.origin.y
            startShiftY = gesture.location(in: topVc.view).y
            closeTimer?.invalidate()
        case .changed:
            let delta = gesture.location(in: topVc.view).y - startShiftY
            switch direction {
            case .top:
                if delta <= 0 {
                    self.view.frame.origin.y = startY + delta
                }
            case .bottom:
                if delta >= 0 {
                    self.view.frame.origin.y = startY + delta
                }
            }
        case .ended:
            let threshold = 15.0 // if user drags more than threshold the toast will be dismissed
            let ammountOfUserDragged = abs(startY - self.view.frame.origin.y)
            let shouldDismissToast = ammountOfUserDragged > threshold
            
            if shouldDismissToast {
                close()
            } else {
                UIView.animate(withDuration: config.animationTime, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                    self.view.frame.origin.y = self.startY
                } completion: { [self] _ in
                    closeTimer = Timer.scheduledTimer(withTimeInterval: .init(config.displayTime), repeats: false) { [self] _ in
                        if config.autoHide {
                            close()
                        }
                    }
                }
            }
            
        case .cancelled, .failed:
            closeTimer = Timer.scheduledTimer(withTimeInterval: .init(config.displayTime), repeats: false) { [self] _ in
                if config.autoHide {
                    close()
                }
            }
        default:
            break
        }
    }
    
    func enableTapToClose() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toastOnTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func toastOnTap(_ gesture: UITapGestureRecognizer) {
        closeTimer?.invalidate()
        close()
    }
}
