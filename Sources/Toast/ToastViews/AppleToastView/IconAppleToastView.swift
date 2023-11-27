//
//  DefaultToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class IconAppleToastView : UIStackView {
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
        viewConfig: ToastViewConfiguration
    ) {
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
    }

    public init(image: UIImage, imageTint: UIColor? = defaultImageTint, title: String, subtitle: String? = nil, viewConfig: ToastViewConfiguration) {
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
}
