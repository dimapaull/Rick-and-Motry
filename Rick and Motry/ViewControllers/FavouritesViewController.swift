//
//  FavouritesViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    //MARK: - Public methods
    public func addCharacter(character: CharacterCard) {
        characterCardArray.append(character)
    }
    
    public func removeCharacter(character: CharacterCard) {
        if let index = characterCardArray.firstIndex(of: character) {
            characterCardArray.remove(at: index)
        }
    }
    
    //MARK: - Private variables
    private var characterCardArray = [CharacterCard]()
    private var collectionView: UICollectionView!
    
    //MARK: - Lifecicles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navigation bar
        navigationController?.navigationBar.isHidden = false
        collectionView.reloadData()
    }
}

// MARK: - Private methods
private extension FavouritesViewController {
    func setupVC() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.barTintColor = .white
        
        addNavBarTitle()
        createCollectionView()
        layout()
    }
    
    func addNavBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Favourites episodes"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .black
        titleLabel.minimumScaleFactor = 0.75
        navigationItem.titleView = titleLabel
    }
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EpisodeCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Constants
    enum UIConstants {
        static let collectionViewTop: CGFloat = 100
        static let collectionViewCellHeight: CGFloat = 357
    }
    
    //MARK: - Constraints
    func layout() {
        view.addSubview(collectionView)
        
        // MARK: CollectionView constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.collectionViewTop),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Collection view delegate datasource, delegate extension
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterCardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EpisodeCollectionViewCell.self), for: indexPath) as! EpisodeCollectionViewCell
        cell.delegate = self
        
        let characterCard = characterCardArray[indexPath.row]
        cell.configure(characterCard: characterCard, cellIndex: indexPath.row)
        
        return cell
    }
}

// MARK: - Extension collection view delegate flow layout
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    // size for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 50, height: UIConstants.collectionViewCellHeight)
    }
}

// MARK: - Extension cell item delegate
extension FavouritesViewController: CellItemDelegate {
    func favoriteButtonClick(inCell cell: UICollectionViewCell, character: CharacterCard) {
        removeCharacter(character: character)
        collectionView.reloadData()
        let navController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let EpisodesVC = navController.topViewController as! EpisodesViewController
        EpisodesVC.removeFavoriteCharacter(character: character)
    }
    
    func deleteCell(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        characterCardArray.remove(at: indexPath.item)
        collectionView.reloadData()
    }
    
    func imageViewClick(characterCard: CharacterCard) {
        let newVC = CharacterDetailsViewController()
        newVC.characterCard = characterCard
        navigationController?.pushViewController(newVC, animated: true)
    }
}
