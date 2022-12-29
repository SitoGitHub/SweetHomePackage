//
//  RegistrationViewController.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import UIKit
import SnapKit
import MapKit

protocol RegistrationViewInputProtocol: AnyObject {
    func hideKeyBoard()
    func setNextTextField(textField: UITextField)
    func alertWithTitle(title: String, message: String, toFocus:UITextField)
    func updateMenuTableView(newMakerIsSaved: Bool?, categoriesIsSaved: Bool?)
    func presentEditMessage(title: String?,
                            descriptionText: String?)
    func changetitleButton()
    func updateMakerData(makerAnotation: MakerAnotation)
    func setMakerImageView(imageMAker: UIImage)
    
    var nameTextField: UITextField { get }
    var surnameTextField: UITextField { get }
    var phoneTextField: UITextField { get }
    var emailTextField: UITextField { get }
    var passwordTextField: ShowHideTextField { get }
    var confirmPasswordTextField: ShowHideTextField { get }
    var makerImageView: UIImageView { get }
    var newMakerIsSaved: Bool { get set }
    var categoriesIsSaved: Bool { get set }
    var navController: UINavigationController? { get }
}

final class RegistrationViewController: UIViewController {
    
    let makerAnotation: MakerAnotation? = nil
    
    let registrationView = UIView()
    
    let menuTableView = UITableView()
    let identifier = "MyCell"
    let listMenu = ListMenuRegistration()
    
    let topHeaderLabel = UILabel()
    let plusLabel = UILabel()
    
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let phoneTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = ShowHideTextField()
    let confirmPasswordTextField = ShowHideTextField()
    
    let topStack = UIStackView()
    let phoneStack = UIStackView()
    let passwordStack = UIStackView()
    
    let saveButton = UIButton()
    
    var makerImageView = UIImageView()
    
    lazy var newMakerIsSaved = false
    lazy var categoriesIsSaved = false
    
    weak var navController: UINavigationController?
    
    var picker = UIImagePickerController()
    
