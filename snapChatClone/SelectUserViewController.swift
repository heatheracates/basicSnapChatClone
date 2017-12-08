//
//  SelectUserViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/6/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    var message = ""
    var imgURL = ""
    var from = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //firebase loading in all users in DB and putting in array to populate table with
        Database.database().reference().child("users").observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            
            let user = User()
            let value = snapshot.value as? NSDictionary
            
            user.email = value?["email"] as? String ?? ""
            user.uid = snapshot.key
            
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let snap = ["from":from, "message":message, "imgURL":imgURL, "uuid":uuid]
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        //send them back to main page once sent
        navigationController!.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
