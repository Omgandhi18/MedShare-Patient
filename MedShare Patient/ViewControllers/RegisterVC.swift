//
//  RegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit

class RegisterVC: UIViewController,UITextFieldDelegate{
    
    //MARK: Outlets
    
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblSignInButton: UILabel!
    //MARK: Variables
    
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFullName.layer.cornerRadius = 16
        txtFullName.imageLeftSide(imageName: "User")
        txtFullName.layer.masksToBounds = true
        
        txtMobile.layer.cornerRadius = 16
        txtMobile.imageLeftSide(imageName: "mobile")
        txtMobile.layer.masksToBounds = true
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.imageLeftSide(imageName: "email")
        txtEmail.layer.masksToBounds = true
        
        txtPass.layer.cornerRadius = 16
        txtPass.imageLeftSide(imageName: "lock")
        txtPass.layer.masksToBounds = true
        
        btnContinue.layer.cornerRadius = 25
        btnContinue.layer.masksToBounds = true
        btnContinue.layer.shadowColor = UIColor.black.cgColor
        btnContinue.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnContinue.layer.shadowRadius = 10
        btnContinue.layer.shadowOpacity = 0.25
        btnContinue.clipsToBounds = false
    }
    //MARK: Button methods
    @IBAction func btnContinue(_ sender: Any) {
        guard let name = txtFullName.text,
              let email = txtEmail.text,
              let pass = txtPass.text,
              let mobile = txtMobile.text else{
            return
        }
        if name.isEmpty{
            showToastAlert(strmsg: "Name field cannot be blank", preferredStyle: .alert)
        }
        else if email.isEmpty{
            showToastAlert(strmsg: "Email field cannot be blank", preferredStyle: .alert)
        }
        else if mobile.isEmpty{
            showToastAlert(strmsg: "Mobile Number field cannot be blank", preferredStyle: .alert)
        }
        else if pass.isEmpty{
            showToastAlert(strmsg: "Password field cannot be blank", preferredStyle: .alert)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicalInfoRegisterStory") as! MedicalInfoRegisterVC
            vc.medAppUser = MedAppUser(name: name, email: email, mobileNumber: mobile, age: "", gender: "", height: "", weight: "", allergies: "", bloodGrp: "", insurance: false)
            vc.userCredentials = ["email" : email,"pass" : pass]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    

}
