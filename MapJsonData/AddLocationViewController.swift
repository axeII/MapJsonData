//
//  AddLocationViewController.swift
//  MapJsonData
//
//  Created by Ales Lerch on 02.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    var locator: NewLocation?
    var locationManager: CLLocationManager!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var myLatitude: Double = 0.0
    var myLongtitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nastave nameTextField jako prvni responder
        nameTextField.becomeFirstResponder()
        
        
        // init CLLocation managera
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        /**aby toto fungovalu musi byt simulovana
         jinak pres last location se bere latitude a longtitude, ktere se
         ukladaji do promenny myLatitude a myLongtitude, ktere se predavaji do
         halvni poli latTextField a longTextField
         */
        let location = locations.last! as CLLocation
        self.myLatitude = location.coordinate.latitude
        self.myLongtitude = location.coordinate.longitude
        
        print(location.coordinate.latitude,location.coordinate.longitude)
    }

    @IBAction func getLocation(sender: AnyObject) {
        // pokud nejsou nastaveny tzn. neni zadna lokace k dispozi a jsou nulove hodnty vyplni se pole error spravou aby uzitel poznal ze nema zaplou lokaci
        if myLatitude != 0.0 && myLongtitude != 0.0 {
            self.latTextField.text = String(self.myLatitude)
            self.longTextField.text = String(self.myLongtitude)
        }else {
            self.latTextField.text = "No Location found!"
            self.longTextField.text = "No Location found!"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAdd(sender: AnyObject) {
        //kontrola poli jak jsou nastevny, zda jsou nastevny a zda-li splnuji podminky ze jsou to skutecne souradnice a ne nejake silene cislo
        //podle uzivatelova nasteni se zobrazi erro message, bud jenom pro doplneni jmena nebo ho to skutecne nepusti jen vypise error message
        if nameTextField.text == "" && longTextField.text != "" && latTextField.text != "" && Double(latTextField.text!)! > -90.0 && Double(latTextField.text!)! < 90.0 && Double(longTextField!.text!)! < 180.0 && Double(longTextField!.text!)! > -180.0 {
            alertMessage(sender)
        }else if longTextField.text == "" || latTextField.text == "" || Double(latTextField.text!)! < -90.0 || Double(latTextField.text!)! > 90.0 || Double(longTextField!.text!)! > 180.0 || Double(longTextField!.text!)! < -180.0   {
            simpleAlertMessage(sender)
        }else{
            if let loc = self.locator{
                loc.saveNewLocation(nameTextField!.text!, lat: Double(latTextField.text!)!, long: Double(longTextField.text!)! , locDescription: descriptionTextView.text)}
                dismissViewControllerAnimated(true, completion: nil)
        }
    }

    //ukladani pro func doneAdd
    func save(name_: String,lat_: Double, long_: Double, description_: String ){
        self.locator?.saveNewLocation(name_, lat: lat_, long: long_, locDescription: description_)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // error zprava, ktera, chce po uzivateli jenom pro doplneni jmena a pok jej pusti dal...
    func alertMessage(object : AnyObject){
        let actionController: UIAlertController = UIAlertController(title: "Location title empty", message: "Please fill the title", preferredStyle: .Alert)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        // kontrola jestli neni name stale prazdne pak se prida do databaze ... 
        let next: UIAlertAction = UIAlertAction(title: "Next", style: .Default){ (action) -> Void in
            if ((actionController.textFields?.first)! as UITextField).text! != "" {
                self.save(((actionController.textFields?.first)! as UITextField).text!,lat_: Double(self.latTextField.text!)!, long_: Double(self.longTextField.text!)!, description_: self.descriptionTextView.text)
            }
        }
        
        
        actionController.addAction(next)
        actionController.addAction(cancel)
        actionController.addTextFieldWithConfigurationHandler{ (txtField) -> Void in txtField.placeholder = "Title place here"}
        
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
    // jednoducha error zprava ktera jen upozorni ze neni neco nastevni co ma byt nebo spatne ...
    func simpleAlertMessage(object: AnyObject){
        let actionController: UIAlertController = UIAlertController(title: "Empty parameters", message: "Please fill parameters correctly", preferredStyle: .Alert)
        let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        actionController.addAction(ok)
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
    
    // add guard na nastaveni vsech paramter jinak se hodi eror .... jinak jeste pujde nastavit jeden dalsi
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
