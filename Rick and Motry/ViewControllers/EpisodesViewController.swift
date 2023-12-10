//
//  EpisodesViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    //MARK: - Public methods
    public func removeFavoriteCharacter(character: CharacterCard) {
        //Remove favorite character in main array card
        if let index = characterCardArray.firstIndex(of: character) {
            characterCardArray[index].isFavorite = false
        }
        //Remove favorite character in filter array card
        if let index = filteredCardArray.firstIndex(of: character) {
            filteredCardArray[index].isFavorite = false
        }
        collectionView.reloadData()
    }
    
    //MARK: - Private variables
    private var characterCardArray = [CharacterCard]()
    private var filteredCardArray =  [CharacterCard]()
    private var collectionView: UICollectionView!
    private var networkManager = NetworkManager()
    private var isFilterMode = false
    private var searchFilterType = FilterSettings.nameOfEpisode
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.cornerRadius = 8
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Name or episode (ex. S01E01)"
        return searchBar
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Filter"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()
    
    //MARK: - Lifecicles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navigation bar
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private methods
private extension EpisodesViewController {
    
    func setupVC() {
        getData()
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        searchBar.delegate = self
        view.backgroundColor = .white
        createCollectionView()
        collectionView.reloadData()
        layout()
    }
    
    func getData() {
        for id in 0...19 {
            networkManager.loadEpisode(id: id) { [weak self] stringArray in
                DispatchQueue.main.async {
                    let character = CharacterCard(characterName: stringArray?.character.name,
                                                  image: stringArray?.image,
                                                  episodeName: stringArray?.episode.name,
                                                  episodeNumber: stringArray?.episode.episode,
                                                  status: stringArray?.character.status,
                                                  species: stringArray?.character.species,
                                                  type: stringArray?.character.type,
                                                  gender: stringArray?.character.gender,
                                                  origin: stringArray?.character.origin?.name,
                                                  location: stringArray?.character.location?.name,
                                                  isFavorite: false)
                    
                    self?.characterCardArray.append(character)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func filterPressed() {
        let filterVC = FilterViewController()
        filterVC.filterDelegate = self
        present(filterVC, animated: true)
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
        static let logoTopConstraint: CGFloat = 57
        static let logoWidthConstraint: CGFloat = 312
        static let logoHeightConstraint: CGFloat = 104
        static let searchHeightConstraint: CGFloat = 56
        static let searchBarTopAnchor: CGFloat = 20
        static let filterButtonTopAnchor: CGFloat = 10
        static let collectionViewTopAnchor: CGFloat = 10
        static let collectionViewCellHeight: CGFloat = 357
    }
    
    // MARK: - Constraints
    func layout() {
        view.addSubview(logoImageView)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        
        // MARK: Logo constraints
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.logoTopConstraint),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: UIConstants.logoHeightConstraint),
            logoImageView.widthAnchor.constraint(equalToConstant: UIConstants.logoWidthConstraint),
        ])
        
        // MARK: SearchBar constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UIConstants.searchBarTopAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: UIConstants.searchHeightConstraint),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
        ])
        
        // MARK: Filter button constraints
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: UIConstants.filterButtonTopAnchor),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: UIConstants.searchHeightConstraint),
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
        ])
        
        // MARK: CollectionView constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: UIConstants.collectionViewTopAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - Collection view delegate datasource, delegate extension
extension EpisodesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Check filter mode and choose requirement array
        return isFilterMode ? filteredCardArray.count : characterCardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Appointment cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EpisodeCollectionViewCell.self), for: indexPath) as! EpisodeCollectionViewCell
        
        cell.delegate = self
        
        //Check filter mode and configure cell
        if isFilterMode {
            let characterCard = filteredCardArray[indexPath.row]
            cell.configure(characterCard: characterCard, cellIndex: indexPath.row)
        } else {
            let characterCard = characterCardArray[indexPath.row]
            cell.configure(characterCard: characterCard, cellIndex: indexPath.row)
        }
        return cell
    }
}

// MARK: - Extrnsion collection view delegate flow layout
extension EpisodesViewController: UICollectionViewDelegateFlowLayout {
    // size for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 50, height: UIConstants.collectionViewCellHeight)
    }
}

//MARK: - Extension cell item delegate favorite
//For interaction with user in cell
extension EpisodesViewController: CellItemDelegate {
    
    //Favorite button click
    func favoriteButtonClick(inCell cell: UICollectionViewCell, character: CharacterCard) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        //Get FavoriteVC
        let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let FavoriteVC = navController.topViewController as! FavouritesViewController
        
        //Check favorite character and add or remove this character for favoriteVC
        if character.isFavorite {
            if !isFilterMode {
                characterCardArray[indexPath.item].isFavorite = true
                FavoriteVC.addCharacter(character: characterCardArray[indexPath.item])
            } else {
                filteredCardArray[indexPath.item].isFavorite = true
                FavoriteVC.addCharacter(character: filteredCardArray[indexPath.item])
            }
        } else {
            if !isFilterMode {
                FavoriteVC.removeCharacter(character: characterCardArray[indexPath.item])
                characterCardArray[indexPath.item].isFavorite = false
            } else {
                FavoriteVC.removeCharacter(character: filteredCardArray[indexPath.item])
                filteredCardArray[indexPath.item].isFavorite = false
            }
        }
    }
    
    //Delete cell by swipe
    func deleteCell(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        //Check filter mode
        if isFilterMode {
            filteredCardArray.remove(at: indexPath.item)
            collectionView.reloadData()
        } else {
            characterCardArray.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
    
    //Image view click
    func imageViewClick(characterCard: CharacterCard) {
        let newVC = CharacterDetailsViewController()
        //For show choosed card
        newVC.characterCard = characterCard
        navigationController?.pushViewController(newVC, animated: true)
    }
}

//MARK: - Extension search bar delegate
extension EpisodesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        if searchBar.text == "" {
            isFilterMode = false
            collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCardArray = characterCardArray
        let valueUser = searchText.lowercased()
        
        //Check searchFilterType value
        switch searchFilterType {
        case .nameOfEpisode:
            //Remove not appropriate values
            filteredCardArray = filteredCardArray.filter({
                $0.episodeNumber!.lowercased().contains(valueUser)
            })
        case .numberOfEpisode:
            filteredCardArray = filteredCardArray.filter({
                //Filter by episode number
                $0.episodeNumber!.lowercased().components(separatedBy: "e")[1].contains(valueUser)
            })
        case .nameOfCharacter:
            filteredCardArray = filteredCardArray.filter({
                $0.characterName!.lowercased().contains(valueUser)
            })
        case .nameOfLoaction:
            filteredCardArray = filteredCardArray.filter({
                $0.location!.lowercased().contains(valueUser)
            })
        }
        isFilterMode = true
        collectionView.reloadData()
    }
}

//MARK: - Extension search filter delegate
//For tap of filter button in filter vc
extension EpisodesViewController: SearchFilterDelegate {
    func didFilterTapped(selectedFilter: FilterSettings) {
        // Set fiter type
        self.searchFilterType = selectedFilter
        
        // Change placeholder
        switch selectedFilter {
        case .nameOfEpisode:
            searchBar.placeholder = "Name of episode (ex. S01E01)"
        case .nameOfCharacter:
            searchBar.placeholder = "Name of character (ex. Morty)"
        case .nameOfLoaction:
            searchBar.placeholder = "Name of location (ex. Earth)"
        case .numberOfEpisode:
            searchBar.placeholder = "Namber of episode (ex. 2)"
        }
    }
}
