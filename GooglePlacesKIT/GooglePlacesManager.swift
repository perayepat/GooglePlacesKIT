import Foundation
import GooglePlaces


enum PlacesErrors: Error{
    case failedToFind
    case locationCouldNotBeFound
}

final class GooglePlacesManager{
    static let shared = GooglePlacesManager()
    
    let client = GMSPlacesClient.shared()
    
    private init (){}
    
    
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place],Error>) -> Void){
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
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
    
    
        
    
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<Place, Error>) -> Void){
        
        client.fetchPlace(fromPlaceID: place.id,
                          placeFields: .all,
                          sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesErrors.locationCouldNotBeFound))
                return
            }
            let place = self.assignPlace(googlePlace)
//            let photoMetadata: GMSPlacePhotoMetadata = googlePlace.photos![0]
            let coordinate = CLLocationCoordinate2D(
                latitude: googlePlace.coordinate.latitude ,
                longitude: googlePlace.coordinate.longitude)
            
            completion(.success(place))
        }
        
    }
    
    private func assignPlace(_ googlePlace: GMSPlace) -> Place{
        let name  = googlePlace.name ?? ""
        let id = googlePlace.placeID ?? ""
        let placeCode = googlePlace.plusCode?.compoundCode
        let coordinate = googlePlace.coordinate
        let weekdays = googlePlace.openingHours?.weekdayText
        let periods = googlePlace.openingHours?.periods
        let phoneNumber = googlePlace.phoneNumber
        let address = googlePlace.formattedAddress
        let website = googlePlace.website
        let placeTypes = googlePlace.types
        let businessStatus = googlePlace.businessStatus
        
        let finalPlace = Place(name: name,
                               id: id,
                               plusCode: placeCode,
                               coordinate: coordinate,
                               weekdays: weekdays,
                               periods: periods,
                               phoneNumber: phoneNumber,
                               address: address,
                               website: website,
                               types: placeTypes,
                               businessStatus:  businessStatus)
        
        return finalPlace
    }
}
