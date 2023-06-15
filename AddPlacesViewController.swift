//
//  AddPlacesViewController.swift
//  Places
//
//  Created by Matthias Wortmann on 25.12.15.
//  Copyright © 2015 Matthias Wortmann. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse
import CoreData

let kSuccessTitle = "Platz gespeichert😎"
let kErrorTitle = "Connection error"
let kNoticeTitle = "Alle Plätze gelöscht!"
let kWarningTitle = "Warning"
let kInfoTitle = "Info"
let kSubtitle = "Du hast diesen Platz erfolgreich gespeichert💪🏼"

let kDefaultAnimationDuration = 2.0

class AddPlacesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet var ViewController: UIView!
    @IBOutlet weak var noteTextField: MKTextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomButton: MKButton!
    @IBOutlet weak var Table1: MKButton!

    var annotation:MKAnnotation!
    let locationManager = CLLocationManager()
    var appDelegate: AppDelegate!
    var store:Store?
    let moContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Mark: - Location Delegate Methods
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.locationManager.stopUpdatingLocation()

        
        //addButton ignoriert Berürungen vom User
        addButton.enabled = false
        
        //Material Design
        Table1.layer.shadowOpacity = 0
        Table1.layer.shadowRadius = 0
        Table1.layer.shadowColor = UIColor.grayColor().CGColor
        Table1.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        
        // No border, no shadow, floatingPlaceholderEnabled
        noteTextField.layer.borderColor = UIColor.clearColor().CGColor
        noteTextField.floatingPlaceholderEnabled = true
        noteTextField.placeholder = "Wie heisst dieser Platz?"
        noteTextField.tintColor = UIColor.MKColor.Orange
        noteTextField.rippleLocation = .Right
        noteTextField.cornerRadius = 0
        noteTextField.bottomBorderEnabled = true
        
            }
    
    //Wenn auf das Textfeld gedrückt wird kann addButton gedrückt werden
    @IBAction func textFieldEditingChanged(sender: MKTextField) {
        addButton.enabled = !noteTextField.text!.isEmpty
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
        self.mapView?.setRegion(region, animated: true)
        }
    @IBAction func hideKB(sender: AnyObject) {
    
        noteTextField.resignFirstResponder()
        mapView.resignFirstResponder()
    
    }
    
    //Wenn auf Abbrechen Button gedrückt wird, schliesst sich der AddPlaceViewController
    @IBAction func onChancel(sender: AnyObject){
        
        //AddPlaceViewController verschwindet
        dismissViewControllerAnimated(true,
            completion: nil)
    }
    //Wenn Platz hinzugefügt wird, wird Meldung gezeigt
    @IBAction func onAddButton(sender: AnyObject) {
        
        let locCoord = CLLocationCoordinate2DMake(self.locationManager.location!.coordinate.latitude, self.locationManager.location!.coordinate.longitude)
        
        let lat = locCoord.latitude
        let lng = locCoord.longitude
        
        let ed = NSEntityDescription.entityForName("Store", inManagedObjectContext: moContext)
        let store = Store(entity: ed!, insertIntoManagedObjectContext: moContext)
        
        store.storeName = noteTextField.text!
        store.storeLng = lng
        store.storeLat = lat
      
        
        
        do  {
            
            try moContext.save()
            noteTextField.text  = ""
            lat
            lng
            

            print(store.storeLat)
            print(store.storeLng)
            
            let alert = SCLAlertView()
            alert.showSuccess(kSuccessTitle, subTitle: kSubtitle)
            let coordinatesMake = CLLocationCoordinate2DMake(lat, lng)
            
            // add the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat , longitude: lng)
            annotation.title = noteTextField.text
            self.mapView.addAnnotation(annotation)
            
    
        } catch let error as NSError
        {
            let alert = SCLAlertView()
            alert.showError("Platz nicht gespeichert", subTitle: "Es ist leider ein Fehler passiert.")
        }
        
        
        //MARK: - schliesst AddPlaceViewController
        dismissViewControllerAnimated(true, completion: nil)
        
        //assigning our latitude. we are converting our double into an NSNumber so we can enter it into coreData
        
        
        
        //returning the coordinate so as to conform to MKAnnotation protocol
        let storedCoordinate = CLLocationCoordinate2DMake(lat as Double, lng as Double)
            let annotation = MKPointAnnotation()
            annotation.coordinate = storedCoordinate
            annotation.title = store.storeName
        self.mapView.addAnnotation(annotation)
    }
    @IBAction func shareButton(sender: AnyObject) {
    
        let string: String = "Dieser Platz musst du umbedingt besuchen! 😎😮"
        
        let activityViewController = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true) {
            // ...
        }

    }
    
    //Zoom automatisch zur aktuellen Standort wenn Button gedrückt wird
    @IBAction func onZoomToLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
        
    }
    

}