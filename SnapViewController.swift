//
//  SnapViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/6/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
