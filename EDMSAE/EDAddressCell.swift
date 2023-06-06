//
//  EDAddressCell.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/7.
//

import Foundation
import UIKit
import TMComponent
import Alamofire
import SwiftyJSON

class EDAddressCell: UITableViewCell {
    var address = Address()
    lazy var nameAmdSexLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var provinceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var cityLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var areaLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var detailedAddressLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var addressEdittingNavigationBar: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var iconView: UIImageView = {
        let btn = UIImageView()
        return btn
    }()
    
    lazy var editView: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackgroundGray")
        contentView.addSubview(nameAmdSexLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(provinceLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(areaLabel)
        contentView.addSubview(detailedAddressLabel)
        contentView.addSubview(addressEdittingNavigationBar)
        contentView.addSubview(iconView)
        contentView.addSubview(editView)

        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameAmdSexLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(24)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(38)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAmdSexLabel.snp.top)
            make.height.equalTo(38)
            make.left.equalTo(nameAmdSexLabel.snp.right).offset(6)
        }

        provinceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAmdSexLabel.snp.bottom).offset(6)
            make.left.equalTo(nameAmdSexLabel.snp.left)
            make.height.equalTo(38)
        }
        cityLabel.snp.makeConstraints { make in
            make.left.equalTo(provinceLabel.snp.right).offset(6)
            make.top.equalTo(provinceLabel.snp.top)
            make.height.equalTo(38)
        }
        areaLabel.snp.makeConstraints { make in
            make.left.equalTo(cityLabel.snp.right).offset(6)
            make.top.equalTo(provinceLabel.snp.top)
            make.height.equalTo(38)
        }
        detailedAddressLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(24)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(provinceLabel.snp.bottom).offset(6)
            make.height.equalTo(38)
        }
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        editView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        iconView.image = UIImage(systemName: "location.circle")
        iconView.tintColor = UIColor(named: "ContentBackground")
        
        editView.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editView.tintColor = UIColor(named: "ContentBackground")
        editView.setTitle("编辑", for: .normal)
        editView.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        editView.addTarget(self, action: #selector(enterEditingView), for: .touchDown)
    }

    func setupEvent(address: Address, canEdit: Bool = false) {
        self.address = address
        if canEdit {
            editView.isHidden = false
        }else {
            editView.isHidden = true
        }
        nameAmdSexLabel.text = "\(address.name) \(address.sex == .Man ? "先生" : "女士")"
        phoneNumberLabel.text = "\(address.phoneNumber)"
        provinceLabel.text = "\(address.province)"
        cityLabel.text = "\(address.city)"
        areaLabel.text = "\(address.area)"
        detailedAddressLabel.text = "\(address.detailedAddress)"
    }
    
    @objc func enterEditingView() {
        if let parentVC = getParentViewController() {
            let vc = EDAddressEditingViewController()
            vc.setupEvent(address: address)
            vc.saveCompletionHandler = { address in
                self.setupEvent(address: address)
            }
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class EDAddressEditingViewController: UIViewController {
    var address = Address()
    let provinceDs = provinceDataSource()
    let cityDs = cityDataSource()
    let districtDs = districtDataSource()
    let sexDs = sexDataSource()
    var saveCompletionHandler: ((Address) -> Void)?

    lazy var sexSelectedView: TMPopUpView = {
        let view = TMPopUpView()
        return view
    }()

    lazy var provinceSelectionView: TMPopUpView = {
        let view = TMPopUpView()
        return view
    }()

    lazy var citySelectionView: TMPopUpView = {
        let view = TMPopUpView()
        return view
    }()

    lazy var districtSelectionView: TMPopUpView = {
        let view = TMPopUpView()
        return view
    }()

    lazy var nameTextField: EDTextField = {
        let TextField = EDTextField()
        return TextField
    }()

    lazy var phoneNumberTextField: EDTextField = {
        let TextField = EDTextField()
        return TextField
    }()

    lazy var detailedAddressTextField: EDTextField = {
        let TextField = EDTextField()
        return TextField
    }()

    lazy var doneBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(nameTextField)
        view.addSubview(sexSelectedView)
        view.addSubview(phoneNumberTextField)
        view.addSubview(provinceSelectionView)
        view.addSubview(citySelectionView)
        view.addSubview(districtSelectionView)
        view.addSubview(detailedAddressTextField)
        view.addSubview(doneBtn)

        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(188)
            make.height.equalTo(44)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }

        sexSelectedView.frame = CGRect(x: 48 + UIScreen.main.bounds.width * 0.6, y: 188, width: 88, height: 44)
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(24)
        }

        provinceSelectionView.frame = CGRect(x: 24, y: 300, width: 102, height: 44)
        citySelectionView.frame = CGRect(x: 150, y: 300, width: 102, height: 44)
        districtSelectionView.frame = CGRect(x: 276, y: 300, width: 102, height: 44)

        detailedAddressTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(68)
            make.height.equalTo(44)
        }

        doneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailedAddressTextField.snp.bottom).offset(68)
            make.width.equalTo(88)
            make.height.equalTo(44)
        }
        doneBtn.setTitle("保存", for: .normal)
        doneBtn.addTarget(self, action: #selector(saveAddress), for: .touchDown)
        doneBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        doneBtn.setCorner(radii: 10)
        doneBtn.backgroundColor = UIColor(named: "TennisBlur")
        nameTextField.textField.textAlignment = .center
        phoneNumberTextField.textField.textAlignment = .center
    }

    func setupEvent(address: Address) {
        self.address = address
        EDAddressRequest.requestGDAddress { res in
            guard let res = res else {
                return
            }
            self.provinceDs.provinces = res
            if let province = self.provinceDs.provinces.first(where: { $0.name == address.province }) {
                self.provinceDs.provinces.removeAll(where: { $0.name == address.province })
                self.provinceDs.provinces.insert(province, at: 0)
            }
            self.provinceSelectionView.dataSource = self.provinceDs
            self.view.bringSubviewToFront(self.provinceSelectionView)
            self.provinceSelectionView.delegate = self.provinceSelectionView
            self.provinceSelectionView.reloadData()
            self.provinceSelectionView.setupUI()

            self.cityDs.cities = self.provinceDs.provinces[0].districts ?? []
            if let city = self.cityDs.cities.first(where: { $0.name == address.city }) {
                self.cityDs.cities.removeAll(where: { $0.name == address.city })
                self.cityDs.cities.insert(city, at: 0)
            }
            self.citySelectionView.dataSource = self.cityDs
            self.view.bringSubviewToFront(self.citySelectionView)
            self.citySelectionView.delegate = self.citySelectionView
            self.citySelectionView.reloadData()
            self.citySelectionView.setupUI()

            self.districtDs.districts = self.cityDs.cities[0].districts ?? []
            if let area = self.districtDs.districts.first(where: { $0.name == address.area }) {
                self.districtDs.districts.removeAll { $0.name == address.area }
                self.districtDs.districts.insert(area, at: 0)
            }
            self.districtSelectionView.dataSource = self.districtDs
            self.view.bringSubviewToFront(self.districtSelectionView)
            self.districtSelectionView.delegate = self.districtSelectionView
            self.districtSelectionView.reloadData()
            self.districtSelectionView.setupUI()

            self.provinceSelectionView.selectedCompletionHandler = { index in
                let selectedProvince = self.provinceDs.provinces.remove(at: index)
                self.provinceDs.provinces.insert(selectedProvince, at: 0)
                self.provinceSelectionView.reloadData()

                self.cityDs.cities = selectedProvince.districts ?? []
                self.districtDs.districts = selectedProvince.districts?[0].districts ?? []
                self.citySelectionView.reloadData()
                self.districtSelectionView.reloadData()
            }

            self.citySelectionView.selectedCompletionHandler = { index in
                let selectedCity = self.cityDs.cities.remove(at: index)
                self.cityDs.cities.insert(selectedCity, at: 0)
                self.citySelectionView.reloadData()

                self.districtDs.districts = selectedCity.districts ?? []
                self.districtSelectionView.reloadData()
            }

            self.districtSelectionView.selectedCompletionHandler = { index in
                let selecteddistrict = self.districtDs.districts.remove(at: index)
                self.districtDs.districts.insert(selecteddistrict, at: 0)
                self.districtSelectionView.reloadData()
            }
        }

        if let sex = self.sexDs.sexConfig.first(where: { $0.rawValue == address.sex.rawValue }) {
            sexDs.sexConfig.removeAll { $0.rawValue == address.sex.rawValue }
            sexDs.sexConfig.insert(sex, at: 0)
        }
        sexSelectedView.dataSource = sexDs
        view.bringSubviewToFront(sexSelectedView)
        sexSelectedView.delegate = sexSelectedView
        sexSelectedView.setupUI()
        sexSelectedView.selectedCompletionHandler = { index in
            let selectedSex = self.sexDs.sexConfig.remove(at: index)
            self.sexDs.sexConfig.insert(selectedSex, at: 0)
            self.sexSelectedView.reloadData()
        }

        let nameConfig = EDTextFieldConfig(placeholderText: "Enter your name", text: "\(address.name)")
        nameTextField.setup(with: nameConfig)
        let phoneNumberConfig = EDTextFieldConfig(placeholderText: "enter your phone number", text: "\(address.phoneNumber)")
        phoneNumberTextField.setup(with: phoneNumberConfig)
        let detailAddressConfig = EDTextFieldConfig(placeholderText: "detail address", text: "\(address.detailedAddress)")
        detailedAddressTextField.setup(with: detailAddressConfig)
    }

    func getAddressInfo() -> Address {
        return Address(id: address.id, name: nameTextField.textField.text ?? "", sex: sexDs.sexConfig[0], phoneNumber: phoneNumberTextField.textField.text ?? "", province: provinceDs.provinces[0].name, city: cityDs.cities[0].name, area: districtDs.districts[0].name, detailedAddress: detailedAddressTextField.textField.text ?? "", isDefault: false)
    }

    @objc func saveAddress() {
        (saveCompletionHandler ?? { _ in })(getAddressInfo())
        navigationController?.popViewController(animated: true)
    }
}

