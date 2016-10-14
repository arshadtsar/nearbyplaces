//
//  InfoViewController.swift
//  NearbyPlace
//
//  Created by Thabu on 10/8/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var TitleLab: UILabel!
    @IBOutlet weak var namelab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var Latlab: UILabel!
    @IBOutlet weak var longlab: UILabel!
    @IBOutlet weak var TypeLab: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    
    var titlestr:NSString!
    var namestr:NSString!
    var Addressstr:NSString!
    var latstr:NSNumber!
    var longstr:NSNumber!
    var typestr:NSString!
    var imagestr:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TitleLab.text = titlestr as String
         self.namelab.text = namestr as String
         self.addressLab.text = Addressstr as String
         self.Latlab.text = "\(latstr)"
         self.longlab.text = "\(longstr)"
         self.TypeLab.text = typestr as String
        
        
        namelab.layer.cornerRadius = 7.0
        namelab.layer.borderWidth = 1.0
        namelab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        addressLab.layer.cornerRadius = 7.0
        addressLab.layer.borderWidth = 1.0
        addressLab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        Latlab.layer.cornerRadius = 7.0
        Latlab.layer.borderWidth = 1.0
        Latlab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        longlab.layer.cornerRadius = 7.0
        longlab.layer.borderWidth = 1.0
        longlab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        TypeLab.layer.cornerRadius = 7.0
        TypeLab.layer.borderWidth = 1.0
        TypeLab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let url = NSURL(string: imagestr as String)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func ShowAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        vc.latstr = latstr
        vc.longstr = longstr
        vc.titlename = String(format: "%@",self.namelab.text!)
        vc.subtitlestr = String(format: "%@",self.addressLab.text!)
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
