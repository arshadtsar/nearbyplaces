//
//  ViewController.swift
//  NearbyPlace
//
//  Created by Thabu on 10/4/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    var latitu:NSArray!
    var longtut:NSArray!
    var icon:NSArray!
    var name:NSArray!
    var address:NSArray!
    var placeKeyword:NSMutableArray!
    var CityArray:NSMutableArray!
    var CurrentArray:NSMutableArray!
    var coordinate:CLLocationCoordinate2D!
    @IBOutlet weak var PlaceTxtFld: UITextField!
    var jsonResult: NSMutableDictionary!
    @IBOutlet weak var CityTxtFld: UITextField!
    @IBOutlet weak var CityBtn: UIButton!
    @IBOutlet weak var DataTblView: UITableView!
    @IBOutlet weak var PlaceBtn: UIButton!
    var txtfld:UITextField!

    @IBOutlet weak var ShowPlaceBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataTblView.hidden = true
        
        CityTxtFld.layer.cornerRadius = 3.0
        CityTxtFld.borderStyle = .RoundedRect
        CityTxtFld.layer.borderColor = UIColor.lightGrayColor().CGColor
        CityTxtFld.layer.borderWidth = 1.0
        PlaceTxtFld.layer.cornerRadius = 3.0
        PlaceTxtFld.borderStyle = .RoundedRect
        PlaceTxtFld.layer.borderColor = UIColor.lightGrayColor().CGColor
        PlaceTxtFld.layer.borderWidth = 1.0
        
        ShowPlaceBtn.layer.cornerRadius = 3.0
        ShowPlaceBtn.layer.borderWidth = 1.0
        ShowPlaceBtn.layer.borderColor = UIColor.orangeColor().CGColor
        let tblView =  UIView(frame: CGRectZero)
        DataTblView.tableFooterView = tblView
        placeKeyword = ["accounting","airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","campground","car_dealer","car_rental","car_repair","car_wash","casino","cemetery","church","city_hall","clothing_store","convenience_store","courthouse","dentist","department_store","doctor","electrician","electronics_store","embassy","establishment","finance","fire_station","florist","food","funeral_home","furniture_store","gas_station","general_contractor","grocery_or_supermarket","gym","hair_care","hardware_store","health","hindu_temple","home_goods_store","hospital","insurance_agency","jewelry_store","laundry","lawyer","library","liquor_store","local_government_office","locksmith","lodging","meal_delivery","meal_takeaway","mosque","movie_rental","movie_theater","moving_company","museum","night_club","painter","park","parking","pet_store","pharmacy","physiotherapist","place_of_worship","plumber","police","post_office","real_estate_agency","restaurant","roofing_contractor","rv_park","school","shoe_store","shopping_mall","spa","stadium","storage","store","subway_station","synagogue","taxi_stand","train_station","transit_station","travel_agency","university","veterinary_care","zoo"]
        CityArray = ["Hyderabad","Istanbul","Dispur","Patna","Raipur","Panaji","Gandhinagar","Chandigar","Simla","Srinagar","Ranchi","Bangalore","Tiruvanandapuram","Bhopal","Mumbai","Impal","Shilong","Aizawl","Kohima","Buvaneshwar","Jaipur","Gangtok","Chennai","Agartala","Lucknow","Deharadun","Kolkata"]

    }
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                self.coordinate = location?.coordinate
                print("\nlat: \(self.coordinate!.latitude), long: \(self.coordinate!.longitude)")
                
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
            self.CallFavService()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CurrentArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = CurrentArray.objectAtIndex(indexPath.row) as? String
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func CallFavService()
    {
        let lat:String = String(format:"%.1f", self.coordinate.latitude)
        let longi:String = String(format:"%.1f", self.coordinate.longitude)
        let Location = "\(lat),\(longi)"
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/search/json?", parameters: ["location":Location,"radius":"500","types":PlaceTxtFld.text!,"sensor":"true","key":"AIzaSyAbNXPXY8_ztNHOirMzFwUw_6VaSkq0uWQ"]).validate().response{
            request,response,data,error ->Void in
            do{
                self.jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSMutableDictionary
                    print(self.jsonResult)
                let status = self.jsonResult.valueForKey("status") as! String
                if status == "ZERO_RESULTS"{
                    let alertController = UIAlertController(title: "Error", message: "Invalid Place id.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    self.latitu = self.jsonResult.valueForKey("results")?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! NSArray
                    self.longtut = self.jsonResult.valueForKey("results")?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! NSArray
                    self.icon =  self.jsonResult.valueForKey("results")?.valueForKey("icon")as! NSArray
                    self.name = self.jsonResult.valueForKey("results")?.valueForKey("name")as! NSArray
                    self.address = self.jsonResult.valueForKey("results")?.valueForKey("vicinity")as! NSArray
                    let stort = UIStoryboard(name: "Main",bundle: nil)
                    let map = stort.instantiateViewControllerWithIdentifier("ShowTableViewController") as! ShowTableViewController
                    map.titlestr = self.CityTxtFld.text
                    map.GetData = self.jsonResult
                    self.navigationController?.presentViewController(map, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func ShowNearbyPlace(sender: AnyObject)
    {
        if CityTxtFld.text == "" && PlaceTxtFld.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Enter City and Place", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if CityTxtFld.text == "" || PlaceTxtFld.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Enter City or Place", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if CityTxtFld.text != "" && PlaceTxtFld.text != ""
        {
            forwardGeocoding(CityTxtFld.text!)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if txtfld == CityTxtFld
        {
            CityTxtFld.text = CurrentArray.objectAtIndex(indexPath.row) as? String
        }
        else if txtfld == PlaceTxtFld
        {
            PlaceTxtFld.text = CurrentArray.objectAtIndex(indexPath.row) as? String
        }
        self.DataTblView.hidden = true
    }
    @IBAction func BtnPressed(sender: UIButton)
    {
        if sender == CityBtn
        {
            CurrentArray = CityArray
            txtfld = CityTxtFld
            self.DataTblView.hidden = false
            self.DataTblView.dataSource = self
            self.DataTblView.delegate = self
            self.DataTblView.reloadData()
        }
        else if sender == PlaceBtn
        {
            CurrentArray = placeKeyword
            txtfld = PlaceTxtFld
            self.DataTblView.hidden = false
            self.DataTblView.dataSource = self
            self.DataTblView.delegate = self
            self.DataTblView.reloadData()
        }
        animateTable()
    }
    func animateTable()
    {
        DataTblView.reloadData()
        
        let cells = DataTblView.visibleCells
        let tableHeight: CGFloat = DataTblView.bounds.size.height
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
}

