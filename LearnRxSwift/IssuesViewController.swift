//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by RC on 19/05/16.
//  Copyright © 2016 com.rcdexta. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift

class IssuesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    var provider: RxMoyaProvider<GitHub>!
    var issueTrackerModel: IssueTrackerModel!

    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }

    func setupRx() {
        // First part of the puzzle, create our Provider
        provider = RxMoyaProvider<GitHub>()

        // Now we will setup our model
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)

        // And bind issues to table view
        // Here is where the magic happens, with only one binding
        // we have filled up about 3 table view data source methods
        issueTrackerModel
            .trackIssues()
            .bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCellWithIdentifier("issueCell", forIndexPath: NSIndexPath(forRow: row, inSection: 0))
                cell.textLabel?.text = item.title

                return cell
            }
            .addDisposableTo(disposeBag)

        // Here we tell table view that if user clicks on a cell,
        // and the keyboard is still visible, hide it
        tableView
            .rx_itemSelected
            .subscribeNext { indexPath in
                if self.searchBar.isFirstResponder() == true {
                    self.view.endEditing(true)
                }
            }
            .addDisposableTo(disposeBag)
    }

    func url(route: TargetType) -> String {
        return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
    }
}
