//
//  ImportFileViewController.swift
//  MapJsonData
//
//  Created by Ales Lerch on 07.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//

import UIKit

// # SaveMyLocation struct - pro ukladani dat z json file
/// preci jen lepsi reseni nez si jej uklad do pole stringu
struct SaveMyLocation {
    let name: String
    let latitude: Double
    let longtitude: Double
    let description: String
    
    init(name: String, lat: Double, long: Double, desc: String){
        self.name = name
        self.latitude = lat
        self.longtitude = long
        self.description = desc
    }
    
}

// # Import

class ImportFileViewController: UIViewController {
    
    var myLocations = Array<SaveMyLocation>() /// pole kam se ukladji data z jsona, pres objekty
    
    var delegator: NewLocation? /// delegator z MasterView

    @IBOutlet weak var urlTextField: UITextField! /// textpole
    
    /** 
     func, ktera pokud neni text pole prazdne,
     zatim je vse nastveno na priklad kdy beru data z lokalni file data.json, staci zadat jakykoliv text,
     a ukladani si jej pres do pole array<SaveMyLocation>
    */
    @IBAction func importFile(sender: AnyObject) {
        
        if urlTextField.text! != "" {
            let url = NSBundle.mainBundle().URLForResource("data", withExtension: "json") /// lokalni file data.json prevedu na NSdata
            let data = NSData(contentsOfURL: url!)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                //prevod json formatu, do spracovatelne podoby, zdroj: http://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
                if let locations = json["locations"] as? [[String: AnyObject]] {
                    for locI in locations {
                        if let name = locI["name"] as? String, let lat = locI["latitude"] as? Double, let long = locI["longtitude"] as? Double, let description = locI["description"] as? String{
                            let newLocation = SaveMyLocation(name: name, lat: lat, long: long, desc: description)
                            self.myLocations.append(newLocation)
                        }
                    }
                }
                print(myLocations) // test vypisu
                if let del = self.delegator {
                    // pres delegata si ukladam sve lokace do databaze
                    del.importNewLocatins(myLocations)
                }
            } catch {
                print("error serializing JSON: \(error)") // odchytavam error
            }
               dismissViewControllerAnimated(true, completion: nil)
        }else {
            // pokud je prazdy textfield zobraz error message
            simpleAlertMessage(sender)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //klasicka error message
    func simpleAlertMessage(object: AnyObject){
        let actinController: UIAlertController = UIAlertController(title: "Error import", message: "There was problem with importing.", preferredStyle: .Alert)
        let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        actinController.addAction(ok)
        self.presentViewController(actinController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
