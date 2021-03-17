//
//  ViewController.swift
//  DatePicker
//
//  Created by SeoYeon Hong on 2021/03/13.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    var items = ["", "날짜", "", "위치", "메모"]
    var inputText = UITextField()
    var datePicker = UIDatePicker()
    let dateLabel = UILabel()
    let dateFormatter = DateFormatter()
    
    override func loadView() {
            super.loadView()
            let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemGray6
            self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addConstraints()
    }
    
    private func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        inputText.font = UIFont.systemFont(ofSize: 16)
        inputText.placeholder = "내용을 입력하세요."
        inputText.autocapitalizationType = .none
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.isHidden = true
        datePicker.date = Date()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 (eee)"
        dateLabel.text = "\(dateFormatter.string(from: datePicker.date))"
        
        view.addSubview(tableView)
        view.addSubview(inputText)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            inputText.topAnchor.constraint(equalTo: tableView.topAnchor),
            inputText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            inputText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            inputText.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        dateLabel.text = "\(dateFormatter.string(from: datePicker.date))"
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if indexPath.row == 1 {
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
            dateLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            cell.selectionStyle = UITableViewCell.SelectionStyle.default
        } else if indexPath.row == 2 {
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
            datePicker.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            datePicker.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let height:CGFloat = datePicker.isHidden ? 0.0 : 216.0
            return height
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dpIndexPath = NSIndexPath(row: 1, section: 0)
        if dpIndexPath as IndexPath == indexPath {
            datePicker.isHidden = !datePicker.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                    // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.dateChanged(sender: self.datePicker)
                self.tableView.endUpdates()
            })
        }
    }
}
