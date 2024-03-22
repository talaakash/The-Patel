//
//  WebViewingVC.swift
//  The Patel
//
//  Created by Akash on 22/03/24.
//

import UIKit
import WebKit

class WebViewingVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup(){
        let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
        webView.load(request)
        
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
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
