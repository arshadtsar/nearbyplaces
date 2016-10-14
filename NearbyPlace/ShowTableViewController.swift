//
//  ShowTableViewController.swift
//  NearbyPlace
//
//  Created by Thabu on 10/8/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

import UIKit
import Foundation

class ShowTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var TitleLab: UILabel!

    @IBOutlet weak var ShowTblView: UITableView!
    var GetData:NSMutableDictionary!
    var GetnameArray:NSArray!
    var GetaddressArray:NSArray!
    var GetLatitudeArray:NSArray!
    var GetLongitudeArray:NSArray!
    var GeticonArray:NSArray!
    var GeticonType:NSArray!
    var titlestr:NSString!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TitleLab.text = titlestr as String
        GetnameArray = self.GetData.valueForKey("results")?.valueForKey("name")as! NSArray
        self.GetLatitudeArray = self.GetData.valueForKey("results")?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! NSArray
        self.GetLongitudeArray = self.GetData.valueForKey("results")?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! NSArray
        self.GeticonArray =  self.GetData.valueForKey("results")?.valueForKey("icon")as! NSArray
        self.GetnameArray = self.GetData.valueForKey("results")?.valueForKey("name")as! NSArray
        self.GetaddressArray = self.GetData.valueForKey("results")?.valueForKey("vicinity")as! NSArray
        self.GeticonType = self.GetData.valueForKey("results")?.valueForKey("types")as! NSArray
        }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tblView =  UIView(frame: CGRectZero)
        ShowTblView.tableFooterView = tblView
        animateTable()
        
    }
    func animateTable()
    {
        ShowTblView.reloadData()
        
        let cells = ShowTblView.visibleCells
        let tableHeight: CGFloat = ShowTblView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetnameArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = ShowTblView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = GetnameArray.objectAtIndex(indexPath.row) as? String
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("InfoViewController") as! InfoViewController
        vc.titlestr = self.GetnameArray.objectAtIndex(indexPath.row) as! String
        vc.namestr = self.GetnameArray.objectAtIndex(indexPath.row) as! String
        vc.Addressstr = self.GetaddressArray.objectAtIndex(indexPath.row) as! String
        vc.latstr = self.GetLatitudeArray.objectAtIndex(indexPath.row) as? NSNumber
        vc.longstr = self.GetLongitudeArray.objectAtIndex(indexPath.row) as? NSNumber
//        let resultlat = self.GetLatitudeArray.objectAtIndex(indexPath.row) as? NSNumber
//        vc.latstr = "\(resultlat)"
//        let resultlong = self.GetLongitudeArray.objectAtIndex(indexPath.row) as? NSNumber
//        vc.longstr = "\(resultlong)"
        vc.typestr = self.GeticonType.objectAtIndex(indexPath.row).firstObject as! String
        vc.imagestr = self.GeticonArray.objectAtIndex(indexPath.row) as! String
        self.presentViewController(vc, animated: true, completion: nil)

    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0
    }

    @IBAction func Back(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil) 
    }
}
