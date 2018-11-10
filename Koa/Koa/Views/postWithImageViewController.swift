//
//  postWithImageViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/27/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Firebase
import Lottie
class postWithImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var postImage : UIImage?
    var db: Firestore!

    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.loadingView.layer.cornerRadius = 5.0
        self.loadingView.clipsToBounds = true
        self.postText.layer.cornerRadius = 10.0
        self.postText.clipsToBounds = true
        self.postText.layer.borderColor = UIColor.blue.cgColor
        self.postText.layer.borderWidth = 1.0
    //    self.loadingView.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.postImgView?.image = postImage
        
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
        let loadingAnimationView = LOTAnimationView(name: "spinning_upload")
        loadingAnimationView.frame = CGRect(x: 0, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
        //  animationView.center = self.view.center
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopAnimation = true
        loadingAnimationView.play()
        loadingView.backgroundColor = UIColor.black
        loadingView.addSubview(loadingAnimationView)
        //loadingView.backgroundColor = UIColor.blue
        networkManager.sharedInstance.putImagePost(post: postText.text, postImage: postImgView.image!, completion: {
            loadingAnimationView.removeFromSuperview()
            let successAnimationView = LOTAnimationView(name: "success")
            successAnimationView.frame = CGRect(x: 0, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
            //  animationView.center = self.view.center
            successAnimationView.contentMode = .scaleAspectFill
            // successAnimationView.loopAnimation = true
            // successAnimationView.play()
            self.loadingView.backgroundColor = UIColor.black
            self.loadingView.addSubview(successAnimationView)
            
            
            successAnimationView.play(completion: { (true) in
                self.dismiss(animated: true, completion: nil)
            })
        })
      //  dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        print (selectedImage.size)
        self.postImage = selectedImage
        self.postImgView.image = self.postImage
        
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
