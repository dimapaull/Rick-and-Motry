//
//  CharacterCard.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 10.12.23.
//

import Foundation
import UIKit

public struct CharacterCard: Equatable, Hashable {
    let characterName: String?
    let image: UIImage?
    let episodeName: String?
    let episodeNumber: String?
    let status, species, type: String?
    let gender: String?
    let origin: String?
    let location: String?
    var isFavorite = false
}
