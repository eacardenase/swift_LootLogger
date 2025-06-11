//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/31/25.
//

import UIKit

class DetailViewController: UIViewController {

    var item: Item
    var imageStore: ImageStore

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
        textField.backgroundColor = UIColor.tertiarySystemFill

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
        textField.backgroundColor = UIColor.tertiarySystemFill

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
        textField.backgroundColor = UIColor.tertiarySystemFill

        return textField
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()

        label.text = dateFormatter.string(from: item.dateCreated)
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)

        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.setContentHuggingPriority(
            UILayoutPriority(248),
            for: .vertical
        )
        imageView.setContentCompressionResistancePriority(
            UILayoutPriority(749),
            for: .vertical
        )
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let adaptiveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8

        if UITraitCollection.current.verticalSizeClass == .compact {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
        } else {
            stackView.axis = .vertical
            stackView.distribution = .fill
        }

        return stackView
    }()

    // MARK: - Initializers

    init(for item: Item, with imageStore: ImageStore) {
        self.item = item
        self.imageStore = imageStore

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = UIColor(named: "Primary Brand Fill Color")

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isToolbarHidden = false

        if let itemImage = imageStore.image(forKey: item.itemKey) {
            imageView.image = itemImage
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
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

        let toolbar = navigationController?.toolbar
        toolbar?.standardAppearance.backgroundColor = UIColor(
            named: "Secondary Brand Fill Color"
        )
        toolbar?.scrollEdgeAppearance = toolbar?.standardAppearance

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
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

        let formStackView = UIStackView(arrangedSubviews: [
            nameStackView,
            serialStackView,
            valueStackView,
            dateLabel,
        ])

        formStackView.axis = .vertical
        formStackView.spacing = 8

        adaptiveStackView.addArrangedSubview(formStackView)
        adaptiveStackView.addArrangedSubview(imageView)

        view.addSubview(adaptiveStackView)

        // adaptiveStackView
        NSLayoutConstraint.activate([
            adaptiveStackView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor,
                constant: 8
            ),
            adaptiveStackView.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor,
                constant: 0
            ),
            adaptiveStackView.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor,
                constant: 0
            ),
            adaptiveStackView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor,
                constant: -8
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

    private func imagePicker(for sourceType: UIImagePickerController.SourceType)
        -> UIImagePickerController
    {
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        return imagePicker
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

        if existingTextHasDecimalSeparator != nil
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
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceItem = sender

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) {
                _ in

                let imagePickerController = self.imagePicker(
                    for: .camera
                )

                self.present(imagePickerController, animated: true)
            }

            alertController.addAction(cameraAction)
        }

        let photoLibraryAction = UIAlertAction(
            title: "Photo Library",
            style: .default
        ) { _ in

            let imagePickerController = self.imagePicker(
                for: .photoLibrary
            )

            imagePickerController.modalPresentationStyle = .popover
            imagePickerController.popoverPresentationController?.sourceItem =
                sender

            self.present(imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )

        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            adaptiveStackView.axis = .horizontal
            adaptiveStackView.distribution = .fillEqually
        } else {
            adaptiveStackView.axis = .vertical
            adaptiveStackView.distribution = .fill
        }
    }
}

extension DetailViewController: UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        let image = info[.originalImage] as! UIImage

        imageStore.setImage(image, forKey: item.itemKey)

        imageView.image = image

        dismiss(animated: true)
    }
}
