//
//  ViewController.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var gifView: SDAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let animatedLogo = SDAnimatedImage(named: "MedSharePatientGIF.gif")
        gifView.image = animatedLogo
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // your code here
            let user = FirebaseAuth.Auth.auth().currentUser
            
            if user != nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarStory")
                UIApplication.shared.windows.first?.rootViewController = vc
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationStory")
                UIApplication.shared.windows.first?.rootViewController = vc
            }
           
        }
    }


}

