//
//  ProfileVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 12/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileVC: UIViewController {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var btnViewEdit: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFullName.layer.cornerRadius = 16
        txtFullName.imageLeftSide(imageName: "User")
        txtFullName.layer.masksToBounds = true
        
        txtMobile.layer.cornerRadius = 16
        txtMobile.imageLeftSide(imageName: "mobile")
        txtMobile.layer.masksToBounds = true
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.imageLeftSide(imageName: "email")
        txtEmail.layer.masksToBounds = true
        
        
        btnLogout.layer.cornerRadius = 25
        btnLogout.layer.masksToBounds = true
        btnLogout.layer.shadowColor = UIColor.black.cgColor
        btnLogout.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnLogout.layer.shadowRadius = 10
        btnLogout.layer.shadowOpacity = 0.25
        btnLogout.clipsToBounds = false
        
        btnViewEdit.layer.cornerRadius = 25
        btnViewEdit.layer.masksToBounds = true
        btnViewEdit.layer.shadowColor = UIColor.black.cgColor
        btnViewEdit.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnViewEdit.layer.shadowRadius = 10
        btnViewEdit.layer.shadowOpacity = 0.25
        btnViewEdit.clipsToBounds = false

    }

    @IBAction func btnViewEdit(_ sender: Any) {
    }
    @IBAction func btnLogout(_ sender: Any) {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationStory")
            UIApplication.shared.windows.first?.rootViewController = vc
        }
        catch{
            print("Error while signing out")
        }
       
    }
    
}
