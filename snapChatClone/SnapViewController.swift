//
//  SnapViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/6/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SnapViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //firebase
       let currUser = Auth.auth().currentUser!.uid
        Database.database().reference().child("users").child(currUser).child("snaps").observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            
            let snap = Snap()
            let value = snapshot.value as? NSDictionary
            
            snap.imgURL = value?["imgURL"] as? String ?? ""
            snap.message = value?["message"] as? String ?? ""
            snap.from = value?["from"] as? String ?? ""
            snap.key = snapshot.key
            snap.uuid = value?["uuid"] as? String ?? ""
    
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        }
        
        Database.database().reference().child("users").child(currUser).child("snaps").observe(DataEventType.childRemoved) { (snapshot) in
            print(snapshot)
            
            var index = 0
            for snap in self.snaps{
                if(snap.key == snapshot.key){
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (snaps.isEmpty){
            return 1
        }
        else{
            return snaps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
        
        if(snaps.isEmpty){
            cell.textLabel?.text = "no new snaps 😔"
            tableView.isUserInteractionEnabled = false
            
        }
        else{
            tableView.isUserInteractionEnabled = true
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!snaps.isEmpty){
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "selectSnapSegue", sender: snap)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectSnapSegue"){
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
        }
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutTapped(_ sender: Any) {
        //when logout is tapped dismiss
        dismiss(animated: true, completion: nil)
    }
 

}
