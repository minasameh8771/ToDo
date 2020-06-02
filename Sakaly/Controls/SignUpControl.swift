//
//  SignUpControl.swift
//  Sakaly
//
//  Created by mina sameh on 5/10/20.
//  Copyright © 2020 mina sameh. All rights reserved.
//

import UIKit
import Firebase


class SignUpControl: UIViewController {
    
    var userData = user(userName: "", password: "", email: "")
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        userNameTxtField.borderStyle = .none
        userNameTxtField.backgroundColor = .clear
        userNameTxtField.setUnderLine()

        
        EmailTxtField.borderStyle = .none
        EmailTxtField.backgroundColor = .clear
        EmailTxtField.setUnderLine()
        
        passwordTxtField.borderStyle = .none
        passwordTxtField.backgroundColor = .clear
        passwordTxtField.setUnderLine()
        passwordTxtField.isSecureTextEntry = true

    }
    
    func validationEmail (_ email : String) -> Bool {
        
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9]+@[a-zA-Z0-9]+.com")
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    func checkForUpperChar (_ password : String) ->Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        return capitalresult
    }
    
    func checkForSpecialChar (_ password : String) -> Bool{
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: password)
        return specialresult
    }
    
    func checkForLowerChar (_ password : String) ->Bool{
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        return capitalresult
    }
    
    func checkForNumber (_ password : String) ->Bool{
        let capitalLetterRegEx  = ".*[1-9]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        return capitalresult
    }
    
    
    func validationPassword (_ password : String) -> Bool {
        
        if password.count < 8 {
            AlertMessage("The password must be more than or equal 8 char")
            return false
        }
        else if !checkForUpperChar(password){
            AlertMessage("The password must be contain at least one upper char")
            return false
        }
        else if !checkForSpecialChar(password){
            AlertMessage("The password must be contain at least one special char")
            return false
        } else if !checkForLowerChar(password){
            AlertMessage("The password must be contain at least one lower char")
            return false
        }else if !checkForNumber(password){
            AlertMessage("The password must be contain at least one Number char")
            return false
        }
        
        return true
    }
    
    
    func ValidationFields () -> Bool {
        
        if userNameTxtField.text?.count == 0 {
            AlertMessage("You must fill username field")
            return false
        } else if EmailTxtField.text?.count == 0 {
            AlertMessage("You must fill email field")
            return false
        } else if passwordTxtField.text?.count == 0 {
            AlertMessage("You must fill password field")
            return false
        }
        
        if !validationEmail(EmailTxtField.text!) {
            AlertMessage("You must enter validation Email")
            return false
        }else if !validationPassword(passwordTxtField.text!) {
            return false
        }
        
        return true
    }
    
    func AlertMessage(_ message : String) {
        let alert = UIAlertController(title: "Wait !!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToMainScreen() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreen") as! MainScreen
        mainVC.useeEmail = userData.email
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func StroreUserInformation() {
        let db = Firestore.firestore()


        db.collection("usersInformation").document(userData.email).setData([
            "username": userData.userName,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added ")
            }
        }
    }
    
    func CreateNewUser(){
        
        guard let email = EmailTxtField.text , let password = passwordTxtField.text
            , let username = userNameTxtField.text else {return}
        
        userData.email = email
        userData.password = password
        userData.userName = username
        
        Auth.auth().createUser(withEmail: userData.email, password: userData.password ) { user, error in
            if error == nil {
                self.StroreUserInformation()
                Auth.auth().signIn(withEmail: self.userData.email, password: self.userData.password) { authResult, error in
                    if error == nil {
                        self.goToMainScreen()
                    }
                    else {
                        self.AlertMessage(error?.localizedDescription ?? "error")
                    }
                }
            }
            else {
                self.AlertMessage(error?.localizedDescription ?? "error")
            }
        }
    }

    
    @IBAction func SignUpBTN(_ sender: Any) {
        if ValidationFields() {
            CreateNewUser()
        }
    }
    
    @IBAction func SignInBTN(_ sender: Any) {
    }

}




