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

//HIDING KEYBOARD WHEN TAPPED OUTSIDE
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Adding done button on keybaord

extension UITextView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}


class mediaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    
    var db: Firestore!
    var mediaShown = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("YES")
        // [START setup]
       self.hideKeyboardWhenTappedAround()
        self.postTextView.addDoneButtonOnKeyboard()
       // Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCameraTap(_:)))
        cameraView.addGestureRecognizer(cameraTap)
        cameraView.isUserInteractionEnabled = true
        cameraView.layer.borderColor = UIColor.white.cgColor
        cameraView.layer.borderWidth = 1.0
        let libraryTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLibraryTap(_:)))
        libraryView.addGestureRecognizer(libraryTap)
        libraryView.isUserInteractionEnabled = true
        libraryView.layer.borderColor = UIColor.white.cgColor
        libraryView.layer.borderWidth = 1
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSaveTap(_:)))
        saveView.addGestureRecognizer(saveTap)
        saveView.isUserInteractionEnabled = true
        saveView.layer.borderColor = UIColor.white.cgColor
        saveView.layer.borderWidth = 1
        self.postTextView.layer.cornerRadius = 10.0
        self.postTextView.layer.borderColor = UIColor.blue.cgColor
        self.postTextView.layer.borderWidth = 1.0
        self.postTextView.delegate = self
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
        var textToSend : String?
        if (postTextView.text == nil || postTextView.text == "" || postTextView.text == "What is something you are grateful for today?"){
            textToSend = "none"
        }
        else{
            textToSend = postTextView.text
        }
        //Save post
        networkManager.sharedInstance.putTextPost(post: textToSend!)
        dismiss(animated: true, completion: nil)
        
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
            //fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
  //      print (selectedImage.size)
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
    
    func textViewDidBeginEditing(_ textView: UITextView)
       
    {
   //      print(textView.text)
        if (textView.text == "What is something you are grateful for today?" )
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "What is something you are grateful for today?"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    
    @IBAction func cancelThought(_ sender: Any) {
        [self .dismiss(animated: true, completion: nil)]
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
