//
//  EpisodeCollectionViewCell.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import Foundation
import UIKit

//MARK: - Protocol for cell tap
protocol CellItemDelegate {
    func imageViewClick(characterCard: CharacterCard)
    func favoriteButtonClick(inCell cell: UICollectionViewCell, character: CharacterCard)
    func deleteCell(inCell cell: UICollectionViewCell)
}

//MARK: - EpisodeCollectionViewCell
class EpisodeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public variables
    public var delegate : CellItemDelegate?
    public var characteInformation: CharacterInfo?
    
    //MARK: - Public methods
    public func configure(characterCard: CharacterCard, cellIndex: Int) {
        character = characterCard
        episodeImageView.image = characterCard.image
        characterNameLabel.text = characterCard.characterName
        nameAndEpisodeNumberLabel.text = "\(characterCard.episodeName ?? "") | \(characterCard.episodeNumber ?? "")"
        heartButton.tag = cellIndex
        self.cellIndex = cellIndex
        imageForHeart()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private variables
    private var character: CharacterCard?
    private var cellIndex = Int()
    private var isFavorite = false
    
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private let nameAndEpisodeNumberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = ButtonAppearance.backgroundColorForCellView
        return view
    }()
    
    private let playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "playIcon")
        return imageView
    }()
    
    private let nameAndEpisodeNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

// MARK: - Private methods
private extension EpisodeCollectionViewCell {
    
    //MARK: Add tap gesture recognizer for image view
    func addTapRec() {
        let tapOfEpisodeImageRec = UITapGestureRecognizer(target: self, action: #selector(episodeImageTapped))
        episodeImageView.isUserInteractionEnabled = true
        episodeImageView.addGestureRecognizer(tapOfEpisodeImageRec)
    }
    
    //MARK: Add action of episode imageView tap
    @objc func episodeImageTapped() {
        guard let character = character else { return }
        self.delegate?.imageViewClick(characterCard: character)
    }
    
    func initialize() {
        addShadowForCell()
        addTapRec()
        layout()
        setupGestureRecognizer()
        heartButton.addTarget(self, action: #selector(heartButtonPressed(target:)), for: .touchUpInside)
    }
    
    private func setupGestureRecognizer() {
        //Add swipe gesture recognizer by cell for delete
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(swipedCell(target:)))
        swipeRec.direction = .left
        contentView.addGestureRecognizer(swipeRec)
    }
    
    @objc func swipedCell(target: UISwipeGestureRecognizer) {
        //Call delegate methods and trans data
        delegate?.deleteCell(inCell: self)
    }
    
    @objc func heartButtonPressed(target: UIButton) {
        isFavorite.toggle()
        guard var char = character else { return }
        if isFavorite {
            char.isFavorite = true
            target.setImage(UIImage(named: "HeartPressed"), for: .normal)
        } else {
            char.isFavorite = false
            target.setImage(UIImage(named: "Heart"), for: .normal)
        }
        
        // Scale animation
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [UIView.KeyframeAnimationOptions.beginFromCurrentState, UIView.KeyframeAnimationOptions(rawValue: 1)], animations: {
            // add scale
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6 / 2, animations: {
                target.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            // decrease scale
            UIView.addKeyframe(withRelativeStartTime: 0.6 / 2, relativeDuration: 0.6 / 2, animations: {
                target.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        self.delegate?.favoriteButtonClick(inCell: self, character: char)
    }
    
    func imageForHeart() {
        guard let fav = character?.isFavorite else { return }
        fav ? heartButton.setImage(UIImage(named: "HeartPressed"), for: .normal) : heartButton.setImage(UIImage(named: "Heart"), for: .normal)
    }
    
    // MARK: Add layout shadow for cell
    func addShadowForCell() {
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
    // MARK: Constants
    private enum UIConstants {
        static let episodeImageHeight: CGFloat = 232
        static let characterNameLabelHeight: CGFloat = 54
        static let characterNameLabelLeading: CGFloat = 20
        static let playImageViewSize: CGFloat = 34
        static let playImageViewTrailing: CGFloat = -16
        static let heartButtonSize: CGFloat = 40
        static let heartButtonLeading: CGFloat = 40
        static let nameAndEpisodeNumberLabelHeight: CGFloat = 70
        static let nameAndEpisodeNumberLabelWidth: CGFloat = 158
        static let nameAndEpisodeNumberLabelTop: CGFloat = 0
        static let nameAndEpisodeNumberLabelLeading: CGFloat = 65
    }
    
    // MARK: Constraints
    func layout() {
        
        // MARK: Add subview
        contentView.addSubview(episodeImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(nameAndEpisodeNumberView)
        nameAndEpisodeNumberView.addSubview(nameAndEpisodeNumberLabel)
        nameAndEpisodeNumberView.addSubview(playImageView)
        nameAndEpisodeNumberView.addSubview(heartButton)
        
        // MARK: Episode image view constraints
        NSLayoutConstraint.activate([
            episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            episodeImageView.heightAnchor.constraint(equalToConstant: UIConstants.episodeImageHeight),
            episodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        // MARK: Character name label constraints
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: episodeImageView.bottomAnchor),
            characterNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.characterNameLabelHeight),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.characterNameLabelLeading),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        // MARK: Name and episode number view constraints
        NSLayoutConstraint.activate([
            nameAndEpisodeNumberView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            nameAndEpisodeNumberView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameAndEpisodeNumberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameAndEpisodeNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        // MARK: Name and episode number label constraints
        NSLayoutConstraint.activate([
            nameAndEpisodeNumberLabel.widthAnchor.constraint(equalToConstant: UIConstants.nameAndEpisodeNumberLabelWidth),
            nameAndEpisodeNumberLabel.heightAnchor.constraint(equalToConstant: UIConstants.nameAndEpisodeNumberLabelHeight),
            nameAndEpisodeNumberLabel.topAnchor.constraint(equalTo: nameAndEpisodeNumberView.topAnchor, constant: UIConstants.nameAndEpisodeNumberLabelTop),
            nameAndEpisodeNumberLabel.leadingAnchor.constraint(equalTo: nameAndEpisodeNumberView.leadingAnchor, constant: UIConstants.nameAndEpisodeNumberLabelLeading),
        ])
        
        // MARK: Play image view constraints
        NSLayoutConstraint.activate([
            playImageView.widthAnchor.constraint(equalToConstant: UIConstants.playImageViewSize),
            playImageView.heightAnchor.constraint(equalToConstant: UIConstants.playImageViewSize),
            playImageView.centerYAnchor.constraint(equalTo: nameAndEpisodeNumberLabel.centerYAnchor),
            playImageView.trailingAnchor.constraint(equalTo: nameAndEpisodeNumberLabel.leadingAnchor, constant: UIConstants.playImageViewTrailing),
        ])
        
        // MARK: Heart image view constraints
        NSLayoutConstraint.activate([
            heartButton.widthAnchor.constraint(equalToConstant: UIConstants.heartButtonSize),
            heartButton.heightAnchor.constraint(equalToConstant:  UIConstants.heartButtonSize),
            heartButton.centerYAnchor.constraint(equalTo: nameAndEpisodeNumberLabel.centerYAnchor),
            heartButton.leadingAnchor.constraint(equalTo: nameAndEpisodeNumberLabel.trailingAnchor, constant: UIConstants.heartButtonLeading),
        ])
    }
}
