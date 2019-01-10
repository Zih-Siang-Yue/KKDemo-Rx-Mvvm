//
//  PlayListDetailViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/25.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxDataSources
import SVProgressHUD

class PlayListDetailViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private static let cellId = "PlayListTableViewCell"
    let vm: PlayListDetailViewModel
    
    let dataSource = RxTableViewSectionedReloadDataSource<TrackSection> (configureCell: { (ds, tv, ip, item)  in
        let cell = tv.dequeueReusableCell(withIdentifier: PlayListDetailViewController.cellId) as! PlayListTableViewCell
        cell.titleLabel.text = item.name
        cell.albumImageView.sd_setImage(with: URL(string: item.album.images.first!.url)!, completed: nil)
        return cell
    }, titleForHeaderInSection: { dataSource, index in
        return dataSource.sectionModels[index].header
    })
    
    //MARK: init
    init(vm: PlayListDetailViewModel) {
        self.vm = vm
        super.init(nibName: "PlayListDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.binding()
        self.vm.fetchInfo()
    }
    
    private func configTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.tableView.register(UINib.init(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
    }
    
    private func binding() {
        self.vm.output.section
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: rx.disposeBag)
        
        self.vm.output.isFetching
            .drive(onNext: { (fetching) in
                if fetching {
                    SVProgressHUD.show()
                }
                else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: rx.disposeBag)
        
        self.tableView.rx
            .modelSelected(TrackModel.self)
            .subscribe({ (track) in
                let input = TrackViewModel.Input(model: track.element!)
                let vm = TrackViewModel(input: input)
                let vc = TrackViewController(vm: vm)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
