//
//  CharacterDetailsViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 8.12.23.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    //MARK: - Public variables
    public var characterCard: CharacterCard?
 
    //MARK: - Private variables
    private let imagePicker = ImagePicker()
    private var informationsTableView: UITableView!
    private var characterInformationArray = [(String?, String?)]()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = UIConstants.characterImageSize / 2
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = ButtonAppearance.layerForImageColor.cgColor
        return imageView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Camera"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "Rick Sanchez"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 32)
        return label
    }()
    
    private let informationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Informations"
        label.textColor = ButtonAppearance.textColotForInfo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
 
    //MARK: - Lifecicles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}

// MARK: - Private methods
private extension CharacterDetailsViewController {
    //MARK: Setup method
    func setupVC() {
    
        cameraButton.addTarget(self, action: #selector(cameraPressed), for: .touchUpInside)
        
        // add character and title information in characterInformationArray
        characterInformationArray.append((characterCard?.gender, "Gender"))
        characterInformationArray.append((characterCard?.status, "Status"))
        characterInformationArray.append((characterCard?.species, "Specie"))
        characterInformationArray.append((characterCard?.origin, "Origin"))
        characterInformationArray.append((characterCard?.type, "Type"))
        characterInformationArray.append((characterCard?.location, "Location"))
        
        // setup choosed character
        characterImageView.image = characterCard?.image
        characterNameLabel.text = characterCard?.characterName
        
        view.backgroundColor = .white
        createNavigationItems()
        createTable()
        layout()
    }
    
    //MARK: Create navigation items
    func createNavigationItems() {
        // show nav bar
        navigationController?.navigationBar.isHidden = false
        
        // Add bottom shadow for nav nar
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.backgroundColor = UIColor.white.cgColor
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 10)
        navigationController?.navigationBar.layer.shadowRadius = 4
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        
        // Left bar item
        let leftNavButton = UIBarButtonItem(image: UIImage(named: "goBack"), style: .done, target: self, action: #selector(backPressed))
        leftNavButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftNavButton
        
        // Right bar item
        let rightNavButton = UIBarButtonItem(image: UIImage(named: "logo-black 1"), style: .plain, target: nil, action: nil)
        rightNavButton.tintColor = .black
        rightNavButton.isSpringLoaded = true
        navigationItem.rightBarButtonItem = rightNavButton
    }
    
    //MARK: Camera tap
    @objc func cameraPressed() {
        let actionController: UIAlertController = UIAlertController(title: "Загрузите изображение", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (alert: UIAlertAction!) -> () in
            self.camera()
        }
        let photoAction = UIAlertAction(title: "Галерея", style: .default) { (alert: UIAlertAction!) -> () in
            self.galaryPressed()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionController.addAction(cameraAction)
        actionController.addAction(photoAction)
        actionController.addAction(cancelAction)
        
        self.present(actionController, animated: true)
    }
    
    //camera action tap
    func camera() {
        imagePicker.showImagePicker(in: self, fromSourceType: .camera) { choosedImage in
            self.characterImageView.image = choosedImage
        }
    }
    
    //Method album action tap
    func galaryPressed() {
        imagePicker.showImagePicker(in: self, fromSourceType: .savedPhotosAlbum) { choosedImage in
            self.characterImageView.image = choosedImage
        }
    }
    
    // Tap of back nav item
    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    //Create table
    func createTable() {
        informationsTableView = UITableView(frame: .zero, style: .plain)
        informationsTableView.translatesAutoresizingMaskIntoConstraints = false
        informationsTableView.dataSource = self
        informationsTableView.backgroundColor = .white
        informationsTableView.showsVerticalScrollIndicator = false
        informationsTableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: String(describing: CharacterTableViewCell.self))
    }
    
    // MARK: Constants
    enum UIConstants {
        static let characterImageSize: CGFloat = 150
        static let characterImageTop: CGFloat = 124
        static let cameraImageSize: CGFloat = 32
        static let cameraButtonLeadingAnchor: CGFloat = 10
        static let characterNameLabelHeight: CGFloat = 40
        static let characterNameLabelWidth: CGFloat = 314
        static let characterNameLabelTop: CGFloat = 35
        static let informationsLabelHeight: CGFloat = 24
        static let informationsLabelWidth: CGFloat = 157
        static let informationsLabelTop: CGFloat = 20
        static let informationsLabelLeading: CGFloat = 24
        static let informationsTableViewTop: CGFloat = 5
        static let informationsTableViewLeading: CGFloat = 24
        static let informationsTableViewTrailing: CGFloat = -24
        static let informationsTableViewBottom: CGFloat = -30
    }
    
    // MARK: Constraints
    func layout() {
        view.addSubview(characterImageView)
        view.addSubview(cameraButton)
        view.addSubview(characterNameLabel)
        view.addSubview(informationsLabel)
        view.addSubview(informationsTableView)
        
        // MARK: CharacterImageView constraints
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalToConstant: UIConstants.characterImageSize),
            characterImageView.widthAnchor.constraint(equalToConstant: UIConstants.characterImageSize),
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.characterImageTop),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // MARK: cameraButton constraints
        NSLayoutConstraint.activate([
            cameraButton.heightAnchor.constraint(equalToConstant: UIConstants.cameraImageSize),
            cameraButton.widthAnchor.constraint(equalToConstant: UIConstants.cameraImageSize),
            cameraButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: UIConstants.cameraButtonLeadingAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor)
        ])
        
        // MARK: characterNameLabel constraints
        NSLayoutConstraint.activate([
            characterNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.characterNameLabelHeight),
            characterNameLabel.widthAnchor.constraint(equalToConstant: UIConstants.characterNameLabelWidth),
            characterNameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: UIConstants.characterNameLabelTop),
            characterNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // MARK: informationsLabel constraints
        NSLayoutConstraint.activate([
            informationsLabel.heightAnchor.constraint(equalToConstant: UIConstants.informationsLabelHeight),
            informationsLabel.widthAnchor.constraint(equalToConstant: UIConstants.informationsLabelWidth),
            informationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.informationsLabelLeading),
            informationsLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: UIConstants.informationsLabelTop)
        ])
        
        // MARK: informationsTableViewinformationsTableView constraints
        NSLayoutConstraint.activate([
            informationsTableView.topAnchor.constraint(equalTo: informationsLabel.bottomAnchor, constant: UIConstants.informationsTableViewTop),
            informationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.informationsTableViewLeading),
            informationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.informationsTableViewTrailing),
            informationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIConstants.informationsTableViewBottom)
        ])
    }
}

//MARK: - TableView datasource extension
extension CharacterDetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterInformationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as! CharacterTableViewCell
        cell.configure(with: characterInformationArray[indexPath.row])
        return cell
    }
}
