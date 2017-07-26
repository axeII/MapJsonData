//
//  DetailViewController.swift
//  MapJsonData
//
//  Created by Ales Lerch on 02.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var initialLocation = CLLocation(latitude: 49.209867, longitude: 16.615393) // inicializacni hodnota lokace
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        // nastaveni hodnot ve view
        if let detail = self.detailItem {
            if let naLabel = self.nameLabel {
                naLabel.text = detail.valueForKey("locName")!.description
            }
            
            if let latLabel = self.latitudeLabel {
                latLabel.text = detail.valueForKey("locLat")!.description
            }
            
            if let longLabel = self.longtitudeLabel {
                longLabel.text  = detail.valueForKey("locLong")!.description
            }
            
            if let desLabel = self.detailDescriptionLabel {
                desLabel.text = detail.valueForKey("locDescription")!.description
            }
            
            let lat = detail.valueForKey("locLat") as! Double
            let long = detail.valueForKey("locLong") as! Double
            if (lat > -90.0 && lat < 90.0) && (long > -90.0 && long < 90.0) {
                // kontrola lokace pro zobrazeni mapy aby aplikace nespadla
                self.initialLocation = CLLocation(latitude: lat,longitude: long)
            }
        }
    }
    
    let regionRadius: CLLocationDistance = 1050
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        centerMapOnLocation(initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

