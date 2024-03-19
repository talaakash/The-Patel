//
//  PasswordTextField.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import Foundation
import UIKit

class PasswordTextField: UITextField{
    private let eyeButton = UIButton(type: .custom)
        
        @IBInspectable var showPasswordButton: Bool = false {
            didSet {
                setupEyeButton()
            }
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            setupEyeButton()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupEyeButton()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupEyeButton()
        }
        
        private func setupEyeButton() {
            guard showPasswordButton else {
                rightViewMode = .never
                return
            }
            
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            eyeButton.tintColor = .systemGray
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            rightView = eyeButton
            rightViewMode = .always
        }
        
        @objc private func togglePasswordVisibility() {
            isSecureTextEntry.toggle()
            eyeButton.setImage(UIImage(systemName: isSecureTextEntry ? ImagesKey.eye : ImagesKey.eyeSlash), for: .normal)
        }
}
