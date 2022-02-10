//
//  Preparable.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 08.02.2022.
//

import UIKit

protocol Preparable {
    func prepare(withViewModel viewModel: PreparableViewModel?)
}

protocol PreparableViewModel {
    var cellId: String { get }
}

class PreparableTableCell: UITableViewCell, Preparable {
    func prepare(withViewModel viewModel: PreparableViewModel?) {}
}
