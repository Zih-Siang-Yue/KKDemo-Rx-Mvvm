//
//  FavoriteViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/20.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxDataSources

class FavoriteViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    private static let cellId = "FavoriteTableViewCell"
    let vm = FavoriteViewModel()

    let dataSource = RxTableViewSectionedReloadDataSource<TrackSection> ( configureCell: { (ds, tv, ip, item) in
        let cell = tv.dequeueReusableCell(withIdentifier: FavoriteViewController.cellId) as! FavoriteTableViewCell
        cell.titleLabel.text = item.name
        cell.subtitleLabel.text = item.album.artist.name
        cell.albumImageView.sd_setImage(with: URL(string: item.album.images.first!.url)!, completed: nil)
        return cell
    }, titleForHeaderInSection: { dataSource, index in
        return dataSource.sectionModels[index].header
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.binding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vm.fetchInfo()
    }

    func configTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    func binding() {
        self.vm.output.section
            .drive(self.tableView.rx.items(dataSource: dataSource))
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
