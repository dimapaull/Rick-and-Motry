//
//  CharacterTableViewCell.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 8.12.23.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - Public method
    public func configure(with info: (String?, String?)) {
        infoTitleLabel.text = info.1
        infoValueLabel.text = info.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private variables
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Male"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let infoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = ButtonAppearance.textColotForInfo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textAlignment = .left
        return label
    }()
}

// MARK: - Private methods
private extension CharacterTableViewCell {
    func initialize() {
        backgroundColor = .white
        selectionStyle = .none
        
        // MARK: Add subview
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(infoValueLabel)
        
        // MARK: Constants
        enum UIConstants {
            static let userImageSize: CGFloat = 30
            static let usernameFontSize: CGFloat = 12
        }
        
        // MARK: Info title label constraints
        NSLayoutConstraint.activate([
            infoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            infoTitleLabel.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        // MARK: Info value label constraints
        NSLayoutConstraint.activate([
            infoValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoValueLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor),
            infoValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoValueLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
