//
//  PlayListViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/17.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxDataSources
import SVProgressHUD

class PlayListViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private static let cellId = "PlayListTableViewCell"
    let vm = PlayListViewModel()
    
    //MARK: DataSource Setting
    private let dataSource = RxTableViewSectionedReloadDataSource<PlaylistSection> ( configureCell: { (dataSource, tableView, indexPath, item) in
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayListTableViewCell
        let model:PlaylistModel = item
        cell.titleLabel.text = item.name
        cell.albumImageView.sd_setImage(with: URL(string: item.images.first!.url)!, completed: nil)
        return cell
    }, titleForHeaderInSection: { dataSource, index in
        return dataSource.sectionModels[index].header
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.binding()
        self.vm.fetchInfo()
    }
    
    private func configTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.tableView.register(UINib.init(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
    }
    
    private func binding() {
        self.vm.output.section
            .drive(tableView.rx.items(dataSource: self.dataSource))
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
            .modelSelected(PlaylistModel.self)
            .subscribe({ (playlist) in
                let input = PlayListDetailViewModel.Input(id: playlist.element!.id)
                let vm = PlayListDetailViewModel(input: input)
                let vc = PlayListDetailViewController(vm: vm)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }

}
