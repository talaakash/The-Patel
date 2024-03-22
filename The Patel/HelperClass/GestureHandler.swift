////
////  GestureHandler.swift
////  The Patel
////
////  Created by Akash on 21/03/24.
////
//
//import Foundation
//import UIKit
//
//class GestureHandler{
//    static let gesture = GestureHandler()
//    
//    var imageView: UIImageView!
//    var originalImage: UIImage? // Original image
//    
//    private init(){ }
//    
//    func setGesture(){
//        
//    }
//    
//    @objc func imageTapped() {
//        let zoomedImageView = UIImageView(image: originalImage)
//        zoomedImageView.contentMode = .scaleAspectFit
//        let scrollView = UIScrollView(frame: view.bounds)
//        scrollView.delegate = self
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 6.0
//        scrollView.zoomScale = 1.0
//        scrollView.addSubview(zoomedImageView)
//        scrollView.contentSize = zoomedImageView.bounds.size
//        view.addSubview(scrollView)
//    }
//    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews.first
//    }
//}
