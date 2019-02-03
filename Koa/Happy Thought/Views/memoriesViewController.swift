//
//  memoriesViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/18/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseUI
class memoriesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var memoriesTable: UITableView!
    @IBOutlet weak var inspirationsButton: UIView!
    @IBOutlet weak var thoughtsButton: UIView!
    
    var db: Firestore!
    var cellArray : Array<UIImage>?
    var textPostArray : Array<String>?
    var imagePostArray : Array<Dictionary<String,Any>>?
    var expandedCellArray : Set<Int>?
    var count : Int = 0
    var currentSelection : Int = 0
    //Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.currentSelection == 0 )
        {
            return self.count
        
        }
        if (self.currentSelection == 1)
        {
            return textPostArray?.count ?? 0
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.currentSelection == 1)                     //TEXT POSTS
        {
            
            let cell = Bundle.main.loadNibNamed("textPostTableViewCell",owner: indexPath)?.first as!  textPostTableViewCell

         //   DispatchQueue.main.async {
               // cell.postImage.image = self.cellArray?[0]
                cell.postText.numberOfLines = 0
                cell.postText.text = self.textPostArray?[indexPath.row]
                
            //}
            return cell
        }
        
        
        //IMAGE FEED CELLS
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self)?.first as! FeedTableViewCell
            let storage = Storage.storage()
            let storageRef = storage.reference()
            //var ref: DocumentReference? = nil
            let ref = "\(Auth.auth().currentUser!.uid)/\(indexPath.row+1)Image.png"
            print (ref)
            let reference = storageRef.child( ref)
            // UIImageView in your ViewController
            let imageView: UIImageView = cell.postImage
            // Placeholder image
            let placeholderImage = UIImage(named: "placeholder.jpg")
            // Load the image using SDWebImage
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            var currentPost = self.imagePostArray?[indexPath.row]
            if (currentPost?["post"] as! String != "none")
            {
                cell.postText.text = currentPost?["post"] as? String
            }
//            cell.postText.layer.borderColor = UIColor.blue.cgColor
//            cell.postText.layer.borderWidth = 1.0
            //cell.postText.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.thoughtsButton.layer.borderWidth = 1;
        self.thoughtsButton.layer.borderColor = UIColor.black.cgColor
        self.thoughtsButton.layer.cornerRadius = 5
        self.thoughtsButton.clipsToBounds = true
        self.inspirationsButton.layer.borderWidth = 1
        self.inspirationsButton.layer.borderColor = UIColor.black.cgColor
        self.inspirationsButton.layer.cornerRadius = 5
        self.inspirationsButton.clipsToBounds = true
        memoriesTable.delegate = self
        memoriesTable.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let uID : String? = defaults.string(forKey: "uID")
        if (uID == nil)
        {
            self.thoughtsButton.isUserInteractionEnabled = false
            self.inspirationsButton.isUserInteractionEnabled = false
            let alert = UIAlertController(title: "Hey There!", message: "Please Login to use our great features!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            networkManager.sharedInstance.getCount { (success, count, error) in
                self.count = count ?? 0
                networkManager.sharedInstance.getImagePosts(completion: { (success, posts, error) in
                    self.imagePostArray = posts as? Array<Dictionary<String, Any>>
                    self.memoriesTable.reloadData()
                })
            }
            
        }
    }
    
    
 
    @IBAction func inspirationsSelected(_ sender: Any) {
        
        self.currentSelection = 0
        networkManager.sharedInstance.getCount { (success, count, error) in
            self.count = count ?? 0
            networkManager.sharedInstance.getImagePosts(completion: { (success, posts, error) in
                self.imagePostArray = posts as? Array<Dictionary<String, Any>>
                self.memoriesTable.reloadData()
            })
        }
        self.inspirationsButton.backgroundColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 255/255.0, alpha: 1.00)
        self.thoughtsButton.backgroundColor = UIColor.white
    }
    @IBAction func thoughtsSelected(_ sender: Any) {
    self.currentSelection = 1
    self.thoughtsButton.backgroundColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 255/255.0, alpha: 1.00)
    self.inspirationsButton.backgroundColor = UIColor.white
    networkManager.sharedInstance.getPosts { (success, textPosts, error) in
            self.textPostArray = textPosts as? Array<String>
            self.memoriesTable.reloadData()
        }
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
