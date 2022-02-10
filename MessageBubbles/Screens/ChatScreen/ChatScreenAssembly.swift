//
//  ChatScreenAssembly.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 09.02.2022.
//

import UIKit

final class ChatScreenAssembly {

    static func assemble() -> UIViewController {
        let tableAdapter = ChatTableViewAdapter()
        let viewController = ChatViewController(tableAdapter: tableAdapter)

        return viewController
    }
}
