//
//  GameProvider.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 12.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import JSONCodable

typealias GameCompletionBlock = (_ game: Game?, _ error: Error?) -> Void
typealias GamesCompletionBlock = (_ game: [GamePreview]?, _ error: Error?) -> Void

enum GameError: Error {
    case documentPathNotSet
    case cannotReadGame
}

class GameProvider {
    
    static let fileExtension = ".game"
    
    lazy var documentPath: String? = {
        return Bundle.main.resourcePath! + "/" // + "/Games"
    }()
    
    init() {
        
    }
    
    func loadGamePreviewList(completionHandler: @escaping GamesCompletionBlock) {
        
        DispatchQueue.global(qos: .background).async {
            
            var gamePreviews = [GamePreview]()
            if let path = self.documentPath {
                let fs: FileManager = FileManager.default
                do {
                    let contents: Array = try fs.contentsOfDirectory(atPath: path)
                    for fileName in contents {
                        if fileName.hasSuffix(GameProvider.fileExtension) {
                            do {
                                if let gamePreview = try self.loadGamePreview(from: fileName) {
                                    gamePreviews.append(gamePreview)
                                }
                            } catch let error as NSError {
                                NSLog("Error loading map file: \(fileName) => \(error)")
                            }
                        }
                    }
                    completionHandler(gamePreviews, nil)
                } catch let error as NSError {
                    
                    //TODO: This code needs to generate an error
                    NSLog("Error \(error)")
                    completionHandler(nil, error)
                }
            } else {
                let error = GameError.documentPathNotSet
                completionHandler(nil, error)
            }
        }
    }
    
    func loadGame(from fileName: String, completionHandler: @escaping GameCompletionBlock) {
        
        guard let documentPath = self.documentPath else {
            let error = GameError.documentPathNotSet
            completionHandler(nil, error)
            return
        }
        
        let filePath = documentPath + fileName
        
        do {
            let jsonData = try NSData(contentsOf: NSURL(fileURLWithPath: filePath) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
            
            if let dictionary = object as? JSONObject {
                do {
                    let game = try Game(object: dictionary)
                    completionHandler(game, nil)
                } catch let error as NSError {
                    completionHandler(nil, error)
                    print("error during parsing game: \(error)")
                }
            }
        } catch let error as NSError {
            completionHandler(nil, error)
            print("error during read game from disc: \(error)")
        }
        
        return
    }
    
    func loadGamePreview(from fileName: String) throws -> GamePreview? {
        
        guard let documentPath = self.documentPath else {
            print("documentPath not set")
            return nil
        }
        
        let filePath = documentPath + fileName
        
        do {
            let jsonData = try NSData(contentsOf: NSURL(fileURLWithPath: filePath) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
            
            if let dictionary = object as? JSONObject {
                do {
                    let gamePreview = try GamePreview(object: dictionary)
                    return gamePreview
                } catch let error as NSError {
                    print("error during parsing game preview: \(error)")
                    return nil
                }
            }
        } catch let error as NSError {
            print("error during read game preview from disc: \(error)")
            return nil
        }
        
        return nil
    }
}
