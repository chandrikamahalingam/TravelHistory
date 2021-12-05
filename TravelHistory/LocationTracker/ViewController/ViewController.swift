//
//  ViewController.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = LocationTrackerViewModel()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.appDelegate.VC = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 45
        DispatchQueue.main.async {
            self.viewModel.retriveLocationData()
            self.tableView.reloadData()
        }
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell") as! LocationTableViewCell
        if self.viewModel.locationArray.count > indexPath.row {
            cell.loadData(self.viewModel.locationArray[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationMapViewController") as? LocationMapViewController {
            if self.viewModel.locationArray.count > indexPath.row {
                vc.locationData = self.viewModel.locationArray[indexPath.row]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension ViewController {
    func fetchLocation() {
        self.viewModel.retriveLocationData()
        self.tableView.reloadData()
    }
}
