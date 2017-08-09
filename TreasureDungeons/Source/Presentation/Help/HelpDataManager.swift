//
//  HelpDataManager.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 09.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

typealias HelpCompletionBlock = (_ content: String?, _ error: Error?) -> Void

protocol HelpDataManagerOutput {
    func loadHelp(completionHandler: @escaping HelpCompletionBlock)
}

class HelpDataManager {
    
}

extension HelpDataManager: HelpDataManagerOutput {
    
    func loadHelp(completionHandler: @escaping HelpCompletionBlock) {
            completionHandler("<html><body><p>Hello!</p></body></html>", nil)
    }
}
