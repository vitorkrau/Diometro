import Foundation
import Combine
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    
    @Published var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.location = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: -22.9138851, longitude: -43.7261746)
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
    }
}
