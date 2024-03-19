//
//  ProgressBar.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import Foundation
import SVProgressHUD

class ProgressBar{
    static let shared = ProgressBar()
    private init(){
        SVProgressHUD.setDefaultAnimationType(.native)
//        SVProgressHUD.setBackgroundColor(UIColor.clear)
    }
    
    func show(horizontal : CGFloat = 0, vertical: CGFloat = 0, color: UIColor = .black){
        SVProgressHUD.setForegroundColor(color)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: horizontal, vertical: vertical))
        SVProgressHUD.show()
    }
    
    func hide(){
        SVProgressHUD.dismiss()
    }
}
