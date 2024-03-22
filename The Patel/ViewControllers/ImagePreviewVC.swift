//
//  ImagePreviewVC.swift
//  The Patel
//
//  Created by Akash on 22/03/24.
//

import UIKit
import Kingfisher

class ImagePreviewVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var previewImagestring: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup(){
        imageView.kf.setImage(with: URL(string: previewImagestring ?? ""))
        imageView.enableZoom()
        
        // Back Gesture
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: false)
    }

}
