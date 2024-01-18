//
//  TableViewCell.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/17.
//

import Foundation
import UIKit

//MARK: - TopThreePetsCell
class TopThreePetsCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    lazy var viewModel: PetsViewModel = PetsViewModel()
    lazy var pageControl: UIPageControl = UIPageControl(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewModel.delegate = self
        
        addSubviews()
        setupCollectionView()
        setupConstraints()
        viewModel.start()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubviews(){
        self.addSubview(collectionView)
        self.addSubview(pageControl)
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = 260.0
//        let minimumInteritemSpacing = 4.0
//        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 0.001
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: CGFloat(minimumInteritemSpacing), left: CGFloat(minimumInteritemSpacing), bottom: CGFloat(minimumInteritemSpacing), right: CGFloat(minimumInteritemSpacing))
        
//        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
        collectionView.backgroundColor = .gray
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellReuseId.collectionCell1_id)
        contentView.isUserInteractionEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.tag = row
//        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = TOP_THREE
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageChanged(_:)),
                              for: UIControl.Event.valueChanged)
        
        self.separatorInset = UIEdgeInsets(top: 0, left: itemWidth/2, bottom: 0, right: itemWidth/2)
    }
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension TopThreePetsCell: UICollectionViewDataSource {
    
    // number Of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of cells per section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TOP_THREE
    }
    
    // Edit cell format
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseId.collectionCell1_id, for: indexPath)

        let cellPic = UIImageView(frame: cell.bounds)
//        cellPic.contentMode = .scaleAspectFill
        cellPic.image = UIImage(named: "placeholder")
        if (viewModel.petImages.count > 0) {
            let item = viewModel.petImages[indexPath.row]
            cellPic.setImage(item.imageURL)
        }
        cell.addSubview(cellPic)
        return cell
    }
}

extension TopThreePetsCell: UICollectionViewDelegate {
    // Called after each scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Calculate which page is currently displayed by offsetting the scrollView content
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        // Set the pageController of current page
        pageControl.currentPage = page
    }
    
    // Event handling when clicking on page widgets
    @objc func pageChanged(_ sender: UIPageControl) {
        // Calculate the offset that scrollView needs to display based on the number of pages clicked
        var frame = collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        // Display the current page content
        collectionView.scrollRectToVisible(frame, animated: true)
    }
    // selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected the No.\(indexPath.item) item.")
    }
}

extension TopThreePetsCell: PetsViewModelDelegate {
    func showError(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    func reloadData() {
        collectionView.reloadData()
    }
}

//MARK: - OtherPetsCell
class OtherPetsCell: UITableViewCell {
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    lazy var viewModel: PetsViewModel = PetsViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewModel.delegate = self
        
        addSubviews()
        setupCollectionView()
        setupConstraints()
        viewModel.start()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews(){
        self.addSubview(collectionView)
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let itemWidth = 110
        let itemHeight = 80
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellReuseId.collectionCell2_id)
        collectionView.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.scrollsToTop = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.isUserInteractionEnabled = false
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension OtherPetsCell: UICollectionViewDataSource {
    
    // number Of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of cells per section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TOP_TEN - TOP_THREE
    }
    
    // Edit cell format
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseId.collectionCell2_id, for: indexPath)
        
        let cellPic = UIImageView(frame: cell.bounds)
        cellPic.image = UIImage(named: "placeholder")
        if (viewModel.petImages.count > 0) {
            let item = viewModel.petImages[indexPath.row + 3]
            cellPic.setImage(item.imageURL)
        }
        cell.addSubview(cellPic)
        return cell
    }
}

extension OtherPetsCell: UICollectionViewDelegate {
    // selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected the No.\(indexPath.item) item.")
    }
}

extension OtherPetsCell: PetsViewModelDelegate {
    func showError(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    func reloadData() {
        collectionView.reloadData()
    }
}

//MARK: - BreedsCell
class BreedsCell: UITableViewCell {
    lazy var petName = UILabel(frame: .zero)
    lazy var petAvatar = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupCollectionView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews(){
        self.addSubview(petName)
        self.addSubview(petAvatar)
    }
    
    func setupCollectionView() {
        petAvatar.layer.masksToBounds = true

        petName.textColor = UIColor.black
        petName.font = UIFont.systemFont(ofSize: 20)
        petName.textAlignment = .left
    }
    
    func setupConstraints() {
        petAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petAvatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            petAvatar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            petAvatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            petAvatar.widthAnchor.constraint(equalTo: petAvatar.heightAnchor)
        ])
        
        petName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petName.leadingAnchor.constraint(equalTo: petAvatar.trailingAnchor, constant: 15),
            petName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