class sexDataSource: NSObject, UITableViewDataSource {
    var sexConfig = Sex.allCases
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        sexConfig.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupUI()
        cell.setupEvent(title: sexConfig[indexPath.row] == .Man ? "先生" : "女士")
        return cell
    }
}

class provinceDataSource: NSObject, UITableViewDataSource {
    var provinces: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        provinces.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupUI()
        cell.setupEvent(title: provinces[indexPath.row].name)
        return cell
    }
}

class cityDataSource: NSObject, UITableViewDataSource {
    var cities: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        cities.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupUI()
        cell.setupEvent(title: cities[indexPath.row].name)
        return cell
    }
}

class districtDataSource: NSObject, UITableViewDataSource {
    var districts: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        districts.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupUI()
        cell.setupEvent(title: districts[indexPath.row].name)
        return cell
    }
}


open class EDTextField: UIView {
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 22)
        return textField
    }()

    public func setup(with config: EDTextFieldConfig) {
        setupUI()
        setupEvent(config: config)
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "TennisBlurTextField")
        setCorner(radii: 15)

        addSubview(textField)

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
    }

    private func setupEvent(config: EDTextFieldConfig) {
        textField.placeholder = config.placeholderText
        textField.text = config.text
    }
}

open class EDTextFieldConfig {
    public var placeholderText: String
    public var text: String?
    init(placeholderText: String, text: String? = nil) {
        self.placeholderText = placeholderText
        self.text = text
    }
}


class EDAddressRequest {
    static func requestGDAddress(completionHandler: @escaping ([District]?) -> Void) {
        let para = ["keywords": "中国", "subdistrict": "3", "key": "114a6d4a6b7f393fb5faf5d5021d9264"] as [String: Any]
        AF.request("https://restapi.amap.com/v3/config/district", parameters: para).response { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            guard let json = try? JSON(data: jsonData) else {
                completionHandler(nil)
                return
            }
            let country = District(json: json["districts"].arrayValue[0])
            completionHandler(country.districts)
        }
    }
}
