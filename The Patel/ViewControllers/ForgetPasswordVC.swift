//
//  ForgetPasswordVC.swift
//  The Patel
//
//  Created by Akash on 20/03/24.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPassword(_ sender: UIButton){
        guard let email = txtEmail.text else { self.view.makeToast(ErrorKey.invalidDetails); return}
        if !email.validateInput(type: .email){
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        ProgressBar.shared.show()
        FirebaseAuthManager.shared.resetPassword(email: email, complationHandler: { status, error in
            ProgressBar.shared.hide()
            if status == true{
                self.navigationController?.popViewController(animated: true)
                let alert = UIAlertController(title: AlertBox.title, message: AlertBox.mailSended, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: AlertBox.action, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else { self.view.makeToast(error) }
        })
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }


}
