//
//  Factory.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit

extension UIViewController {
    
    func createSpacer(height: CGFloat? = nil, width: CGFloat? = nil, customize: ((UIView) -> Void)? = nil) -> UIView {
        let spacer = UIView()
        if let height = height {
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        customize?(spacer)
        return withAutoLayout(spacer)
    }
    
    func createVerticalStack(for subviews: [UIView] = [], spacing: CGFloat = 20, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, customize: ((UIStackView) -> Void)? = nil) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        customize?(stack)
        return withAutoLayout(stack)
    }
    
    func createHorizontalStack(for subviews: [UIView], spacing: CGFloat = 0, distribution: UIStackView.Distribution = .equalSpacing, alignment: UIStackView.Alignment = .fill, customize: ((UIStackView) -> Void)? = nil) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .horizontal
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        customize?(stack)
        return withAutoLayout(stack)
    }
    
    func createLabel(text: String? = nil, customize: ((UILabel) -> Void)? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        customize?(label)
        return withAutoLayout(label)
    }
    
    func createTextField(placeholder: String? = nil, text: String? = nil, height: CGFloat = 50, customize: ((UITextField) -> Void)? = nil) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.text = text
        field.tintColor = .appAccent
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.delegate = self
        customize?(field)
        return withAutoLayout(field)
    }
    
    func createButton(title: String, action: Selector, customize: ((UIButton) -> Void)? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = .white
        button.setBackgroundColor(.appAccent, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        customize?(button)
        return withAutoLayout(button)
    }
    
    func createImageButton(action: Selector, height: CGFloat, width: CGFloat) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        return withAutoLayout(button)
    }
    
    func createTable(for vc: UITableViewDelegate & UITableViewDataSource, allowsSelection: Bool = false, customize: ((UITableView) -> Void)? = nil) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .appBackground
        tableView.delegate = vc
        tableView.dataSource = vc
        tableView.allowsSelection = allowsSelection
        customize?(tableView)
        return withAutoLayout(tableView)
    }
    
    func createSwitch(action: Selector? = nil, customize: ((UISwitch) -> Void)? = nil) -> UISwitch {
        let swtch = UISwitch()
        if let action = action {
            swtch.addTarget(self, action: action, for: .valueChanged)
        }
        customize?(swtch)
        return withAutoLayout(swtch)
    }
    
    func createSegmentedControl(items: [String], selected: Int = 0, customize: ((UISegmentedControl) -> Void)? = nil) -> UISegmentedControl {
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = selected
        customize?(control)
        return withAutoLayout(control)
    }
    
    func createImageView(name: String? = nil, customize: ((UIImageView) -> Void)? = nil) -> UIImageView {
        var image: UIImageView
        if let name = name {
            image = UIImageView(image: UIImage(named: name))
        } else {
            image = UIImageView()
        }
        customize?(image)
        return withAutoLayout(image)
    }
    
    func createCollection(for vc: UICollectionViewDelegate & UICollectionViewDataSource, reuseIdentifier: String, cellType: AnyClass = UICollectionViewCell.self, layout: UICollectionViewLayout = UICollectionViewFlowLayout(), customize: ((UICollectionView) -> Void)? = nil) -> UICollectionView {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = vc
        collection.dataSource = vc
        collection.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        customize?(collection)
        return withAutoLayout(collection)
    }
    
    func createPicker(for vc: UIPickerViewDelegate & UIPickerViewDataSource, selectedRow: Int? = nil, customize: ((UIPickerView) -> Void)? = nil) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = vc
        picker.dataSource = vc
        picker.heightAnchor.constraint(equalToConstant: 125).isActive = true
        if let selectedRow = selectedRow {
            picker.selectRow(selectedRow, inComponent: 0, animated: false)
        }
        customize?(picker)
        return withAutoLayout(picker)
    }
    
    func createBarButton(item: UIBarButtonItem.SystemItem, action: Selector, customize: ((UIBarButtonItem) -> Void)? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: item, target: self, action: action)
        customize?(button)
        return button
    }
    
    func createCustomBarButton(title: String, style: UIBarButtonItem.Style = .done, action: Selector, customize: ((UIBarButtonItem) -> Void)? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: style, target: self, action: action)
        customize?(button)
        return button
    }
    
}
