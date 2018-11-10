//
//  networkManager.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/29/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
class networkManager{
    static let sharedInstance = networkManager()
    var db: Firestore!
    var uploaded : Int? = 0
//Upload methods
    
    //UPLOADING TEXT POSTS
    func putTextPost(post: String ){
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "TextPosts"
        ref = db.collection(userID).document(collectionName)
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.updateData([
                    "post": FieldValue.arrayUnion([post])
                    ])
            } else {
                ref?.setData([
                    "post": FieldValue.arrayUnion([post])
                    ])
            }
        }
        
    }
    
    //Updating image count for user
    func updateimageCount(count :Int, completion : @escaping ()->()){
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        //getting image count for image path
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "ImageCount"
        ref = db.collection(userID).document(collectionName)
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.updateData([
                    "Count": count
                    ])
                completion()
            } else {
                ref?.setData([
                    "Count": count
                    ])
                completion()
            }
        }
    }
    
    //UPLOADING IMAGE POSTS TEXT
    func putImagePostText(post:String, count : Int, completion : () -> ())
    {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        let userID = Auth.auth().currentUser!.uid
        var collectionName = "TextWithImagePosts"
        let postDic = ["Count": count, "post" : post] as [String : Any]
        ref = db.collection(userID).document(collectionName)
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.updateData([
                    "post": FieldValue.arrayUnion([postDic])
                    ])
            } else {
                ref?.setData([
                    "post": FieldValue.arrayUnion([postDic])
                    ])
            }
        }
        collectionName = "ContainsImage"
        ref = db.collection(userID).document(collectionName)
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.updateData([
                    "ContainsImage": FieldValue.arrayUnion([count])
                    ])
            } else {
                ref?.setData([
                    "ContainsImage": FieldValue.arrayUnion([count])
                    ])
            }
        }
        completion()
    }
    
    //Upload image
    func uploadImage(filePath:String, data : NSData, post: String, count: Int?, completion : @escaping ()-> ())
    {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        storageRef.child(filePath).putData(data as Data, metadata: nil){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                
                //UPLOAD TEXT
                self.putImagePostText(post: post, count: count!, completion: {
                    if (self.uploaded == 1)
                    {
                        self.uploaded = 0
                        completion()
                    }
                    else{
                        self.uploaded = 1
                    }
                })
                
                self.updateimageCount(count: count!, completion: {
                    if (self.uploaded == 1)
                    {
                        self.uploaded = 0
                        completion()
                    }
                    else{
                        self.uploaded = 1
                    }
                })
            }
        }
    }
    
    
    // UPLOADING IMAGE POST
    func putImagePost(post:String, postImage : UIImage, completion : @escaping () -> ()){
        var data = NSData()
        data = postImage.jpegData(compressionQuality: 100)! as NSData
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        //getting image count for image path
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "ImageCount"
        var count : Int? = 0
        ref = db.collection(userID).document(collectionName)
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()//.map(String.init(describing:)) ?? "nil"
                //document.data()
                //print("Document data: \(dataDescription)")
                count = dataDescription?["Count"] as? Int
                count = count! + 1
                //uploading image
                let imageName = "\(count!)Image.png"
                // set upload path
                let filePath = "\(Auth.auth().currentUser!.uid)/\(imageName)"
                self.uploadImage(filePath: filePath, data: data, post: post, count: count, completion: {
                    completion()
                })
            } else {
                ref?.setData([
                    "Count": 0
                    ])
                count = count! + 1
                //uploading image
                let imageName = "\(count!)Image.png"
                // set upload path
                let filePath = "\(Auth.auth().currentUser!.uid)/\(imageName)"
                self.uploadImage(filePath: filePath, data: data, post: post, count: count, completion: {
                    completion()
                })
            }
        }
        
     
    }
    
    //Download methods
    
    func getPosts (completion : @escaping (Bool,Any?,Error?)->())
    {
        
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        //getting image count for image path
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "TextPosts"
        ref = db.collection(userID).document(collectionName)
        
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                completion(true,dataDescription?["post"],nil)
                print(dataDescription as Any)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    
    
//    func getImages(completion : @escaping (Bool,Any?,Error?)->()){
//        
//    }
    func getCount(completion : @escaping (Bool,Int?,Error?)->()){
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        //getting image count for image path
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "ImageCount"
        ref = db.collection(userID).document(collectionName)
        
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let count : Int = dataDescription?["Count"] as? Int ?? 0
                completion(true,count,nil)
                print(dataDescription as Any)
            } else {
                print("Document does not exist")
            }
        }
    }
    func getImagePosts(completion : @escaping (Bool,Any?,Error?)->()){
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil
        //getting image count for image path
        let userID = Auth.auth().currentUser!.uid
        let collectionName = "TextWithImagePosts"
        ref = db.collection(userID).document(collectionName)
        
        ref?.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                completion(true,dataDescription?["post"],nil)
                print(dataDescription as Any)
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
}
