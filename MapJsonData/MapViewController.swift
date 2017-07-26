//
//  MapViewController.swift
//  MapJsonData
//
//  Created by Ales Lerch on 02.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    
    var locator: NewLocation? /// lokator
    var locations = [NSManagedObject]() /// pole lokaci z CD
    
    @IBOutlet weak var textSearchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllData()
        addPlacemarks()
        // Do any additional setup after loading the view.
    }
    
    
    //tato func je volana pokazde zobrazeni mapy, proto aby se aktualizoval seznam pinu na mape
    override func viewWillAppear(animated: Bool) {
        fetchAllData()
        addPlacemarks()
        super.viewWillAppear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map settings
    
    //nastaveni centra lokace
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        let regionRadius: CLLocationDistance = 370
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius , regionRadius)
        mapView.setRegion(coordinateRegion , animated: true)
    }
    
    //klasice vyhledavani lokace, cast kodu je ze cviceni... no skoro cely
    @IBAction func search(sender: AnyObject) {
        if let inputText = textSearchField.text{
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(inputText, completionHandler: {
                (placemarks:[CLPlacemark]?, error: NSError?) -> Void in if error != nil {
                    print("Geocode failed: \(error)")
                } else if let firstPlacemark = placemarks?[0] {
                    print("Placemarks: \(placemarks)")
                    self.centerMapOnLocation(firstPlacemark.location!.coordinate)
                }else{
                    print("No placemark found") }
            })
        
        }
    }
    
    
    //preklikavani map z klasicke na hybridni
   @IBAction func switchMap(sender: AnyObject) {
        if (mapView.mapType == MKMapType.Hybrid){
            mapView.mapType = MKMapType.Standard
        } else {
            mapView.mapType = MKMapType.Hybrid
        }
    }
    
    //pridani pinu na mapa, data bere z core data a prida je na mapView
    func addPlacemarks(){
        for location in locations{
            let myCoords = CLLocationCoordinate2DMake(location.valueForKey("locLat") as! Double,location.valueForKey("locLong") as! Double)
            
            let newLocation = LLocation(title: location.valueForKey("locName") as! String, locationName: location.valueForKey("locName") as! String, coordinate: myCoords)
            mapView.addAnnotation(newLocation)
        }
        //testovaci pin, pro nasi skolu
        let mendeluCoords = CLLocationCoordinate2DMake(49.209584,16.614262)
        let mendelu = LLocation(title: "MENDELU",locationName: "Mendel University Campus, Cerna pole, Brno",coordinate: mendeluCoords)
        mapView.addAnnotation(mendelu)
    }
    
    
    // vraci data z cele core data, ktere se ukladaji do locations
   func fetchAllData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Location")
    
    do {
        let results = try managedContext.executeFetchRequest(fetchRequest)
        locations = results as! [NSManagedObject]
       } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
     }
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
