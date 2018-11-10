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
    @IBOutlet weak var postTypeSegment: UISegmentedControl!
    var db: Firestore!
    var cellArray : Array<UIImage>?
    var textPostArray : Array<String>?
    var expandedCellArray : Set<Int>?
    var count : Int = 0
    //Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.postTypeSegment.selectedSegmentIndex == 0 )
        {
            return self.count
        
        }
        if (self.postTypeSegment.selectedSegmentIndex == 2)
        {
            return textPostArray?.count ?? 0
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.postTypeSegment.selectedSegmentIndex == 2)                     //TEXT POSTS
        {
            let cell = Bundle.main.loadNibNamed("textPostTableViewCell", owner: self)?.first as! textPostTableViewCell
            DispatchQueue.main.async {
               // cell.postImage.image = self.cellArray?[0]
                cell.postText.text = self.textPostArray?[indexPath.row]
                
            }
            return cell
        }
        
        
        //IMAGE FEED CELLS
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self)?.first as! FeedTableViewCell
        DispatchQueue.main.async {
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
//            cell.postText.layer.borderColor = UIColor.blue.cgColor
//            cell.postText.layer.borderWidth = 1.0
            cell.postText.layer.cornerRadius = 10
            cell.postText.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        expandedCellArray?.insert(indexPath.row)
//        tableView.reloadData()
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if (self.postTypeSegment.selectedSegmentIndex == 2)
        {
//            if (expandedCellArray?.contains(indexPath.row) ?? false)
//            {
//                return UITableView.automaticDimension
//            }
//
                return UITableView.automaticDimension
        }
        return 409
    }

    @IBAction func changePostType(_ sender: UISegmentedControl) {
        switch postTypeSegment.selectedSegmentIndex{
        case 0:
        print (1)
            self.memoriesTable.reloadData()
        case 1:
            print (2)
        case 2:
            networkManager.sharedInstance.getPosts { (success, textPosts, error) in
                self.textPostArray = textPosts as? Array<String>
                self.memoriesTable.reloadData()
            }
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstImage = #imageLiteral(resourceName: "IMG_3864")
       
        cellArray?.append(firstImage)
        memoriesTable.delegate = self
        memoriesTable.dataSource = self
        networkManager.sharedInstance.getCount { (success, count, error) in
            self.count = count ?? 0
            networkManager.sharedInstance.getImagePosts(completion: { (success, posts, error) in
                
                self.memoriesTable.reloadData()
            })
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        networkManager.sharedInstance.getCount { (success, count, error) in
            self.count = count ?? 0
            networkManager.sharedInstance.getImagePosts(completion: { (success, posts, error) in
                
                self.memoriesTable.reloadData()
            })
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
