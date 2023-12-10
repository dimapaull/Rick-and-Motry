//
//  NetworkManager.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import Foundation
import UIKit

class NetworkManager {
    private let urlString = "https://rickandmortyapi.com/api/episode"
    var imageCache = NSCache<NSString, UIImage>()
    
    func loadEpisode(id: Int, complition: @escaping((episode: Result, character: CharacterInfo, image: UIImage)?) -> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if  let data,
                let infoEpisode = try? JSONDecoder().decode(EpisodeInfo.self, from: data),
                let episode = infoEpisode.results?[id],
                let character = infoEpisode.results?[id].characters?.randomElement() {
                
                
                self.loadCharacter(episode: episode, characterURL: character, complition: complition)
            }
        }
        task.resume()
    }
    
    func loadCharacter(episode: Result, characterURL: String, complition: @escaping((Result, CharacterInfo, UIImage)?) -> ()) {
        let characterUrlString = URL(string: characterURL)
        let request = URLRequest(url: characterUrlString!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if  let data,
                let character = try? JSONDecoder().decode(CharacterInfo.self, from: data),
                let urlImage = character.image {
                self.loadCharacterImage(episode: episode, url: String(urlImage), character: character, complition: complition)
            }
        }
        task.resume()
    }
    
    private func loadCharacterImage(episode: Result, url: String, character: CharacterInfo, complition: @escaping((Result, CharacterInfo, UIImage)?) -> ()) {
        let imageUrlString = URL(string: url)!
        
        if let chacheImage = imageCache.object(forKey: imageUrlString.absoluteString as NSString) {
            complition((episode: episode, character: character, image: chacheImage))
        } else {
            let request = URLRequest(url: imageUrlString)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data,
                   let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: imageUrlString.absoluteString as NSString)
                    complition((episode: episode, character: character, image: image))
                } else {
                    complition(nil)
                }
            }
            task.resume()
        }
    }
}
