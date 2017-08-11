//
//  HelpDataManager.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 09.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

typealias HelpCompletionBlock = (_ content: String?, _ error: Error?) -> Void

enum HelpError: Error {
    case cannotReadHelp
    case cannotFindHelpFile
}

protocol HelpDataManagerOutput {
    func loadHelp(completionHandler: @escaping HelpCompletionBlock)
}

class HelpDataManager {
    
}

extension HelpDataManager: HelpDataManagerOutput {

    func loadHelp(completionHandler: @escaping HelpCompletionBlock) {
        
        if let helpPath = Bundle.main.path(forResource: "Help", ofType: "html") {
            do {
                let helpContent = try String(contentsOfFile: helpPath)
        
                completionHandler(helpContent, nil)
            } catch {
                completionHandler(nil, HelpError.cannotReadHelp)
            }
        } else {
            completionHandler(nil, HelpError.cannotFindHelpFile)
        }
    }
}
