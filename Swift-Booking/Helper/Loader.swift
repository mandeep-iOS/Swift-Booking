//
//  Loader.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//

import UIKit

//MARK: Custom Loader Class for show loader while fetching data
class Loader {
    static let shared = Loader()
    let activityIndicator = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    private init() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.font = .systemFont(ofSize: 16.0, weight: .semibold, width: .expanded)
    }

    func showLoader(_ view: UIView) {
            self.activityIndicator.startAnimating()
            view.addSubview(self.activityIndicator)
            let loaderViewSize = self.activityIndicator.frame.size
            let viewSize = view.frame.size
            self.activityIndicator.frame = CGRect(x: (viewSize.width - loaderViewSize.width) / 2, y: (viewSize.height - loaderViewSize.height) / 2, width: loaderViewSize.width, height: loaderViewSize.height)
            view.addSubview(self.loadingLabel)
            self.loadingLabel.frame = CGRect(x: 0, y: self.activityIndicator.frame.maxY + 35, width: viewSize.width, height: 25)
    }

    func hideLoader() {
            self.activityIndicator.stopAnimating()
            self.loadingLabel.removeFromSuperview()
    }
}
