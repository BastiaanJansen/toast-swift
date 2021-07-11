//
//  TextToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class TextToastView : UIStackView {
    public init(_ title: String, subtitle: String? = nil) {
        super.init(frame: CGRect.zero)
        axis = .vertical
        alignment = .center
        distribution = .fillEqually
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 1
        addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .systemGray
            subtitleLabel.text = subtitle
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            addArrangedSubview(subtitleLabel)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
