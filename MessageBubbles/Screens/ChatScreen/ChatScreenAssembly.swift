//
//  ChatScreenAssembly.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 09.02.2022.
//

import UIKit

class ChatScreenAssembly {

    static func assemble() -> UIViewController {
        let tableAdapter = ChatTableViewAdapter()
        let view = ChatViewController(tableAdapter: tableAdapter)
        
        return view
    }
}
