//
//  PopupControll.swift
//  Sakaly
//
//  Created by mina sameh on 5/11/20.
//  Copyright © 2020 mina sameh. All rights reserved.
//

import UIKit
import Firebase

class PopupControll: UIViewController {

    @IBOutlet weak var dateAndTimeTxtField: UITextField!
    @IBOutlet weak var contentTxtField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var saveBTN: UIButton!
    
    var userEmail : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        popUpView.layer.cornerRadius = 5
        popUpView.layer.masksToBounds = true
        
        saveBTN.layer.cornerRadius = 5
        saveBTN.layer.masksToBounds = true
        
        dateAndTimeTxtField.borderStyle = .none
        dateAndTimeTxtField.backgroundColor = .clear
        dateAndTimeTxtField.setUnderLine()
        dateAndTimeTxtField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        let imageView = UIImageView();
        let image = UIImage(named: "Arrow");
        imageView.image = image;
        imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 10)
        dateAndTimeTxtField.rightView = imageView
        dateAndTimeTxtField.rightViewMode = UITextField.ViewMode.always
        
        
        contentTxtField.borderStyle = .none
        contentTxtField.backgroundColor = .clear
        contentTxtField.setUnderLine()
        
    }
    
    func AlertMessage(_ message : String) {
        let alert = UIAlertController(title: "Wait !!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkFields()-> Bool{
        if dateAndTimeTxtField.text?.count == 0 {
            AlertMessage("You must fill dateAndTime Field")
            return false
        } else if contentTxtField.text?.count == 0 {
            AlertMessage("You must fill content field")
            return false
        }
        
        return true
    }
    
    func storeData(){
        let db = Firestore.firestore()
        db.collection(userEmail).addDocument(data: [
            "date": dateAndTimeTxtField.text!,
            "content": contentTxtField.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added ")
            }
        }
    }
    
    private func goToMainScreen() {
        if checkFields() {
            storeData()
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreen") as! MainScreen
            mainVC.useeEmail = userEmail!
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        goToMainScreen()
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateAndTimeTxtField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            //dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "yyyy/MM/dd hh:mm a"
            self.dateAndTimeTxtField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateAndTimeTxtField.resignFirstResponder() // 2-5
    }

}
