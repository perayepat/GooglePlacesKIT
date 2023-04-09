
import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject{
    func didTapPlace(with coordinate: CLLocationCoordinate2D)
    func presentBottomSheet(place:Place)
}

class ResultsViewController: UIViewController {
 
    weak var delegate: ResultsViewControllerDelegate?

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var places : [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        view.backgroundColor = .clear
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let place):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: place.coordinate ?? CLLocationCoordinate2D(latitude: .infinity, longitude: .infinity))
                    self?.delegate?.presentBottomSheet(place: place)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ResultsViewController{
    public func update(with places: [Place]){
        self.tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
}
