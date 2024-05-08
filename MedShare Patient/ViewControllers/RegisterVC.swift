//
//  RegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit

class RegisterVC: UIViewController {
    
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

        // Do any additional setup after loading the view.
    }
    
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
            vc.medAppUser = MedAppUser(name: name, email: email, mobileNumber: mobile, age: 0, gender: "", height: "", weight: 0, allergies: "", bloodGrp: "", insurance: false)
            vc.userCredentials = ["email" : email,"pass" : pass]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
