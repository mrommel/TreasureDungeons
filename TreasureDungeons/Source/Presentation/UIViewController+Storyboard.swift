//
//  UIViewController+Storyboard.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 03.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard (_ name: String) -> Self? {
        return instantiateFromStoryboard(name, type: self)
    }
    
    fileprivate class func instantiateFromStoryboard<T> (_ name: String, type: T.Type) -> T? {
        guard let viewController = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: self.className()) as? T else {
            return nil
        }
        
        return viewController
    }
}

extension UIViewController {
    
    @discardableResult
    func goBack(animated: Bool) -> UIViewController? {
        return self.navigationController?.popViewController(animated: animated)
    }
    
}

extension NSObject {
    
    class func className() -> String {
        return String(describing: self.self).components(separatedBy: ".").last!
    }
    
}
