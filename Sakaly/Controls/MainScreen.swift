//
//  MainScreen.swift
//  Sakaly
//
//  Created by mina sameh on 5/10/20.
//  Copyright © 2020 mina sameh. All rights reserved.
//

import UIKit
import Firebase

class MainScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barTitle: UIBarButtonItem!
    
    var useeEmail : String!
    var newToDo = ToDo(date: "", toDoData: "")
    var ToDoList = [ToDo]()
    var docmentsId = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation()
        register()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = #colorLiteral(red: 0.6750035401, green: 0.0819641741, blue: 0.8782915609, alpha: 1)
        reloadData()
    }
    
    func reloadData() {
        let db = Firestore.firestore()
        db.collection(useeEmail).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ToDoList.removeAll()
                for document in querySnapshot!.documents {
                    self.docmentsId.append(document.documentID)
                    let data = document.data()
                    self.newToDo.date = data["date"] as! String
                    self.newToDo.toDoData = data["content"] as! String
                    self.ToDoList.append(self.newToDo)
                }
                self.tableView.reloadData()
            }
        }
    }
    
   /* func reloadData() {
        let db = Firestore.firestore()
        db.collection(useeEmail).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.docmentsId.append(document.documentID)
                    let data = document.data()
                    self.newToDo.date = data["date"] as! String
                    self.newToDo.toDoData = data["content"] as! String
                    self.ToDoList.append(self.newToDo)
                }
                self.tableView.reloadData()
            }
        }
    } */
    
    func register (){
        let nib = UINib.init(nibName: "ToDoCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ToDoCell")
    }
    
    func getUserInformation() {
        let db = Firestore.firestore()
        let docRef = db.collection("usersInformation").document(useeEmail)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let username = document.data()?["username"] else {return}
                self.barTitle.title = "\(username)"
            } else {
                print("Document does not exist")
            }
        }
    }
    
  
    
    func goToPopUpScreen(){
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpConroll") as! PopupControll
        mainVC.userEmail = useeEmail
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func goToSignInScreen(){
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as! SignInControl
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func AlertMessage(_ message : String) {
        let alert = UIAlertController(title: "What To Do ", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func BackBarButtonAction(_ sender: Any) {
        goToSignInScreen()
    }
    
    @IBAction func AddBarButtonAction(_ sender: Any) {
        goToPopUpScreen()
    }
}

extension MainScreen : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        cell.configure(ToDoList[indexPath.row] , docmentsId[indexPath.row] , useeEmail)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertMessage(ToDoList[indexPath.row].toDoData)
    }
    
}
