//
//  SignInControl.swift
//  Sakaly
//
//  Created by mina sameh on 5/10/20.
//  Copyright © 2020 mina sameh. All rights reserved.
//

import UIKit
import Firebase

class SignInControl: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        passwordTxtField.borderStyle = .none
        passwordTxtField.backgroundColor = .clear
        passwordTxtField.setUnderLine()
        passwordTxtField.isSecureTextEntry = true
        passwordTxtField.text = "11111Aa@"
        
        
        
        emailTxtField.borderStyle = .none
        emailTxtField.backgroundColor = .clear
        emailTxtField.setUnderLine()
        emailTxtField.text = "a@a.com"
    }
    
    func AlertMessage(_ message : String) {
        let alert = UIAlertController(title: "Wait !!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToMainScreen() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreen") as! MainScreen
        mainVC.useeEmail = emailTxtField.text!
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func checkFields()-> Bool{
        if emailTxtField.text?.count == 0 {
            AlertMessage("You must fill email field")
            return false
        } else if passwordTxtField.text?.count == 0 {
            AlertMessage("You must fill password field")
            return false
        }
        
        return true
    }

    @IBAction func LogInBTN(_ sender: Any) {
        
        if checkFields() {
            let email = emailTxtField.text!
            let password = passwordTxtField.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    self.goToMainScreen()
                }
                else {
                    self.AlertMessage(error?.localizedDescription ?? "error")
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
