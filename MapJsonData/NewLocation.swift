//
//  NewLocation.swift
//  MapJsonData
//
//  Created by Ales Lerch on 03.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//

import Foundation
import MapKit


// # NewLocation je protocol, ktery slouzi k ukladani lokaci
protocol NewLocation{
    //tato func je pro ulozeni jedne lokace
    func saveNewLocation(name: String, lat: Double, long: Double, locDescription: String)
    //tato func je pro import nekolika lokaci prebirajci pole structu - SaveMyLocations
    func importNewLocatins(locations: Array<SaveMyLocation>)
    
}

// # Class LLocation slouzi jako k ukladani jednotlivych pinu na mape 
class LLocation: NSObject, MKAnnotation{
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    

}