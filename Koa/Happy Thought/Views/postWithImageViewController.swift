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
    var isKeyboardAppear = false
    var keyboardSize  : CGFloat?
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keybaord Setup
        self.hideKeyboardWhenTappedAround()
        self.postText.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //Firebase setup
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCameraTap(_:)))
        cameraView.addGestureRecognizer(cameraTap)
        cameraView.isUserInteractionEnabled = true
        cameraView.layer.borderColor = UIColor.white.cgColor
        cameraView.layer.borderWidth = 1.0
      //  cameraView.addSubview(cameraAnimationView)
        
       
        let libraryTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLibraryTap(_:)))
        libraryView.addGestureRecognizer(libraryTap)
        libraryView.isUserInteractionEnabled = true
        libraryView.layer.borderColor = UIColor.white.cgColor
        libraryView.layer.borderWidth = 1
        //libraryView.addSubview(libraryAnimationView)
        
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSaveTap(_:)))
        saveView.addGestureRecognizer(saveTap)
        saveView.isUserInteractionEnabled = true
       // saveView.addSubview(saveAnimationView)
        saveView.layer.borderColor = UIColor.white.cgColor
        saveView.layer.borderWidth = 1
        //saveAnimationView.play()
        
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
    
    
    //Keyboard methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            isKeyboardAppear = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
            isKeyboardAppear = false
        }
    }
    
    //#MARK Media Methods
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
        if !(self.isKeyboardAppear){
        loadingAnimationView.frame = CGRect(x: 0, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
        }
        else{
            self.loadingView.frame.origin.y += 150;
             loadingAnimationView.frame = CGRect(x: 0, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
        }
        //  animationView.center = self.view.center
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopAnimation = true
        loadingAnimationView.play()
        loadingView.backgroundColor = UIColor.black
        loadingView.addSubview(loadingAnimationView)
        //loadingView.backgroundColor = UIColor.blue
        var textToSend : String?
        if (postText.text == nil || postText.text == "" || postText.text == "What is something you are grateful for today?"){
            textToSend = "none"
        }
        else{
            textToSend = postText.text
        }
        networkManager.sharedInstance.putImagePost(post: textToSend!, postImage: postImgView.image!, completion: {
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
            return
            //fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
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
