//
//  ViewSnapViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/7/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class ViewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var snap = Snap()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       messageLabel.text = snap.message
        imageView.sd_setImage(with: URL(string: snap.imgURL) )
        
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.key).removeValue()
        
        Storage.storage().reference().child("images").child("\(snap.uuid).jpeg").delete { (error) in
            print("we deleted the picture")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
