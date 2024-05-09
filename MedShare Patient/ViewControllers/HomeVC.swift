//
//  HomeVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 09/05/24.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    //MARK: Outlets
    @IBOutlet weak var btnFindHospitals: UIButton!
    @IBOutlet weak var clcSpeciality: UICollectionView!
    @IBOutlet weak var clcHospitals: UICollectionView!
    
    //MARK: Variables
    var doctorsArr = [["title":"Dentist","image":"tooth"], ["title":"Cardiologist","image":"heart"], ["title":"Orthopaedic","image":"spine"],["title":"Neurologist","image":"brain"]]
    var hospitalArr = [["Name" : "Hospital 1","Location" : "Vadodara","Latitude" : 0.00,"Longitude" : 0.00,"hospitalType" : "Dentist"], ["Name" : "Hospital 2","Location" : "Vadodara","Latitude" : 0.00,"Longitude" : 0.00,"hospitalType" : "Dentist"]]
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFindHospitals.layer.cornerRadius = btnFindHospitals.frame.size.height/2
        btnFindHospitals.layer.masksToBounds = true
        btnFindHospitals.layer.shadowColor = UIColor.black.cgColor
        btnFindHospitals.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnFindHospitals.layer.shadowRadius = 10
        btnFindHospitals.layer.shadowOpacity = 0.25
        btnFindHospitals.clipsToBounds = false
        
        clcSpeciality.delegate = self
        clcSpeciality.dataSource = self
        
        clcHospitals.delegate = self
        clcHospitals.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: Button methods
    @IBAction func btnFindHospitals(_ sender: Any) {
    }
    
    //MARK: Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clcSpeciality{
            return doctorsArr.count
        }
        return hospitalArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clcSpeciality{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "specialityCell", for: indexPath) as! SpecialityCell
            cell.imgSpeciality.image = UIImage(named: doctorsArr[indexPath.row]["image"]!)
            cell.viewBack.layer.cornerRadius = cell.viewBack.frame.size.height/2
            cell.viewBack.layer.masksToBounds = true
            cell.lblSpeciality.text = doctorsArr[indexPath.row]["title"]!
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityHospitalCell", for: indexPath) as! CityHospitalCell
            cell.viewBackground.layer.cornerRadius = 20
            cell.viewBackground.layer.masksToBounds = true
            
            cell.btnAppointment.makeButtonRoundWithShadow()
            
            cell.btnDirections.makeButtonRoundWithShadow()
            
            cell.lblName.text = hospitalArr[indexPath.row]["Name"] as? String
            cell.lblLocation.text = hospitalArr[indexPath.row]["Location"] as? String
            cell.lblDocType.text = "Type: \(hospitalArr[indexPath.row]["hospitalType"] as? String ?? "")"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clcSpeciality{
            return CGSize(width: 75, height: 110)
        }
        return CGSize(width: 270, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    
}

