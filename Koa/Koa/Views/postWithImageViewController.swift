//
//  postWithImageViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/27/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Firebase
class postWithImageViewController: UIViewController {
    var postImage : UIImage?
    var db: Firestore!

    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.postImgView?.image = postImage
        
    }

    @IBAction func savePost(_ sender: Any) {
     
        networkManager.sharedInstance.putImagePost(post: postText.text, postImage: postImgView.image!)
        dismiss(animated: true, completion: nil)
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
