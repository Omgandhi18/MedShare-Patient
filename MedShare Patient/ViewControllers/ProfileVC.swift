//
//  ProfileVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 12/05/24.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var btnViewEdit: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
