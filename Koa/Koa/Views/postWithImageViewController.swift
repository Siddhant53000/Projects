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
class postWithImageViewController: UIViewController {
    var postImage : UIImage?
    var db: Firestore!

    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    //    self.loadingView.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.postImgView?.image = postImage
        
    }

    @IBAction func savePost(_ sender: Any) {
      
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
