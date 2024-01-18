//
//  ViewController.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/11.
//

import UIKit

class PetsViewController: UIViewController{
    
    private lazy var tableView = UITableView(frame: .zero)
    var viewModel: PetsViewModel!
    
    var loadMoreView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PetsViewModel()
        viewModel.delegate = self
        
        setupUI()
        setupConstraints()
        viewModel.start()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.register(TopThreePetsCell.self, forCellReuseIdentifier: CellReuseId.tableCell1_id)
        tableView.register(OtherPetsCell.self, forCellReuseIdentifier: CellReuseId.tableCell2_id)
        tableView.register(BreedsCell.self, forCellReuseIdentifier: CellReuseId.tableCell3_id)
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = BreedsCell.SeparatorStyle.singleLine
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setupInfiniteScrollingView()
        tableView.tableFooterView = self.loadMoreView
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        view.bringSubviewToFront(tableView)
    }
    
    private func setupInfiniteScrollingView() {
        loadMoreView = UIView(frame: CGRect(x:0, y: tableView.contentSize.height,
                                                 width: tableView.bounds.size.width, height: 60))
        loadMoreView!.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        loadMoreView!.backgroundColor = .white
         
        let activityViewIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityViewIndicator.color = UIColor.darkGray
        activityViewIndicator.startAnimating()
        loadMoreView!.addSubview(activityViewIndicator)
        
        activityViewIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityViewIndicator.centerXAnchor.constraint(equalTo: loadMoreView!.centerXAnchor),
            activityViewIndicator.centerYAnchor.constraint(equalTo: loadMoreView!.centerYAnchor)
        ])
    }
}

extension PetsViewController: UITableViewDataSource {
    // number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.petNames.count + 2
    }
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndex = indexPath.row
        switch cellIndex {
        case 0:
            var cell: TopThreePetsCell? = tableView.dequeueReusableCell(withIdentifier: CellReuseId.tableCell1_id) as? TopThreePetsCell
            if cell == nil {
                cell = TopThreePetsCell(style: .default, reuseIdentifier: CellReuseId.tableCell1_id)
            }
            return cell!
        case 1:
            var cell: OtherPetsCell? = tableView.dequeueReusableCell(withIdentifier: CellReuseId.tableCell2_id) as? OtherPetsCell
            if cell == nil {
                cell = OtherPetsCell(style: .default, reuseIdentifier: CellReuseId.tableCell2_id)
            }
            return cell!
        default:
            var cell: BreedsCell? = tableView.dequeueReusableCell(withIdentifier: CellReuseId.tableCell3_id) as? BreedsCell
            if cell == nil {
                cell = BreedsCell(style: .default, reuseIdentifier: CellReuseId.tableCell3_id)
            }
            if (viewModel.petNames.count > 0) {
                let item = viewModel.petNames[indexPath.row - 2]
                cell?.petName.text = item.name
            }
            cell?.petAvatar.image = UIImage(named: "placeholder")
            
            if (indexPath.row == viewModel.petNames.count - 1) {
                viewModel.load()
            }
            return cell!
        }
    }
}

extension PetsViewController: UITableViewDelegate {
    // Set cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 260.0
        case 1:
            return 100.0
        default:
            return 80.0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    // Execute this method after selecting the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension PetsViewController: PetsViewModelDelegate {
    func showError(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
