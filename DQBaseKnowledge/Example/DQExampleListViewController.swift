//
//  DQExampleListViewController.swift
//  DQBaseKnowledge
//
//  Created by dengqi on 2018/11/2.
//  Copyright © 2018 XXX. All rights reserved.
//

import UIKit

class DQExampleListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color.white
        self.navigationItem.title = "Example"
        self.view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let dataSource:[(title: String,viewController: UIViewController)] = [(title: "网络监测",viewController: DQNetWorkController()),(title: "网络监测",viewController: DQNetWorkController())]

    
}
extension DQExampleListViewController {
    
    @objc func dq_monitoringNetwork() {
        
        
    }
    
}

extension DQExampleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        let dict = dataSource[indexPath.row]
        cell?.textLabel?.text = dict.title
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

extension DQExampleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = dataSource[indexPath.row]
        self.navigationController?.pushViewController(dict.viewController, animated: true)
    }
}
