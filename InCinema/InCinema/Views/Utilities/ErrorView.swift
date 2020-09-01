//
//  ErrorView.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 01/09/2020.
//  Copyright © 2020 Vladimir Abramichev. All rights reserved.
//

import UIKit

final class ErrorView: UIViewController {

    private let error: Error

    internal init(error: Error) {
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.addSubview(errorBox)
        errorBox.center(of: view)
    }

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.text = "Ups!"
        title.textAlignment = .center
        return title
    }()

    private lazy var discriptionLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .caption1)
        title.text = error.localizedDescription
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()

    private lazy var errorBox: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 10

        let stack = UIStackView(arrangedSubviews: [titleLabel, discriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.insertSubview(background, at: 0)
        stack.spacing = 8
        stack.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true

        background.fill(container: stack)

        return stack
    }()
}
