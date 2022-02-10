//
//  ViewController.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 15.01.2022.
//

import UIKit

final class ChatViewController: UIViewController {

    private let tableView = UITableView().prepareForAutoLayout()
    private let inputTextView = InputMessageView().prepareForAutoLayout()

    private var inputTextViewBottomConstraint: NSLayoutConstraint!
    private let tableAdapter: ChatTableViewAdapter

    private var messages: [MessageData] = []
    
    private var messagesLayout: MessageCellLayout = MessageCellLayout.default

    init(tableAdapter: ChatTableViewAdapter) {
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStub()
        
        prepareNavigationBar()
        prepareView()
        prepareObservers()
    }
    
    private func prepareNavigationBar() {
        title = "Bubbles"
        let rightButton = UIBarButtonItem(title: "Change Font",
                                          style: .plain,
                                          target: self,
                                          action: #selector(tappedChangeFontsButton))
        navigationItem.rightBarButtonItem = rightButton
    }

    private func prepareView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(inputTextView)

        tableView.pinEdgesToSuperviewEdges(excluding: .bottom)
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.className)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = tableAdapter
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(recognizer:)))
        tableView.addGestureRecognizer(tapGesture)

        view.addSubview(inputTextView)
        inputTextView.pinToSuperview([.left, .right])
        inputTextViewBottomConstraint = inputTextView.bottomAnchor ~= view.safeAreaLayoutGuide.bottomAnchor
        inputTextView.topAnchor ~= tableView.bottomAnchor
        inputTextView.delegate = self
    }

    private func prepareObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    func tableViewTapped(recognizer: UITapGestureRecognizer) {
        inputTextView.resignFirstResponder()
    }

    @objc
    func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              var keyboardFrame  = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        inputTextViewBottomConstraint.constant = -keyboardFrame.height + view.safeAreaInsets.bottom
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              var keyboardFrame  = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        inputTextViewBottomConstraint.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc
    private func tappedChangeFontsButton() {
        let messageFontSize = UInt.random(in: 10...25)
        let timeFontSize = UInt.random(in: 5...15)
        messagesLayout = .init(messageFont: UIFont.systemFont(ofSize: CGFloat(messageFontSize)),
                               timeFont: UIFont.systemFont(ofSize: CGFloat(timeFontSize)))
        reloadData()
    }

    private func initStub() {
        messages = [
            MessageData(text: "Ок", sendingTime: "09:10",
                        deliveryStatus: .delivered, direction: .outgoing),
            MessageData(text: "Среднее сообщение", sendingTime: "09:12",
                        deliveryStatus: .delivered, direction: .outgoing),
            MessageData(text: "Сообщение чуть длиннее среднего", sendingTime: "09:22",
                        deliveryStatus: .delivered, direction: .outgoing),
            MessageData(text: "Очень длинное многострочное сообщение, длиннеее всех предыдущих, сообщений, вместе взятых", sendingTime: "10:10",
                        deliveryStatus: .delivered, direction: .outgoing)
        ]
        tableAdapter.items = messages.map { MessageCellViewModel(model: $0, layout: messagesLayout) }
        reloadData()
    }

    private func reloadData() {
        tableAdapter.items = messages.map { MessageCellViewModel(model: $0, layout: messagesLayout) }
        tableView.reloadData()
    }
}

extension ChatViewController: InputMessageViewDelegate {
    func tappedSendMessageButton(_ text: String) {
        guard !text.isEmpty else { return }
        let rand = arc4random_uniform(100)
        var direction: MessageDirection
        var deliveryStatus: DeliveryStatus
        if rand % 2 == 0 {
            direction = .incoming
            deliveryStatus = .none
        } else {
            direction = .outgoing
            deliveryStatus = rand % 3 == 0 ? .inProgress : .sended
        }

        let sendingTime = DateHelper().string(fromDate: Date(), format: .hhmm_Colon)
        let message = MessageData(text: text,
                                  sendingTime: sendingTime,
                                  deliveryStatus: deliveryStatus,
                                  direction: direction)
        messages.append(message)
        tableAdapter.items.append(MessageCellViewModel(model: message, layout: messagesLayout))
        tableView.reloadData()

        inputTextView.text = nil
        inputTextView.resignFirstResponder()
    }
}
