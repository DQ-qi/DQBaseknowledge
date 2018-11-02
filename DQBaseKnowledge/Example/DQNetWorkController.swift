//
//  DQNetWorkController.swift
//  DQBaseKnowledge
//
//  Created by dengqi on 2018/11/2.
//  Copyright © 2018 XXX. All rights reserved.
//

import UIKit

class DQNetWorkController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(netTitleLab)
        self.navigationItem.title = "NetWork"
        let netWorkTool = DQNetWorkTool.shareInstance()
        netWorkTool?.startNetWork()
        netWorkTool?.netWorkResult = { (networkModel) in
            if let model = networkModel {
                DispatchQueue.main.async {
                    self.netTitleLab.text = model.networkName + " " + model.netWorkStyleName
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        netTitleLab.frame = CGRect.init(x: 0, y: 85, width: view.frame.size.width, height: 30)
        netTitleLab.center = CGPoint(x: view.center.x, y: 200)
    }
    
    lazy var netTitleLab:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.text = "NO NetWork"
        return view
    }()
}
