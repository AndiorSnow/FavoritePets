//
//  ViewController.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/11.
//

import UIKit

class ViewController: UIViewController{
    
    private var tabPicView: UIScrollView!
    private var pageControl: UIPageControl!
    private var collecPicView: UICollectionView!
    private var tablePicView: UITableView!
    private let cellID = "cellID"
    
    var petPics = [
        ["name":"Mimi","pic":"pet1.png"],
        ["name":"Pipi","pic":"pet2.png"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        tabPicView = UIScrollView(frame: CGRect.zero)
        tabPicView.backgroundColor = UIColor.gray
        view.addSubview(tabPicView)
        tabPicView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabPicView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.safeAreaInsets.left),
            tabPicView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            tabPicView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.safeAreaInsets.right),
            tabPicView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 260)
        ])
        
        tabPicView.contentSize = CGSize(
            width: CGFloat(view.bounds.width) * CGFloat(self.petPics.count), height: 260
        )
        
        tabPicView.alwaysBounceHorizontal = true
        tabPicView.showsHorizontalScrollIndicator = false
        tabPicView.showsVerticalScrollIndicator = false
        tabPicView.scrollsToTop = false
        tabPicView.isPagingEnabled = true
        
        let size = view.bounds.size
        for (seq, petPic) in petPics.enumerated() {
            let subPicView = UIImageView(image: UIImage(named: petPic["pic"]!))
            subPicView.frame = CGRect(x: CGFloat(seq) * (size.width - view.safeAreaInsets.left -
                                                         view.safeAreaInsets.right), 
                                      y: 0, width: size.width, height: 260)
            tabPicView.addSubview(subPicView)
        }

        pageControl = UIPageControl(frame: CGRect.zero)
        view.addSubview(pageControl)
        
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = petPics.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageChanged(_:)),
                              for: UIControl.Event.valueChanged)
        
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom - 500)
        ])
        
        
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let picW = 110
        let picH = 80
        layout.itemSize = CGSize(width: picW, height: picH)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        collecPicView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collecPicView.backgroundColor = UIColor.init(white: 0.97, alpha: 1.0)
        
        collecPicView.alwaysBounceHorizontal = true
        collecPicView.showsHorizontalScrollIndicator = false
        collecPicView.showsVerticalScrollIndicator = false
        collecPicView.alwaysBounceVertical = false
        collecPicView.scrollsToTop = false
        
        collecPicView.delegate = self
        collecPicView.dataSource = self
        
        collecPicView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collecPicView)
        collecPicView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collecPicView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.safeAreaInsets.left),
            collecPicView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 260),
            collecPicView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.safeAreaInsets.right),
            collecPicView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 360)
        ])
                
        
        tablePicView = UITableView(frame: CGRect.zero, style: .grouped)
        tablePicView.backgroundColor = UIColor.white
        view.addSubview(tablePicView)
        tablePicView.dataSource = self
        tablePicView.delegate = self
        tablePicView.translatesAutoresizingMaskIntoConstraints = false
        tablePicView.estimatedSectionHeaderHeight = 0.001

        NSLayoutConstraint.activate([
            tablePicView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.safeAreaInsets.left),
            tablePicView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 360),
            tablePicView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.safeAreaInsets.right),
            tablePicView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom)
        ])
    }
}

extension ViewController: UIScrollViewDelegate {
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
        var frame = tabPicView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        // Display the current page content
        tabPicView.scrollRectToVisible(frame, animated: true)
    }
}


extension ViewController: UICollectionViewDataSource {
    
    // number Of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of cells per section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // Edit cell format
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let cellPic = UIImageView(frame: cell.bounds)
        cellPic.image = UIImage(named: "placeholder")
        cell.addSubview(cellPic)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    // selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected the No.\(indexPath.item) item.")
    }
}


extension ViewController: UITableViewDataSource {
    // number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: tableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? tableViewCell
        if cell == nil {
            cell = tableViewCell(style: .default, reuseIdentifier: cellId)
        }
        //let dict: Dictionary = petPics[indexPath.row]
        cell?.petAvatar.image = UIImage(named: "placeholder")
        cell?.petName.text = "Name"
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    // Set cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    // Execute this method after selecting the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

