//
//  mediaViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/16/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Lottie
import Firebase
class mediaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    
    var db: Firestore!
    var mediaShown = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("YES")
        // [START setup]
       
        
       // Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let cameraAnimationView = LOTAnimationView(name: "camera")
        cameraAnimationView.frame = CGRect(x: 0, y: 0, width: self.cameraView.frame.width, height: self.cameraView.frame.height)
        //  animationView.center = self.view.center
        cameraAnimationView.contentMode = .scaleToFill
        cameraAnimationView.loopAnimation = true
        cameraAnimationView.play()
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCameraTap(_:)))
        cameraAnimationView.addGestureRecognizer(cameraTap)
        cameraAnimationView.isUserInteractionEnabled = true
        cameraView.layer.borderColor = UIColor.white.cgColor
        cameraView.layer.borderWidth = 1.0
        cameraView.addSubview(cameraAnimationView)
        
        let libraryAnimationView = LOTAnimationView(name: "postcard")
        libraryAnimationView.frame = CGRect(x: 0, y: 0, width: self.libraryView.frame.width, height: self.libraryView.frame.height)
        //  animationView.center = self.view.center
        libraryAnimationView.contentMode = .scaleAspectFill
        libraryAnimationView.loopAnimation = true
        libraryAnimationView.play()
        let libraryTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLibraryTap(_:)))
        libraryAnimationView.addGestureRecognizer(libraryTap)
        libraryAnimationView.isUserInteractionEnabled = true
        libraryView.layer.borderColor = UIColor.white.cgColor
        libraryView.layer.borderWidth = 1
        libraryView.addSubview(libraryAnimationView)
        
        let saveAnimationView = LOTAnimationView(name: "saving_quotes")
        saveAnimationView.frame = CGRect(x: self.saveView.frame.width/3, y: 0, width: self.saveView.frame.width/2, height: self.saveView.frame.height)
        //  animationView.center = self.view.center
        saveAnimationView.contentMode = .scaleAspectFit
        saveAnimationView.loopAnimation = true
        saveAnimationView.animationSpeed = 0.5
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSaveTap(_:)))
        saveAnimationView.addGestureRecognizer(saveTap)
        saveAnimationView.isUserInteractionEnabled = true
        saveView.addSubview(saveAnimationView)
        saveView.layer.borderColor = UIColor.white.cgColor
        saveView.layer.borderWidth = 1
        saveAnimationView.play()
        
        self.postTextView.layer.cornerRadius = 10.0
        self.postTextView.layer.borderColor = UIColor.blue.cgColor
        self.postTextView.layer.borderWidth = 1.0
       // FirebaseApp.configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (mediaShown == 1)
        {
            dismiss(animated: true, completion: nil)
        }
    }
    func cameraPicker(){
        //Showing camera picker
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    @objc func handleCameraTap(_ sender: UITapGestureRecognizer) {
       
        cameraPicker()
    }
    
    @objc func handleLibraryTap(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        // TO BE DONE IN PICKER IMAGE PICKED METHOD
        
    }
    @objc func handleSaveTap(_ sender: UITapGestureRecognizer) {
        if (postTextView.text == "Wanna say something?")
        {
            //Text isn't changed
            return
        }
        //Save post
        networkManager.sharedInstance.putTextPost(post: postTextView.text)
        dismiss(animated: true, completion: nil)
        
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        print (selectedImage.size)
        let postWImgViewController:postWithImageViewController = storyboard?.instantiateViewController(withIdentifier: "postWithImageViewController") as! postWithImageViewController
       // postWImgViewController.delegate = self
        postWImgViewController.postImgView?.image = selectedImage
        postWImgViewController.postImage = selectedImage
        mediaShown = 1
        self.present(postWImgViewController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
