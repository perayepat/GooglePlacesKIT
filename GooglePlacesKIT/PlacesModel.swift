import Foundation
import CoreLocation
import GooglePlaces

struct Place{
    let name: String
    let id: String
    let plusCode: String?
    let coordinate: CLLocationCoordinate2D?
    let weekdays: [String]?
    let periods: [GMSPeriod]?
    let phoneNumber: String?
    let address: String?
    let website: URL?
    let types: [String]?
    let businessStatus: GMSPlacesBusinessStatus?
    
    init(name: String, id: String,
         plusCode: String? = nil, coordinate: CLLocationCoordinate2D? = nil,
         weekdays: [String]? = nil, periods: [GMSPeriod]? = nil, phoneNumber: String? = nil,
         address: String? = nil, website: URL? = nil, types: [String]? = nil, businessStatus: GMSPlacesBusinessStatus? = nil) {
        self.name = name
        self.id = id
        self.plusCode = plusCode
        self.coordinate = coordinate
        self.weekdays = weekdays
        self.periods = periods
        self.phoneNumber = phoneNumber
        self.address = address
        self.website = website
        self.types = types
        self.businessStatus = businessStatus
    }
}


struct PlaceOpeningHours{
    let open: PlaceHoursPeriodDetail
    let close: PlaceHoursPeriodDetail?
}

struct PlaceHoursPeriodDetail {
    let day :Int?
    let time : String?
    let date: String?
}
