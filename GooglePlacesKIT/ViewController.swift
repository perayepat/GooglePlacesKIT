
import UIKit
import MapKit
import SwiftUI

class ViewController: UIViewController {
    
    let mapView = MKMapView()
    let searchVC  = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PLACES +"
        view.addSubview(mapView)
        setSystemBar()
        
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
}

extension ViewController{
    func configureSheet(){
      
        
    }
}

extension ViewController: UISearchResultsUpdating, ResultsViewControllerDelegate{
    func presentBottomSheet(place: Place) {
        let swiftuiView = UIHostingController(rootView: PlaceDetailView(place: place))
        let detailViewController = DetailViewController()
        
        detailViewController.addChild(swiftuiView)
        detailViewController.view.addSubview(swiftuiView.view)
        swiftuiView.didMove(toParent: detailViewController)
        swiftuiView.view.frame = CGRect(x: 0,
                                        y: detailViewController.view.safeAreaInsets.top,
                                        width: detailViewController.view.frame.size.width,
                                        height: detailViewController.view.frame.size.height)
        
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.isModalInPresentation = true
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.custom(resolver: { screen in
                0.05 * screen.maximumDetentValue
            }),.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
          }
        
        present(nav, animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with:places)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setSystemBar(){
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let frame = CGRect(origin: .zero, size: statusBarSize)
        let statusbarView = UIView(frame: frame)
        statusbarView.backgroundColor = UIColor.secondarySystemBackground
        view.addSubview(statusbarView)
    }
    
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true)
        /// Remove map pin
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        /// Add a map pin
        let pin =  MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
    }
}
