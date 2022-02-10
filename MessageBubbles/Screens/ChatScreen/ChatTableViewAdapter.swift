//
//  ChatTableViewAdapter.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 08.02.2022.
//

import Foundation
import UIKit

final class ChatTableViewAdapter: NSObject {

    // MARK: - Properties
    var items: [PreparableViewModel] = []
}

// MARK: - UITableViewDataSource

extension ChatTableViewAdapter: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = items[indexPath.row]
        let cell = MessageCell(style: .default, reuseIdentifier: viewModel.cellId)
        cell.prepare(withViewModel: viewModel)
        return cell
    }
}
