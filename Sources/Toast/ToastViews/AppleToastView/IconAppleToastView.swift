//
//  DefaultToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class IconAppleToastView : UIStackView {
    
    private let action: (() -> Void)?
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        UILabel()
    }()
    
    private lazy var subtitleLabel: UILabel = {
        UILabel()
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(actionButtonPressed(_ :)), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "SystemBlue"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    public static var defaultImageTint: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    public init(
        image: UIImage,
        imageTint: UIColor? = defaultImageTint,
        title: NSAttributedString,
        subtitle: NSAttributedString? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        viewConfig: ToastViewConfiguration
    ) {
        
        self.action = action
        super.init(frame: CGRect.zero)
        commonInit()
        
        
        self.titleLabel.attributedText = title
        self.titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        self.vStack.addArrangedSubview(self.titleLabel)
        
        if let subtitle = subtitle {
            self.subtitleLabel.attributedText = subtitle
            self.subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            self.vStack.addArrangedSubview(self.subtitleLabel)
        }
        
        self.imageView.image = image
        self.imageView.tintColor = imageTint
        
        addArrangedSubview(self.imageView)
        addArrangedSubview(self.vStack)
        
        if let actionTitle = actionTitle {
            setCustomSpacing(25, after: self.vStack)
            self.actionButton.setTitle(actionTitle, for: .normal)
            addArrangedSubview(self.actionButton)
            setCustomSpacing(15, after: self.actionButton)
        }
    }
    
    public init(image: UIImage,
                imageTint: UIColor? = defaultImageTint,
                title: String,
                subtitle: String? = nil,
                actionTitle: String? = nil,
                action: (() -> Void)? = nil,
                viewConfig: ToastViewConfiguration) {
        
        self.action = action
        super.init(frame: CGRect.zero)
        
        commonInit()
        
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        self.titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        self.vStack.addArrangedSubview(self.titleLabel)
        
        if let subtitle = subtitle {
            self.subtitleLabel.textColor = .systemGray
            self.subtitleLabel.text = subtitle
            self.subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            self.subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            self.vStack.addArrangedSubview(self.subtitleLabel)
        }
        
        self.imageView.image = image
        self.imageView.tintColor = imageTint
        
        addArrangedSubview(self.imageView)
        addArrangedSubview(self.vStack)
        
        if let actionTitle = actionTitle {
            setCustomSpacing(25, after: self.vStack)
            self.actionButton.setTitle(actionTitle, for: .normal)
            addArrangedSubview(self.actionButton)
            setCustomSpacing(15, after: self.actionButton)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .fill
    }
    
    @objc private func actionButtonPressed(_ sender: UIButton) {
        action?()
    }
}
