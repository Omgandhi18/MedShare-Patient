//
//  DatabaseManager.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    public func insertUser(with user: MedAppUser,completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue(["full_name" : user.name,
                                                 "mobile_number" : user.mobileNumber,
                                                 "medical_info" : ["age" : user.age,
                                                                   "gender" : user.gender,
                                                                   "height" : user.height,
                                                                   "weight" : user.weight,
                                                                   "allergies" : user.allergies,
                                                                   "blood_group" : user.bloodGrp,
                                                                   "have_insurance" : user.insurance]
                                                ],withCompletionBlock: {[weak self] error, _ in
            guard let strongSelf  = self else{
                return
            }
            guard error == nil else{
                completion(false)
                return
            }
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:Any]]{
                    let newElement = [
                        "email": user.safeEmail,
                        "full_name" : user.name,
                        "mobile_number" : user.mobileNumber,
                        "medical_info" : ["age" : user.age,
                                          "gender" : user.gender,
                                          "height" : user.height,
                                          "weight" : user.weight,
                                          "allergies" : user.allergies,
                                          "blood_group" : user.bloodGrp,
                                          "have_insurance" : user.insurance]
                    ]
                    usersCollection.append(newElement)
                    strongSelf.database.child("users").setValue(usersCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                        
                    })
                }
                else{
                    let newCollection:[[String: Any]] = [
                        [
                            "email": user.safeEmail,
                            "full_name" : user.name,
                            "mobile_number" : user.mobileNumber,
                            "medical_info" : ["age" : user.age,
                                              "gender" : user.gender,
                                              "height" : user.height,
                                              "weight" : user.weight,
                                              "allergies" : user.allergies,
                                              "blood_group" : user.bloodGrp,
                                              "have_insurance" : user.insurance]
                        ]
                    ]
                    strongSelf.database.child("users").setValue(newCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            return
                        }
                        completion(true)
                        
                    })
                }
            })
            
            
        })
    }
    public func getAllUsers(completion: @escaping (Result<[[String:String]],Error>)->Void){
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String:String]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    public func userExists(with email: String, completion: @escaping ((Bool)-> Void)){
        let safeEmail = DatabaseManager.safeEmail(email: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    public func getDataFor(path: String,completion: @escaping (Result<Any,Error>) -> Void){
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
}
struct MedAppUser{
    var name: String
    var email: String
    var mobileNumber: String
    var age: Int
    var gender: String
    var height: String
    var weight: Int
    var allergies: String
    var bloodGrp: String
    var insurance: Bool
    
    var safeEmail: String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
