//
//  MedicalInfoRegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit
import FirebaseAuth
class MedicalInfoRegisterVC: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtAllergies: UITextField!
    @IBOutlet weak var txtBloodGroup: UITextField!
    
    @IBOutlet weak var txtInsurance: UITextField!
  
    @IBOutlet weak var btnRegister: UIButton!
    
    //MARK: Variables
    var medAppUser: MedAppUser?
    var userCredentials = [String:String]()
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        guard let age = txtAge.text,
              let gender = txtGender.text,
              let height = txtHeight.text,
              let weight = txtWeight.text,
              let allergies = txtAllergies.text,
              let bloodGrp = txtBloodGroup.text,
              let insurance = txtInsurance.text else{
            return
        }
        if age.isEmpty{
            showToastAlert(strmsg: "Age field cannot be blank", preferredStyle: .alert)
        }
        else if gender.isEmpty{
            showToastAlert(strmsg: "Gender field cannot be blank", preferredStyle: .alert)
        }
        else if height.isEmpty{
            showToastAlert(strmsg: "Height field cannot be blank", preferredStyle: .alert)
        }
        else if weight.isEmpty{
            showToastAlert(strmsg: "Weight field cannot be blank", preferredStyle: .alert)
        }
        else if allergies.isEmpty{
            showToastAlert(strmsg: "Allergies field cannot be blank", preferredStyle: .alert)
        }
        else if bloodGrp.isEmpty{
            showToastAlert(strmsg: "Blood Group field cannot be blank", preferredStyle: .alert)
        }
        else if insurance.isEmpty{
            showToastAlert(strmsg: "Insurance field cannot be blank", preferredStyle: .alert)
        }
        else{
//            medAppUser?.email = medAppUser?.safeEmail ?? ""
            medAppUser?.age = Int(age) ?? 0
            medAppUser?.gender = gender
            medAppUser?.height = height
            medAppUser?.weight = Int(weight) ?? 0
            medAppUser?.allergies = allergies
            medAppUser?.bloodGrp = bloodGrp
            medAppUser?.insurance = insurance == "yes" ? true : false
            DatabaseManager.shared.userExists(with: medAppUser?.email ?? "", completion: {[weak self] exists in
                guard let strongSelf = self else {
                    return
                }
//                DispatchQueue.main.async {
//                    strongSelf.spinner.dismiss()
//                }
                guard !exists else{
                    //TODO: Insert Alert
                    print("user already exists")
                    return
                }
                FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.userCredentials["email"] ?? "", password: strongSelf.userCredentials["pass"] ?? "",completion: {authResult, error in
                    guard  authResult != nil, error == nil else{
                        print("Error creating user")
                        return
                    }
                    guard let medAppUser = strongSelf.medAppUser else{
                        return
                    }
                    
                    DatabaseManager.shared.insertUser(with: medAppUser, completion: {success in
                        if success
                        {
                            strongSelf.showToastAlert(strmsg: "User Created Success", preferredStyle: .alert)
                        }
                    })
//                    UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
//                    UserDefaults.standard.set(strongSelf.txtName.text ?? "", forKey: "name")
//                    strongSelf.navigationController?.dismiss(animated: true)
                })
            })

        }
    }
}
