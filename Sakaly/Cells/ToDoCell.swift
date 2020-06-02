//
//  ToDoCell.swift
//  Sakaly
//
//  Created by mina sameh on 5/12/20.
//  Copyright © 2020 mina sameh. All rights reserved.
//

import UIKit
import Firebase

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var dateTxtField: UILabel!
    @IBOutlet weak var contentLAbel: UILabel!
    var documentId : String!
    var userEmail : String!

    
    func configure(_ ToDoObject : ToDo , _ docId : String , _ useremail : String) {
        dateTxtField.text = ToDoObject.date
        contentLAbel.text = ToDoObject.toDoData
        documentId = docId
        userEmail = useremail

    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        deleteImage?.isUserInteractionEnabled = true
        deleteImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let db = Firestore.firestore()
        db.collection(userEmail!).document(documentId!).delete()
        print(userEmail!)
    }
}
