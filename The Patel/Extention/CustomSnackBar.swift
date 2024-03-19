//
//  CustomSnackBar.swift
//  The Patel
//
//  Created by Akash on 28/02/24.
//

import Foundation
import SnackBar_swift

class CSnackBar : SnackBar{
    static let bar = CSnackBar(coder: NSCoder())
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .red
        style.textColor = .green
        return style
    }
    
    func showError(inside: UIView,message: String){
        CSnackBar.make(in: inside, message: message, duration: .lengthShort).show()
    }
}
