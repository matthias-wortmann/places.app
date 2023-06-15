//
//  File.swift
//  Places
//
//  Created by Matthias Wortmann on 03.02.16.
//  Copyright © 2016 Matthias Wortmann. All rights reserved.
//

import UIKit
import MapKit



// MARK: Helper Functions

func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1, 1)
        mapView.setRegion(region, animated: true)
    }
}


func addAnnotation (mapView: MKMapView) {
    
    let mapView = MKMapView()
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude:
    mapView.userLocation.coordinate.longitude)
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(annotation)
}