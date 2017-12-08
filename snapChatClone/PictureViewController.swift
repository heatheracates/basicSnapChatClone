//
//  PictureViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/6/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
       imagePicker.delegate = self
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        nextButton.isEnabled = true
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        nextButton.isEnabled = false
        let imagesFolder = Storage.storage().reference().child("images")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        //loading indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
       activityIndicator.color = UIColor.darkGray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //push to firebase
        imagesFolder.child("\(uuid).jpeg").putData(imageData, metadata: nil) { (metadata, error) in
            if(error != nil){
                print("we had an error in uploading to firebase: \(error!)")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()            }
            else{
                print("upload to firebase successful")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        }
        
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        //imagePicker.sourceType  = .savedPhotosAlbum
        //imagePicker.allowsEditing = false
        //present(imagePicker, animated: true, completion: nil)
        
        imagePicker.sourceType  = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func filmTapped(_ sender: Any) {
        imagePicker.sourceType  = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imgURL = sender as! String
        nextVC.from = (Auth.auth().currentUser?.email!)!
        nextVC.message = messageTextField.text!
        nextVC.uuid = uuid
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