    // MARK: - Public
    var presenter: RegistrationViewOutputProtocol?
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension RegistrationViewController {
    func initialize() {
        view.backgroundColor = .white
        createRegistrationView()
        setupBarButtonItem()
        setupTopNameLabel()
        setupTextFields()
        createSaveButton()
        createMAkerImageView()
        createMenuTableView()
        addViewConstraints()
        setupMakerImageView()
        setMakerAnotation()
    }
    
    @objc func closeWindow() {
        self.dismiss(animated: true)
    }
    
    private func setMakerAnotation() {
        presenter?.getMakerAnotation()
    }
    
    //create Registration View
    private func createRegistrationView() {
        registrationView.backgroundColor = Colors.registrationViewColor.colorViewUIColor
        registrationView.layer.cornerRadius = 10
        view.addSubview(registrationView)
    }
    //add button on the barButton
    private func setupBarButtonItem(){
        if let navController = self.navigationController {
            self.navController = navController
            let back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeWindow))
            self.navigationItem.rightBarButtonItems = [back]
        }
    }
        
    //setup Registration Label
    private func setupTopNameLabel() {
        topHeaderLabel.font = Fonts.fontTopLabel.fontsForViews
        topHeaderLabel.textColor = Colors.headerColor.colorViewUIColor
        topHeaderLabel.text = "Регистрация"
        registrationView.addSubview(topHeaderLabel)
    }
    
    //configure TextView
    private func setupTextFields(){
        let colorPlaceHolder = Colors.placeHolderColor.colorViewUIColor
        
        surnameTextField.becomeFirstResponder()
        surnameTextField.font = Fonts.fontTextField.fontsForViews
        surnameTextField.textColor = Colors.textFieldColor.colorViewUIColor
        surnameTextField.attributedPlaceholder = NSAttributedString(string: "Фамилия", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        surnameTextField.textAlignment = .left
        surnameTextField.keyboardType = .namePhonePad
        nameTextField.font = Fonts.fontTextField.fontsForViews
        nameTextField.textColor = Colors.textFieldColor.colorViewUIColor
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        nameTextField.textAlignment = .left
        nameTextField.keyboardType = .namePhonePad
        
        //setup plus Label
        plusLabel.font = Fonts.fontTextField.fontsForViews
        plusLabel.textColor = Colors.blackLabel.colorViewUIColor
        plusLabel.text = "+"
        phoneTextField.font = Fonts.fontTextField.fontsForViews
        phoneTextField.textColor = Colors.textFieldColor.colorViewUIColor
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Телефон", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        phoneTextField.textAlignment = .left
        phoneTextField.keyboardType = .phonePad
        
        emailTextField.font = Fonts.fontTextField.fontsForViews
        emailTextField.textColor = Colors.textFieldColor.colorViewUIColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        emailTextField.textAlignment = .left
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.font = Fonts.fontTextField.fontsForViews
        passwordTextField.textColor = Colors.textFieldColor.colorViewUIColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль (не менее 6 символов", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.textAlignment = .left
        
        confirmPasswordTextField.font = Fonts.fontTextField.fontsForViews
        confirmPasswordTextField.textColor = Colors.textFieldColor.colorViewUIColor
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Подтверждение пароля", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        confirmPasswordTextField.textAlignment = .left
        
        surnameTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        phoneStack.addArrangedSubview(plusLabel)
        phoneStack.addArrangedSubview(phoneTextField)
        phoneStack.axis = .horizontal
        phoneStack.alignment = .leading
        phoneStack.spacing = 1.0
        
        topStack.addArrangedSubview(surnameTextField)
        topStack.addArrangedSubview(nameTextField)
        topStack.addArrangedSubview(phoneStack)
        topStack.addArrangedSubview(emailTextField)
        
        passwordStack.addArrangedSubview(passwordTextField)
        passwordStack.addArrangedSubview(confirmPasswordTextField)
        
        topStack.axis = .vertical
        topStack.distribution = .equalSpacing
        topStack.alignment = .leading
        topStack.spacing = 16.0
        
        passwordStack.axis = .vertical
        //topStack.backgroundColor = .yellow
        passwordStack.distribution = .equalSpacing
        passwordStack.alignment = .leading
        passwordStack.spacing = 16.0
        
        registrationView.addSubview(topStack)
        registrationView.addSubview(passwordStack)
    }
    
    private func createSaveButton(){
        //RouteButton.layer.masksToBounds = true
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(Colors.whiteLabel.colorViewUIColor, for: .normal)
        saveButton.backgroundColor = Colors.activeButtonColor.colorViewUIColor
        saveButton.titleLabel?.font = Fonts.fontButton.fontsForViews
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(isPressedSaveButton(sender: )), for: .touchUpInside)
        
        registrationView.addSubview(saveButton)
    }
    
    private func createMAkerImageView(){
        if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil){
            makerImageView.image = image
        }
        registrationView.addSubview(makerImageView)
    }
   
    private func setupMakerImageView(){
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.layer.masksToBounds = false
        makerImageView.clipsToBounds = true
        picker.delegate = self
        makerImageView.contentMode = .scaleAspectFill
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapForMakerImageAction(_:)))
        makerImageView.addGestureRecognizer(recognizer)
    }
    private func createMenuTableView() {
        
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        menuTableView.backgroundColor = .white
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        view.addSubview(menuTableView)
    }
    
    private func addViewConstraints() {
        
        registrationView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(50)
            make.width.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
        topHeaderLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        confirmPasswordTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        topStack.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.top.equalTo(topHeaderLabel).inset(50)
        }
        
        passwordStack.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(topStack.snp.bottom).offset(16)
        }
        
        saveButton.snp.makeConstraints { (make) -> Void in
            // make.left.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().inset(10)
        }
        
        makerImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(25)
            make.width.equalTo(65)
            make.height.equalTo(65)
            make.top.equalTo(topHeaderLabel).inset(25)
        }
        makerImageView.layoutIfNeeded()
        
        menuTableView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(registrationView.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(5)
            make.height.equalTo(90)
        }
    }
    
    //обработка нажатия кнопки Сохранить action when save button is pressed
    @objc func isPressedSaveButton (sender: UIButton){
        presenter?.isPressedSaveButton()
    }
    
    //обработка клика на makerImageFiew action when makerImageFiew is pressed
    @objc func tapForMakerImageAction (_ gestureRecognizer: UITapGestureRecognizer){
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

//MARK:- ImagePicker Controller Delegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //get maker's photo
    func imagePickerControllerDidCancel(_ picker:
                                        UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter?.isTappedMakerImage(info: info)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- RegistrationViewController
extension RegistrationViewController: UITextFieldDelegate {
    
    // скрыть клавиатуру после редактирования remove keyboard after edititng by tupping on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        presenter?.isTouchesBegan(touches: touches)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter?.isFieldShouldReturn(textField: textField)
        return true
    }
}

// MARK: - ImageViewerViewProtocol
extension RegistrationViewController: RegistrationViewInputProtocol {
    
    //hide keyboard when tap on view
    func hideKeyBoard(){
        view.endEditing(true)
    }
    
    //set Next Text Field
    func setNextTextField(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func alertWithTitle(title: String, message: String, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func updateMenuTableView(newMakerIsSaved: Bool?, categoriesIsSaved: Bool?) {
        var index = 0
        var status = false
        if let newMaker = newMakerIsSaved {
            self.newMakerIsSaved = newMaker
            index = 0
            status = newMaker
        }
        if let newCategoies = categoriesIsSaved {
            self.categoriesIsSaved = newCategoies
            index = 1
            status = newCategoies
        }
        menuTableView.cellForRow(at: [0,index])?.isUserInteractionEnabled = status
        menuTableView.cellForRow(at: [0,index])?.textLabel?.textColor = status ? Colors.activeButtonColor.colorViewUIColor : Colors.lightGrayButton.colorViewUIColor
    }
    
    func presentEditMessage(title: String?,
                            descriptionText: String?) {
        let alertController = UIAlertController(title: title,
                                                message: descriptionText,
                                                preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK",
                                  style: .default) {
            _ in
            self.presenter?.isTappedEditDataMaker()
        }
        let cancelBtn = UIAlertAction(title: "Отмена",
                                      style: .cancel,
                                      handler: nil)
        
        alertController.addAction(okBtn)
        alertController.addAction(cancelBtn)
        
        present(alertController,
                animated: true,
                completion: nil)
        
    }
    
    //после сохранения данных меняем название кнопки
    func changetitleButton() {
        saveButton.setTitle("Изменить", for: .normal)
    }
    
    //заполняем форму в соответсвии с данными на Maker, которые получили из модуля Map
    func updateMakerData(makerAnotation: MakerAnotation) {
        nameTextField.text = makerAnotation.nameMaker
        surnameTextField.text = makerAnotation.surnameMaker
        phoneTextField.text = makerAnotation.phoneNumberMaker
        emailTextField.text = makerAnotation.emailMaker
        
        changetitleButton()
        let productCategoriesBool = (makerAnotation.productCategoriesMaker?.first != nil)
        updateMenuTableView(newMakerIsSaved: true, categoriesIsSaved: productCategoriesBool)
        presenter?.getMakerImage(pathImage: makerAnotation.pathImageMaker)
    }
    //обновляем фото makera
    func setMakerImageView(imageMAker: UIImage) {
        makerImageView.image = imageMAker
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.listMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = listMenu.listMenu[indexPath.item]
        switch indexPath {
        case [0,0]:
            cell.textLabel?.textColor = newMakerIsSaved ?
            Colors.activeButtonColor.colorViewUIColor: Colors.lightGrayButton.colorViewUIColor
            cell.isUserInteractionEnabled = newMakerIsSaved
        case [0,1]:
            cell.textLabel?.textColor = categoriesIsSaved ? Colors.activeButtonColor.colorViewUIColor : Colors.lightGrayButton.colorViewUIColor
            cell.isUserInteractionEnabled = categoriesIsSaved
        default:
            cell.textLabel?.textColor =  Colors.lightGrayButton.colorViewUIColor
            cell.isUserInteractionEnabled = false
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.isSelectedRowMenuTableView(indexRow: indexPath.row)
    }
}
