
import UIKit
import MapKit

class ViewController: UIViewController {
    let mapView = MKMapView()
    let searchVC  = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapView)
        setSystemBar()
        //        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            mapView.frame = view.bounds
//        mapView.frame = CGRect(x: 0,
//                               y: view.safeAreaInsets.top,
//                               width: view.frame.size.width,
//                               height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
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
}
