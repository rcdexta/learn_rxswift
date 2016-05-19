//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by RC on 19/05/16.
//  Copyright © 2016 com.rcdexta. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    let disposableBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindEvents()
    }

    func setup(){
        tableView.dataSource = self
    }

    func bindEvents(){

        self.searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribeNext { [unowned self] (query) in
                self.shownCities = query == "" ? self.allCities : self.allCities.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
            }
            .addDisposableTo(disposableBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityPrototypeCell", forIndexPath: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }

}
