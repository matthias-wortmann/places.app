//
//  StartViewController.swift
//  Places
//
//  Created by Matthias Wortmann on 26.12.15.
//  Copyright © 2015 Matthias Wortmann. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse
import CoreData


class StartViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, BWWalkthroughViewControllerDelegate  {
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var AddPlaceLabel: MKButton!
    @IBOutlet weak var AbbrechenLabel: MKButton!
    @IBOutlet weak var AddPlaceYellow: MKButton!
    @IBOutlet weak var BlurView: UIVisualEffectView!
    @IBOutlet weak var AddPlaceChancel: MKButton!
    @IBOutlet weak var AnimationPlusButton: MKButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomToLocationB: MKButton!
    @IBOutlet weak var searchButton: MKButton!
    @IBOutlet weak var infoButton: MKButton!
    @IBOutlet weak var listviewButton: MKButton!
    
    let locationManager = CLLocationManager()
    var appDelegate: AppDelegate!
    var editFlag = false
    var store:Store! = nil
    var stores = [Store]()
    let moContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Store", inManagedObjectContext: self.moContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        /*
        do {
            stores = try moContext.executeFetchRequest(fetchRequest) as! [Store]
            if stores.count > 0
            {
                
                print("Test")
                // add the annotation
                let lat = Double(self.store!.storeLat)
                let lng = Double(self.store!.storeLng)
                
                
                let locCord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = locCord
                annotation.title = store!.storeName
                
                self.mapView.addAnnotation(annotation)
                
            } else
            {
                let alert = SCLAlertView()
                alert.showError("Keine Places", subTitle: "Du hast noch keine Places gespeichert.")
            }
        } catch {
            fatalError("Failed to fetch Places: \(error)")
        }
        
        */
        // Wenn gespeicherter Place auf Karte angeschaut werden will
        if editFlag == true
        {
            
            let lat:Double = Double(store!.storeLat)
            let lng:Double = Double(store!.storeLng)
            
            
            let locCord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locCord
            annotation.title = store!.storeName
            
            self.mapView.addAnnotation(annotation)
            
        }
        //making sure we have the appDelegate at hand with the context save method
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
        //MARK: Map Bubble ist orange
        mapView.tintColor = UIColor.orangeColor()
        
    
        // MARK: Material Design Touchanimations
        
        AddPlaceChancel.maskEnabled = false
        AddPlaceChancel.ripplePercent = 1.2
        AddPlaceChancel.backgroundAniEnabled = false
        AddPlaceChancel.rippleLocation = .Center
        
        AnimationPlusButton.maskEnabled = false
        AnimationPlusButton.ripplePercent = 1.2
        AnimationPlusButton.backgroundAniEnabled = false
        AnimationPlusButton.rippleLocation = .Center
        
        zoomToLocationB.maskEnabled = true
        zoomToLocationB.ripplePercent = 2
        zoomToLocationB.backgroundAniEnabled = false
        zoomToLocationB.rippleLocation = .Center
        
        searchButton.maskEnabled = true
        searchButton.ripplePercent = 2
        searchButton.backgroundAniEnabled = false
        searchButton.rippleLocation = .Center

        infoButton.maskEnabled = true
        infoButton.ripplePercent = 2
        infoButton.backgroundAniEnabled = false
        infoButton.rippleLocation = .Center
        
        listviewButton.maskEnabled = true
        listviewButton.ripplePercent = 2
        listviewButton.backgroundAniEnabled = false
        listviewButton.rippleLocation = .Center
        
        AddPlaceYellow.maskEnabled = false
        AddPlaceYellow.ripplePercent = 1.2
        AddPlaceYellow.backgroundAniEnabled = false
        AddPlaceYellow.rippleLocation = .Center
        
        AbbrechenLabel.layer.shadowOpacity = 0.55
        AbbrechenLabel.layer.shadowRadius = 5.0
        AbbrechenLabel.layer.shadowColor = UIColor.grayColor().CGColor
        AbbrechenLabel.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        AddPlaceLabel.layer.shadowOpacity = 0.55
        AddPlaceLabel.layer.shadowRadius = 5.0
        AddPlaceLabel.layer.shadowColor = UIColor.grayColor().CGColor
        AddPlaceLabel.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        //MARK: Parse Test
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.locationManager.stopUpdatingLocation()
    
