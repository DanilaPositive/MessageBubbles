//
//  NSObject+ClassName.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 08.02.2022.
//

import Foundation

extension NSObject {
    @objc
    var className: String {
        return String(describing: type(of: self))
    }

    @objc
    class var className: String {
        return String(describing: self)
    }
}
