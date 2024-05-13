//
//  MedicalInfoRegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit
import FirebaseAuth
class MedicalInfoRegisterVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    
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
    var pickerArr = [String]()
    var selectedTextField = UITextField()
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAge.layer.cornerRadius = 16
        txtAge.layer.masksToBounds = true
        
        txtGender.layer.cornerRadius = 16
        txtGender.layer.masksToBounds = true
        
        txtHeight.layer.cornerRadius = 16
        txtHeight.layer.masksToBounds = true
        
        txtWeight.layer.cornerRadius = 16
        txtWeight.layer.masksToBounds = true
        
        txtAllergies.layer.cornerRadius = 16
        txtAllergies.layer.masksToBounds = true
        
        txtBloodGroup.layer.cornerRadius = 16
        txtBloodGroup.layer.masksToBounds = true
        
        txtInsurance.layer.cornerRadius = 16
        txtInsurance.layer.masksToBounds = true
       
        btnRegister.layer.cornerRadius = 25
        btnRegister.layer.masksToBounds = true
        btnRegister.layer.shadowColor = UIColor.black.cgColor
        btnRegister.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnRegister.layer.shadowRadius = 10
        btnRegister.layer.shadowOpacity = 0.25
        btnRegister.clipsToBounds = false
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
            medAppUser?.age = age
            medAppUser?.gender = gender
            medAppUser?.height = height
            medAppUser?.weight = weight
            medAppUser?.allergies = allergies
            medAppUser?.bloodGrp = bloodGrp
            medAppUser?.insurance = insurance == "Yes" ? true : false
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
                        let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBarStory")
                        UIApplication.shared.windows.first?.rootViewController = vc
                    })
//                    UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
//                    UserDefaults.standard.set(strongSelf.txtName.text ?? "", forKey: "name")
//                    strongSelf.navigationController?.dismiss(animated: true)
                })
            })
            

        }
    }
    
    //MARK: Textfield methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        if textField == txtAge{
            selectedTextField = txtAge
            var ageArr = [String]()
            for i in 0 ... 100{
                ageArr.append(String(i))
            }
            pickerArr = ageArr
            textField.inputView = pickerView
            
        }
        else if textField == txtGender{
            selectedTextField = txtGender
            pickerArr = ["Male", "Female","Other"]
            textField.inputView = pickerView
            
        }
        else if textField == txtHeight{
            selectedTextField = txtHeight
            var heightArr = [String]()
            for i in 0 ... 300{
                heightArr.append(String(i))
            }
            pickerArr = heightArr
            textField.inputView = pickerView
            
        }
        else if textField == txtWeight{
            selectedTextField = txtWeight
            var weightArr = [String]()
            for i in 0 ... 300{
                weightArr.append(String(i))
            }
            pickerArr = weightArr
            textField.inputView = pickerView
           
        }
        else if textField == txtBloodGroup{
            selectedTextField = txtBloodGroup
            pickerArr = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
            textField.inputView = pickerView
           
        }
        else if textField == txtInsurance{
            selectedTextField = txtInsurance
            pickerArr = ["Yes","No","Don't know"]
            textField.inputView = pickerView
            
        }
        
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField ==  txtAge{
            selectedTextField.text = "\(pickerArr[row]) years"
        }
        else if selectedTextField ==  txtGender{
            selectedTextField.text = "\(pickerArr[row])"
        }
        else if selectedTextField ==  txtHeight{
            selectedTextField.text = "\(pickerArr[row]) cm"
        }
        else if selectedTextField ==  txtWeight{
            selectedTextField.text = "\(pickerArr[row]) kgs"
        }
        else if selectedTextField ==  txtBloodGroup{
            selectedTextField.text = "\(pickerArr[row])"
        }
        else if selectedTextField ==  txtInsurance{
            selectedTextField.text = "\(pickerArr[row])"
        }
    }
    @objc func dismissAction() {
        view.endEditing(true)
    }
}
