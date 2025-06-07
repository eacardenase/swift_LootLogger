//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/31/25.
//

import UIKit

class DetailViewController: UIViewController {

    var item: Item

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return formatter
    }()

    let nameLabel: UILabel = {
        let label = UILabel()

        label.text = "Name"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()
    lazy var nameField: UITextField = {
        let textField = UITextField()

        textField.text = item.name
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.setContentCompressionResistancePriority(
            UILayoutPriority(749),
            for: .horizontal
        )

        return textField
    }()

    let serialLabel: UILabel = {
        let label = UILabel()

        label.text = "Serial"

        return label
    }()
    lazy var serialNumberField: UITextField = {
        let textField = UITextField()

        textField.text = item.serialNumber
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.setContentCompressionResistancePriority(
            UILayoutPriority(749),
            for: .horizontal
        )

        return textField
    }()

    let valueLabel: UILabel = {
        let label = UILabel()

        label.text = "Value"

        return label
    }()
    lazy var valueField: UITextField = {
        let textField = UITextField()

        textField.text = numberFormatter.string(
            from: NSNumber(value: item.valueInDollars)
        )
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.setContentCompressionResistancePriority(
            UILayoutPriority(749),
            for: .horizontal
        )

        return textField
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()

        label.text = dateFormatter.string(from: item.dateCreated)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)

        return label
    }()

    init(for item: Item) {
        self.item = item

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()

        view.backgroundColor = .systemBackground

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isToolbarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = item.name

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )

        view.addGestureRecognizer(tapGestureRecognizer)

        toolbarItems = [
            UIBarButtonItem(
                barButtonSystemItem: .camera,
                target: self,
                action: #selector(choosePhotoSource)
            )
        ]
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
        navigationController?.isToolbarHidden = true

        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text ?? ""

        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText)
        {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
}

extension DetailViewController {
    private func setupViews() {
        let nameStackView = UIStackView(arrangedSubviews: [
            nameLabel, nameField,
        ])
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8

        let serialStackView = UIStackView(arrangedSubviews: [
            serialLabel, serialNumberField,
        ])
        serialStackView.translatesAutoresizingMaskIntoConstraints = false
        serialStackView.axis = .horizontal
        serialStackView.spacing = 8

        let valueStackView = UIStackView(arrangedSubviews: [
            valueLabel, valueField,
        ])
        valueStackView.translatesAutoresizingMaskIntoConstraints = false
        valueStackView.axis = .horizontal
        valueStackView.spacing = 8

        let verticalStackView = UIStackView(arrangedSubviews: [
            nameStackView,
            serialStackView,
            valueStackView,
            dateLabel,
        ])

        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(verticalStackView)

        // verticalStackView
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            verticalStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            verticalStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
        ])

        // nameField
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(
                equalTo: serialNumberField.leadingAnchor
            ),
            serialNumberField.leadingAnchor.constraint(
                equalTo: valueField.leadingAnchor
            ),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."

        let existingTextHasDecimalSeparator = textField.text?.range(
            of: decimalSeparator
        )
        let replacementTextHasDecimalSeparator = string.range(
            of: decimalSeparator
        )
        let replacingTextHasAlphabeticalCharacters = string.rangeOfCharacter(
            from: CharacterSet.letters
        )

        if replacingTextHasAlphabeticalCharacters != nil
            || existingTextHasDecimalSeparator != nil
                && replacementTextHasDecimalSeparator != nil
        {
            return false
        }

        return true

    }
}

// MARK: - Actions

extension DetailViewController {
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func choosePhotoSource(_ sender: UIBarButtonItem) {
        print(#function)
    }
}
