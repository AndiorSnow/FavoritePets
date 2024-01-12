//
//  tableViewCell.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/12.
//

import UIKit

class tableViewCell: UITableViewCell {

    let width: CGFloat = UIScreen.main.bounds.width
    var petName: UILabel!      // name
    var petAvatar: UIImageView!    // avatar
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // avatar
        petAvatar = UIImageView(frame: CGRect.zero)
        petAvatar.layer.masksToBounds = true
        
        // name
        petName = UILabel(frame: CGRect(x: 74, y: 18, width: 70, height: 15))
        petName.textColor = UIColor.black
        petName.font = UIFont.systemFont(ofSize: 20)
        petName.textAlignment = .left
        
        contentView.addSubview(petAvatar)
        contentView.addSubview(petName)
        
        petAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            petAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            petAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            petAvatar.widthAnchor.constraint(equalTo: petAvatar.heightAnchor)
        ])
        
        petName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            petName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            //petAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            //petAvatar.widthAnchor.constraint(equalTo: petAvatar.heightAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
