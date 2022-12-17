//
//  RegistrationPresenter.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
//import Foundation
import MapKit

 protocol RegistrationPresenterProtocol: AnyObject {
    func isTouchesBegan(touches: Set<UITouch>)
    func isFieldShouldReturn(textField: UITextField)
    func isPressedSaveButton()
    func istTappedMakerImage(info: [UIImagePickerController.InfoKey : Any])
}

 class RegistrationPresenter {
     let validData = ValidData()
     weak var view: RegistrationViewProtocol?
     var router: RegistrationRouterProtocol
     var interactor: RegistrationInteractorProtocol
     var touchCoordinate: CLLocationCoordinate2D
     var urlImageMaker: URL?
    
    init(interactor: RegistrationInteractorProtocol, router: RegistrationRouterProtocol, touchCoordinate: CLLocationCoordinate2D) {
        self.interactor = interactor
        self.router = router
        self.touchCoordinate = touchCoordinate
    }
}

extension RegistrationPresenter: RegistrationPresenterProtocol {

    //hide keyboard when tap on view
    func isTouchesBegan(touches: Set<UITouch>) {
        if touches.first != nil {
            view?.hideKeyBoard()
        }
    }
    
    func isFieldShouldReturn(textField: UITextField) {
        
        switch textField {
        case view?.surnameTextField:
            guard let nameTextField = view?.nameTextField else { return }
            view?.setNextTextField(textField: nameTextField)
        case view?.nameTextField:
            guard let phoneTextField = view?.phoneTextField else { return }
            view?.setNextTextField(textField: phoneTextField)
        case view?.phoneTextField:
            guard let emailTextField = view?.emailTextField else { return }
            view?.setNextTextField(textField: emailTextField)
        case view?.emailTextField:
            guard let passwordTextField = view?.passwordTextField else { return }
            view?.setNextTextField(textField: passwordTextField)
        case view?.passwordTextField:
            guard let confirmPasswordTextField = view?.confirmPasswordTextField else {
                return }
            view?.setNextTextField(textField: confirmPasswordTextField)
        default:
            break
        }
    }
    
    func isPressedSaveButton() {
        let error = checkForErrors()

        guard error, let surnameMaker = view?.surnameTextField.text,
              let nameMaker = view?.nameTextField.text,
              let phoneNumberMaker = view?.phoneTextField.text,
              let emailMaker = view?.emailTextField.text,
              let passwordMaker = view?.passwordTextField.text
        else { return }
        
        interactor.saveDataNewMaker(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, urlImageMaker: urlImageMaker, touchCoordinateMaker: touchCoordinate)
    }
    
    func checkForErrors() -> Bool
        {
            var errors = false
            let title = "Внимание"
            var message = ""
            guard let textField = view?.surnameTextField, let text = textField.text else { return false }
            if text.isEmpty {
                errors = true
                message += "Введите фамилию"
                view?.alertWithTitle(title: title, message: message, toFocus: textField)
            } else {
                guard let textField = view?.nameTextField, let text = textField.text else { return false }
                if text.isEmpty {
                    errors = true
                    message += "Введите имя"
                    view?.alertWithTitle(title: title, message: message, toFocus: textField)
                } else {
                    guard let textField = view?.phoneTextField, let text = textField.text else { return false }
                    if text.isEmpty {
                        errors = true
                        message += "Введите номер телефона"
                        view?.alertWithTitle(title: title, message: message, toFocus: textField)
                    } else if !validData.isValidPhoneNumber(text) {
                        errors = true
                        message += "Введите корректный номер телефона"
                        view?.alertWithTitle(title: title, message: message, toFocus: textField)
                    } else {
                        guard let textField = view?.emailTextField, let text = textField.text else { return false }
                        if text.isEmpty {
                            errors = true
                            message += "Введите адрес электронной почты"
                            view?.alertWithTitle(title: title, message: message, toFocus: textField)
                        } else if !validData.isValidEmailAddress(emailAddressString: text) {
                            errors = true
                            message += "Введите корректный адрес электронной почты"
                            view?.alertWithTitle(title: title, message: message, toFocus: textField)
                        } else {
                            guard let textField = view?.passwordTextField, let text = textField.text else { return false }
                            if text.count < 6 {
                                errors = true
                                message += "Введите пароль не менее 6 символов "
                                view?.alertWithTitle(title: title, message: message, toFocus: textField)
                            } else {
                                guard let textField = view?.confirmPasswordTextField, let text = textField.text else { return false }
                                if text != view?.passwordTextField.text {
                                    errors = true
                                    message += "Введенные пароли не совпадают"
                                    view?.alertWithTitle(title: title, message: message, toFocus: textField)
                                }
                            }
                        }
                    }
                }
            }
            return errors
        }
    
    func istTappedMakerImage(info: [UIImagePickerController.InfoKey : Any]) {
       // interactor.getImageForMakerImageView(info: info)
        
        if let chosenImage = info[.originalImage] as? UIImage {
           // imgPhoto.contentMode = .scaleToFill
            view?.makerImageView.image = chosenImage
            //interactor.getImageForMakerImageView(forSaveImage: UIImage)
            
            //сохраняем фото юзера в файл
//            let path = "photo/temp/album1/img.jpg"
//
            let path = "photo/temp/sweethome/maker"
            let tempDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
            guard let url = chosenImage.save(at: tempDirectoryUrl) else { return }
            print(url)
            urlImageMaker = url
//            guard
//                    let url = chosenImage.save(at: .documentDirectory,
//                                       pathAndImageName: path) else { return }
//            print(url)
        } else{
            print("Something went wrong")
        }
    }
    

}