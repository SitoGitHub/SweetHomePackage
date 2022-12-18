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
    
    var nameTextField: UITextField { get }
    var surnameTextField: UITextField { get }
    var phoneTextField: UITextField { get }
    var emailTextField: UITextField { get }
    var passwordTextField: ShowHideTextField { get }
    var confirmPasswordTextField: ShowHideTextField { get }
   // var picker: UIImagePickerController { get set }
    var makerImageView: UIImageView { get }
}

class RegistrationViewController: UIViewController {
    
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
    
    var picker = UIImagePickerController()
    
    // MARK: - Public
    var presenter: RegistrationViewOutputProtocol?
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
//     override func layoutSubviews() {
//        super.layoutSubviews()
//
//         makerImageView.layer.cornerRadius = makerImageView.bounds.size.width * 0.5
//    }
    
}

// MARK: - Private functions
private extension RegistrationViewController {
    func initialize() {
        view.backgroundColor = .white
        setupCurrencyNameLabel()
        setupNameTextField()
        createSaveButton()
        createMAkerImageView()
    }
    
    //setup Registration Label
    private func setupCurrencyNameLabel() {
        topHeaderLabel.font = Fonts.fontTopLabel.fontsForViews
        topHeaderLabel.textColor = Colors.headerColor.colorViewUIColor
        topHeaderLabel.text = "Регистрация"
        view.addSubview(topHeaderLabel)
        
        topHeaderLabel.snp.makeConstraints { (make) -> Void in
                   make.centerX.equalToSuperview()
                   make.top.equalToSuperview().inset(40)
                   //make.height.equalTo(20)
               }
    }
    
    //configure TextView
    private func setupNameTextField(){
        let colorPlaceHolder = Colors.placeHolderColor.colorViewUIColor
        
        surnameTextField.becomeFirstResponder()
        //surnameTextField.backgroundColor = .brown
        surnameTextField.font = Fonts.fontTextField.fontsForViews
        surnameTextField.textColor = Colors.textFieldColor.colorViewUIColor
        surnameTextField.attributedPlaceholder = NSAttributedString(string: "Фамилия", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        surnameTextField.textAlignment = .left
        surnameTextField.keyboardType = .namePhonePad
        
       // nameTextField.backgroundColor = .brown
        
        nameTextField.font = Fonts.fontTextField.fontsForViews
        nameTextField.textColor = Colors.textFieldColor.colorViewUIColor
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        nameTextField.textAlignment = .left
        nameTextField.keyboardType = .namePhonePad
        
        //setup plus Label
        plusLabel.font = Fonts.fontTextField.fontsForViews
        plusLabel.textColor = Colors.blackLabel.colorViewUIColor
        plusLabel.text = "+"
        
        //phoneTextField.backgroundColor = .brown
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
        
        //phoneTextField.backgroundColor = .brown
        passwordTextField.font = Fonts.fontTextField.fontsForViews
        passwordTextField.textColor = Colors.textFieldColor.colorViewUIColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль (не менее 6 символов", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        //passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.textAlignment = .left
        //passwordTextField.keyboardType = .
        
        //phoneTextField.backgroundColor = .brown
        confirmPasswordTextField.font = Fonts.fontTextField.fontsForViews
        confirmPasswordTextField.textColor = Colors.textFieldColor.colorViewUIColor
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Подтверждение пароля", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: Fonts.fontTextField.fontsForViews])
        confirmPasswordTextField.textAlignment = .left
        //confirmPasswordTextField.keyboardType = .phonePad
        
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
        //topStack.backgroundColor = .yellow
        topStack.distribution = .equalSpacing
        topStack.alignment = .leading
        topStack.spacing = 16.0
        
        passwordStack.axis = .vertical
        //topStack.backgroundColor = .yellow
        passwordStack.distribution = .equalSpacing
        passwordStack.alignment = .leading
        passwordStack.spacing = 16.0
        
       // topStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topStack)
        view.addSubview(passwordStack)
        
//        surnameTextField.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
//
//        nameTextField.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
//
//        plusLabel.snp.makeConstraints { (make) -> Void in
//           // make.width.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
        
//        phoneTextField.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
       
//        emailTextField.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
//
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
            //make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        passwordStack.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            
            make.top.equalTo(topStack.snp.bottom).offset(16)
            //make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func createSaveButton(){
        //RouteButton.layer.masksToBounds = true
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(Colors.whiteLabel.colorViewUIColor, for: .normal)
        saveButton.backgroundColor = Colors.activeButtonColor.colorViewUIColor
        saveButton.titleLabel?.font = Fonts.fontButton.fontsForViews
        saveButton.layer.cornerRadius = 10
        
        //saveButton.isUserInteractionEnabled = false
        //RouteButton.isEnabled = true
        saveButton.addTarget(self, action: #selector(isPressedSaveButton(sender: )), for: .touchUpInside)
       // routeButton.frame = CGRect(x: 50, y: 50, width: 70, height: 30)
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { (make) -> Void in
           // make.left.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(30)
            make.top.equalTo(passwordStack.snp.bottom).offset(15)
        }
    }
    
    private func createMAkerImageView(){
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.layer.masksToBounds = false
        makerImageView.clipsToBounds = true
        picker.delegate = self
        
        makerImageView.contentMode = .scaleAspectFill
        if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil){
            makerImageView.image = image
        }
        view.addSubview(makerImageView)
        
        makerImageView.snp.makeConstraints { (make) -> Void in
           // make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().inset(25)
            make.width.equalTo(65)
            make.height.equalTo(65)
            make.top.equalTo(topHeaderLabel).inset(50)
        }
        makerImageView.layoutIfNeeded()
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        
        makerImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapForMakerImageAction(_:)))
        makerImageView.addGestureRecognizer(recognizer)
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
    
    
    
}