        //MARK: Versteckt AddPlaceLabel und Abbrechen Label
        AddPlaceLabel.hidden = true
        AbbrechenLabel.hidden = true
        //MARK: Versteckt BlurView
        BlurView.hidden = true
        //MARK: Verteckt AddPlaceChancel
        AddPlaceChancel.hidden = true
        //MARK: Versteckt AddPlaceYellow Button
        AddPlaceYellow.hidden = true
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //TODO: Hier neue Zeille programmieren
    }
    //Mark: - Location Delegate Methods
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D (latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
            

    }
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        let page_four = stb.instantiateViewControllerWithIdentifier("walk4")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }

    
    @IBAction func Rotate1(sender: AnyObject) {
        
        //MARK: AddPlace Button macht eine Drehung innert 0.3 Sekunden um 0.755
        UIView.animateWithDuration(0.3, animations:({
            self.AnimationPlusButton.transform =
            CGAffineTransformMakeRotation(0.755)
            
            
            //MARK: Add Place Label erscheint
            self.AddPlaceLabel.hidden = false
                //MARK: AddPlaceButton macht kleine Animation
                self.AddPlaceLabel.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.AddPlaceLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
            //MARK: AddPlaceYellow erscheint
            self.AddPlaceYellow.hidden = false
                //MARK: AddPlace yellow macht kleine Animation
                self.AddPlaceYellow.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.AddPlaceYellow.transform = CGAffineTransformMakeScale(1.1, 1.1)
            //MARK: Abbrechen Label erscheint
            self.AbbrechenLabel.hidden = false
                //MARK:Abbrechen Label macht kleine Animation
                self.AbbrechenLabel.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.AbbrechenLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
            //MARK: BlurView erscheint
            self.BlurView.hidden = false
            //MARK: Zeigt AddPlaceChancel
            self.AddPlaceChancel.hidden = false
            

        }) )
    }
    // MARK: AddPlace Button dreht zurück falls Benutzer auf Button klickt
    @IBAction func ChancelLabelTouched(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations:({
            self.AnimationPlusButton.transform =
                CGAffineTransformMakeRotation(0)
            
            //MARK: AddPlaceLabel und Abbrechen Label verschwindet wieder
            self.AddPlaceLabel.hidden = true
            self.AbbrechenLabel.hidden = true
            
            //MARK: BlurView verschwindet wieder
            self.BlurView.hidden = true
            
            //MARK: Versteckt AddPlaceChancel
            self.AddPlaceChancel.hidden = true
            
            //MARK: Versteckt AddPlaceYellow wieder
            self.AddPlaceYellow.hidden = true
        }) )
   
    }
    
    @IBAction func addPlaceYellow(sender: AnyObject)
    {
        UIView.animateWithDuration(0.3, animations:({
            self.AnimationPlusButton.transform =
                CGAffineTransformMakeRotation(0)
            
        
            //AddPlaceLabel und Abbrechen Label verschwindet wieder
            self.AddPlaceLabel.hidden = true
            self.AbbrechenLabel.hidden = true
            
            //BlurView verschwindet wieder
            self.BlurView.hidden = true
            
            //Versteckt AddPlaceChancel
            self.AddPlaceChancel.hidden = true
            
            //Versteckt AddPlaceYellow wieder
            self.AddPlaceYellow.hidden = true
    
        }))
    }
    
    @IBAction func AddPlaceChancel(sender: AnyObject) {
                       UIView.animateWithDuration(0.3, animations:({
            self.AnimationPlusButton.transform =
                CGAffineTransformMakeRotation(0)
                    

            //AddPlaceLabel und Abbrechen Label verschwindet wieder
            self.AddPlaceLabel.hidden = true
            self.AbbrechenLabel.hidden = true
                        
            //BlurView verschwindet wieder
            self.BlurView.hidden = true
                        
            //Versteckt AddPlaceChancel
            self.AddPlaceChancel.hidden = true
            
            //Versteckt AddPlaceYellow wieder
            self.AddPlaceYellow.hidden = true
            
                    
                    
        }) )
        
        
    }
    
    @IBAction func searchTextFieltouched(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    //Zoom to current location
    
    @IBAction func zoomToLocation(sender: AnyObject){
    zoomToUserLocationInMapView(mapView)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MyCustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("AddPlacesViewController", sender: view)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? StartViewController, let annotationView = sender as? MKPinAnnotationView {
            destination.annotation = annotationView.annotation as? MKPointAnnotation
        }
    }
    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
       
        searchBar.updateConstraintsIfNeeded()
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alert = SCLAlertView()
                alert.showError("Place nicht gefunden😢", subTitle: "Versuche es nochmal.")
                
            return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
           
            let identifier = "MyCustomAnnotation"
            
            var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: self.annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true


            }
        }
    }
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
