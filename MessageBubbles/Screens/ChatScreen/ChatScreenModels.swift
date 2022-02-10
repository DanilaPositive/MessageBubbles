//
//  ChatScreenModels.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 09.02.2022.
//

import UIKit

enum MessageDirection {
    case incoming
    case outgoing
}

enum DeliveryStatus {
    case sended
    case delivered
    case inProgress
    case none

    var icon: UIImage? {
        switch self {
        case .sended:
            return #imageLiteral(resourceName: "icon_msg_sended")
        case .delivered:
            return #imageLiteral(resourceName: "icon_msg_delivered")
        case .inProgress:
            return #imageLiteral(resourceName: "icon_msg_sending")
        case .none:
            return nil
        }
    }
}

struct MessageData {
    let text: String
    let sendingTime: String
    let deliveryStatus: DeliveryStatus
    let direction: MessageDirection
}
