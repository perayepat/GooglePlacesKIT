import Foundation
import GooglePlaces

final class GooglePlacesManager{
    static let shared = GooglePlacesManager()
    
    let client = GMSPlacesClient.shared()
    
    private init (){}
    
    public func setUp(){
        GMSPlacesClient.provideAPIKey("AIzaSyCcyVr8-75zDXC6H9OFeDRj4XS5aP3182k")
    }
}
