//
//  HomeVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 09/05/24.
//

import UIKit
import CoreLocation
import FirebaseDatabase
class HomeVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, DataDelegate{
    

    //MARK: Outlets
    @IBOutlet weak var btnFindHospitals: UIButton!
    @IBOutlet weak var clcSpeciality: UICollectionView!
    @IBOutlet weak var clcHospitals: UICollectionView!
    
    //MARK: Variables
    var doctorsArr = [["title":"Dentist","image":"tooth"], ["title":"Cardiologist","image":"heart"], ["title":"Orthopaedic","image":"spine"],["title":"Neurologist","image":"brain"]]
    var hospitalArr = [[String:Any]]()
    public var location: CLLocationCoordinate2D?
    public var userLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    let database = Database.database().reference()
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
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
               
            }
        }
        getHospitals()
        
        // Do any additional setup after loading the view.
    }
    func getHospitals(){
        database.child("hospitals").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                print(DatabaseManager.DatabaseError.failedToFetch)
                return
            }
            hospitalArr = value
           
            clcHospitals.delegate = self
            clcHospitals.dataSource = self
            clcHospitals.reloadData()
        })
    }
    //MARK: Button methods
    @IBAction func btnFindHospitals(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapStory") as! MapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func makeAppointment(_ sender: UIButton){
        
        let data = hospitalArr[sender.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "makeAppointmentStory") as! MakeAppointmentVC
        vc.hospitalData = data
        self.navigationController?.pushViewController(vc, animated: true)
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
            
            cell.btnAppointment.tag = indexPath.row
            cell.btnAppointment.addTarget(self, action: #selector(makeAppointment(_:)), for: .touchUpInside)
            
            let address = hospitalArr[indexPath.row]["address"] as? [String:Any]
            cell.lblName.text = hospitalArr[indexPath.row]["hospital_name"] as? String
            cell.lblLocation.text = "\(address?["address_line_1"] as? String ?? ""), \(address?["city"] as? String ?? "")"
            cell.lblDocType.text = "Type: \(hospitalArr[indexPath.row]["type"] as? String ?? "")"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clcHospitals{
            let selectedHospital = hospitalArr[indexPath.row]
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalDetailsStory") as! HospitalDetailsVC
            viewController.hospitalData = selectedHospital
            viewController.delegate = self
            viewController.userLocation = CLLocation(latitude: locationManager.location?.coordinate.latitude ?? 0.00, longitude: locationManager.location?.coordinate.longitude ?? 0.00)
            
            if let presentationController = viewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium(),.large()]
            }
            
            self.present(viewController, animated: true)
        }
    }
    func sendData(data: [String : Any], isAppointment: Bool) {
        if isAppointment{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "makeAppointmentStory") as! MakeAppointmentVC
            vc.hospitalData = data
            self.navigationController?.pushViewController(vc, animated: true)
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

