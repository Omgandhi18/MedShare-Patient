//
//  LoginVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit
import FirebaseAuth
class LoginVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblRegisterButton: UILabel!
    
    //MARK: Variables

    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRegisterButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(registerBtn))
        lblRegisterButton.addGestureRecognizer(tap)
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.imageLeftSide(imageName: "User")
        txtEmail.layer.masksToBounds = true
        
        txtPass.layer.cornerRadius = 16
        txtPass.imageLeftSide(imageName: "lock")
        txtPass.layer.masksToBounds = true
        
        btnLogin.layer.cornerRadius = 25
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.shadowColor = UIColor.black.cgColor
        btnLogin.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnLogin.layer.shadowRadius = 10
        btnLogin.layer.shadowOpacity = 0.25
        btnLogin.clipsToBounds = false
    }
    
    
    //MARK: Button methods
    @IBAction func btnLogin(_ sender: Any) {
        guard let email = txtEmail.text,
              let pass = txtPass.text else{
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass,completion: {[weak self] authResult,error in
            guard let strongSelf = self else{
                return
            }
//            DispatchQueue.main.async {
//                strongSelf.spinner.dismiss()
//            }
            guard let result = authResult, error == nil else{
                print("Failed to log in")
                return
            }
            let user = result.user
            let safeEmail = DatabaseManager.safeEmail(email: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: {result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String:Any],
                    let name = userData["full_name"] else{
                        return
                    }
//                    UserDefaults.standard.set(name, forKey: "name")
                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
//            UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
            
            strongSelf.showToastAlert(strmsg: "Logged In successfully", preferredStyle: .alert)
            
//            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            
        })
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarStory")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    @objc func registerBtn(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStory") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
