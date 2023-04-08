import Foundation
import GooglePlaces


enum PlacesErrors: Error{
    case failedToFind
}

final class GooglePlacesManager{
    static let shared = GooglePlacesManager()
    
    let client = GMSPlacesClient.shared()
    
    private init (){}
    
    
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place],Error>) -> Void){
        let filter = GMSAutocompleteFilter()
        filter.types = ["geocode"]
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesErrors.failedToFind))
                return
            }
            
            let places : [Place] = results.compactMap {
                Place(name: $0.attributedFullText.string,
                      id: $0.placeID)
            }
            
            completion(.success(places))
        }
    }
}
