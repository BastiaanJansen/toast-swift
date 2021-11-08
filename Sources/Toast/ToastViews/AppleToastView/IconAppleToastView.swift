//
//  DefaultToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class IconAppleToastView : UIStackView {
    public static var defaultImageTint: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    public init(image: UIImage, imageTint: UIColor? = defaultImageTint, title: String, subtitle: String? = nil) {
        super.init(frame: CGRect.zero)
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .fill
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 2
        vStack.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 1
        vStack.addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .systemGray
            subtitleLabel.text = subtitle
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            vStack.addArrangedSubview(subtitleLabel)
        }
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = imageTint
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        addArrangedSubview(imageView)
        addArrangedSubview(vStack)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
