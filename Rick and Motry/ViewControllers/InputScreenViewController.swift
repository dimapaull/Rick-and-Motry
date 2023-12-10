//
//  InputScreenViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import UIKit

class InputScreenViewController: UIViewController {
    
    // MARK: - Privavte variables
    private var counterForTimer = 0
    private var timer = Timer()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let portalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "LoadingPortal")
        return imageView
    }()
    
    // MARK: - Lifecicles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
}

// MARK: - Private methods
private extension InputScreenViewController {
    
    func setupScreen() {
        view.backgroundColor = .white
        layout()
        startPortalAnimate()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerValue() {
        counterForTimer += 1
        
        if counterForTimer == 3 {
            let tabBarVC = TabBarViewController()
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
            timer.invalidate()
        }
    }
    
    func startPortalAnimate() {
        var transform = CATransform3DIdentity
        transform.m34 = -0.003
        //Animate rotate portal
        UIView.animate(withDuration: 3) {
            self.portalImageView.layer.transform = CATransform3DRotate(transform, .pi, 0, 0, 1)
        }
    }
    
    // MARK: - Constants
    enum UIConstants {
        static let logoTopConstraint: CGFloat = 97
        static let logoWidthConstraint: CGFloat = 312
        static let logoHeightConstraint: CGFloat = 104
        static let portalSizeConstraint: CGFloat = 200
    }
    
    // MARK: - Constraints
    func layout() {
        view.addSubview(logoImageView)
        view.addSubview(portalImageView)
        
        // MARK: Logo constraints
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.logoTopConstraint),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: UIConstants.logoHeightConstraint),
            logoImageView.widthAnchor.constraint(equalToConstant: UIConstants.logoWidthConstraint),
        ])
        
        // MARK: Portal constraints
        NSLayoutConstraint.activate([
            portalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            portalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portalImageView.heightAnchor.constraint(equalToConstant: UIConstants.portalSizeConstraint),
            portalImageView.widthAnchor.constraint(equalToConstant: UIConstants.portalSizeConstraint),
        ])
    }
}
