//
//  LocationTableViewCell.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var snapshotImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.shadowView.elevationEffect()
        self.snapshotImageView.setCornerRadius()
    }
    func loadData(_ data: LocationEntity) {
        self.titleLabel.text = data.location_name
        self.dateLabel.text = data.dateString
        loadSnapshot(data.latitude, long: data.longitude)
    }
    func loadSnapshot(_ lat: Double, long: Double) {
        let options: MKMapSnapshotter.Options = .init()
        options.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        options.size = CGSize(width: 75, height: 75)
        options.mapType = .standard
        options.showsBuildings = true
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                self.snapshotImageView.image = snapshot.image
            }
            else {
                print("Something went wrong")
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
