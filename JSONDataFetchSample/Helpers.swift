//
//  Helpers.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import UIKit

extension UIViewController {
    var presenterVC: UIViewController {
        parent?.presenterVC ?? parent ?? self
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        presenterVC.showDetailViewController(alert, sender: self)
    }
}

extension UITableViewController {
    func showSpinnerAtTheBottom() {
        guard let spinner = tableView.tableFooterView as? UIActivityIndicatorView
        else
        {
            let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            return
        }
        
        spinner.startAnimating()
        tableView.tableFooterView?.isHidden = false
    }
    
    func hideSpinnerAtTheBottom() {
        if let spinner = tableView.tableFooterView as? UIActivityIndicatorView {
            spinner.stopAnimating()
            tableView.tableFooterView?.isHidden = true
        }
    }
}

extension Date {
    func calculateTimeDifferenceInSeconds(from date: Date) -> Double {
        let nanoseconds = Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
        let milliseconds: Double = round(Double(nanoseconds)/Double(1000000))
        let seconds: Double = Double(milliseconds)/Double(1000)
        return seconds
    }
}

extension DispatchQueue {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.async(execute: work)
        }
    }
}

struct InValidURL: Error {}
