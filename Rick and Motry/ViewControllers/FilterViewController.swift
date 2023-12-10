//
//  FilterViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 14.12.23.
//

import UIKit
// protocol for filter
protocol SearchFilterDelegate {
    func didFilterTapped(selectedFilter: FilterSettings)
}

final class FilterViewController: UIViewController {
    
    //MARK: - Public variables
    //filter delegate for data transfer by tap filter button
    public var filterDelegate: SearchFilterDelegate!
    public var selectedFilter = FilterSettings.nameOfEpisode
    
    //MARK: - Private variables
    private let filterArray = [FilterSettings.nameOfEpisode, FilterSettings.numberOfEpisode, FilterSettings.nameOfLoaction, FilterSettings.nameOfCharacter]
    
    private let searchFilterPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.layer.cornerRadius = 10
        pickerView.layer.borderColor = ButtonAppearance.filterButtonTextColor.cgColor
        pickerView.layer.borderWidth = 2
        return pickerView
    } ()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ButtonAppearance.filterButtonTextColor
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        return button
    } ()
    
    //MARK: - Lifecicles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
}

// MARK: - Private methods
private extension FilterViewController {
    
    func setupVC() {
        view.backgroundColor = .white
        searchFilterPickerView.delegate = self
        searchFilterPickerView.dataSource = self
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        layout()
    }
    
    @objc func filterPressed() {
        //Data transfer by tap filter button
        filterDelegate.didFilterTapped(selectedFilter: selectedFilter)
        dismiss(animated: true)
    }
    
    // MARK: - Constants
    enum UIConstants {
        static let searchFilterPickerViewTopConstraint: CGFloat = 150
        static let searchFilterPickerViewHeight: CGFloat = 200
        static let filterButtonTopConstraint: CGFloat = 100
        static let filterButtonHeight: CGFloat = 40
        static let widthEdgets: CGFloat = -100
    }
    
    // MARK: - Constraints
    func layout() {
        view.addSubview(searchFilterPickerView)
        view.addSubview(filterButton)
        
        // MARK: Logo constraints
        NSLayoutConstraint.activate([
            searchFilterPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.searchFilterPickerViewTopConstraint),
            searchFilterPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchFilterPickerView.heightAnchor.constraint(equalToConstant: UIConstants.searchFilterPickerViewHeight),
            searchFilterPickerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: UIConstants.widthEdgets),
        ])
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: searchFilterPickerView.bottomAnchor, constant: UIConstants.filterButtonTopConstraint),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: UIConstants.filterButtonHeight),
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: UIConstants.widthEdgets),
        ])
    }
}

//MARK: - Extension UIPickerViewDelegate, UIPickerViewDataSource
extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // select filter setting
        selectedFilter = filterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //Set black color for text if picker
        return NSAttributedString(string: filterArray[row].rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}
