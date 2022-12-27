//
//  RegistrationPresenter.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
//import Foundation
import MapKit

protocol RegistrationViewOutputProtocol: AnyObject {
    func isTouchesBegan(touches: Set<UITouch>)
    func isFieldShouldReturn(textField: UITextField)
    func isPressedSaveButton()
    func isSelectedRowMenuTableView(indexRow: Int)
    func isTappedMakerImage(info: [UIImagePickerController.InfoKey : Any])
    //func isFieldSDidEndEditing(textField: UITextField)
    func isTappedEditDataMaker()
    func getMakerAnotation()
    func getMakerImage(pathImage: String?)
}

protocol RegistrationInteractorOutputProtocol: AnyObject {
    func existAlreadyMaker(phoneNumberMaker: String, email: String)
    func fetchedMakerData(maker: MakerAnotation?, error: Errors?)
    func isNeedEditMaker(phoneNumberMaker: String, email: String)
    func isSavedData()
    func isEditedData() 
}

protocol GetProductCategoriesDelegate: AnyObject {
    func isChangedProductCategoriesMakers(isChanged: Bool)
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation])
}

// MARK: -  RegistrationPresenter
 class RegistrationPresenter {
     let validData = ValidData()
     lazy var imageManager = ImageManager()
     weak var view: RegistrationViewInputProtocol?
     weak var delegate: RegistrationModuleDelegate? //= MapPresenter(interactor: MapInteractor(), router: MapRouter())
      var router: RegistrationRouterInputProtocol
      var interactor: RegistrationInteractorInputProtocol
     var touchCoordinate: CLLocationCoordinate2D
     var pathImageMaker: String?
     lazy var password = String()
    // lazy var maker = Maker()
     var phoneMaker = String()
     var email = String()
     var surnameMaker = String()
     var nameMaker = String()
     let makerAnotation: MakerAnotation? //данные из MapView
    
     
     init(interactor: RegistrationInteractorInputProtocol, router: RegistrationRouterInputProtocol,/* mapPresenter: RegistrationPresenterOutputProtocol,*/ touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) {
        self.interactor = interactor
        self.router = router
         //self.mapPresenter = mapPresenter
        self.touchCoordinate = touchCoordinate
         self.makerAnotation = makerAnotation
    }
     
     deinit{
         print("RegistrationPresenter deinit")
     }
}

// MARK: - RegistrationViewOutputProtocol
extension RegistrationPresenter: RegistrationViewOutputProtocol {
    
    //запрос на makerAnnotation
    func getMakerAnotation(){
        if let makerAnotation = makerAnotation {
            view?.updateMakerData(makerAnotation: makerAnotation)
            phoneMaker = makerAnotation.phoneNumberMaker
            email = makerAnotation.phoneNumberMaker
        }
    }
    //hide keyboard when tap on view
    func isTouchesBegan(touches: Set<UITouch>) {
        if touches.first != nil {
            view?.hideKeyBoard()
        }
    }
    
    //переход на следующий textField
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
    
    //обработка нажатия конпки SaveButton
    func isPressedSaveButton() {
        let error = checkForErrors()
        
        guard !error, let surnameMaker = view?.surnameTextField.text,
              let nameMaker = view?.nameTextField.text,
              let phoneNumberMaker = view?.phoneTextField.text,
              let emailMaker = view?.emailTextField.text
              //let passwordMaker = password
        else { return }
        
        self.surnameMaker = surnameMaker
        self.nameMaker = nameMaker
        self.phoneMaker = phoneNumberMaker
        self.email = emailMaker
        
        interactor.saveDataNewMaker(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: password, pathImageMaker: pathImageMaker, touchCoordinateMaker: touchCoordinate)
    }
    
    //проверка на корректное заполнение данных нового makerа
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
                            } else {
                                password = text
                            }
                        }
                    }
                }
            }
        }
        return errors
    }
    
    // Helper function inserted by Swift 4.2 migrator. For imagePickerController
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {

        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})

    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {

        return input.rawValue

    }
    
    //выбор фото нового makera
    func isTappedMakerImage(info: [UIImagePickerController.InfoKey : Any]) {
        // interactor.getImageForMakerImageView(info: info)
       // var fileName = String()
        if let chosenImage = info[.originalImage] as? UIImage {
            // imgPhoto.contentMode = .scaleToFill
            var fileName = String()
            view?.makerImageView.image = chosenImage
            
            // info: Local variable inserted by Swift 4.2 migrator.
                  let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

                  if let url = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL {
                      fileName = url.lastPathComponent
                      
                  }
            
            
//            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
//                   if let fileName = (asset.value(forKey: "filename")) as? String {
                       //Do your stuff here
              //     }
              // }
            //interactor.getImageForMakerImageView(forSaveImage: UIImage)
            
            //сохраняем фото юзера в файл
            //            let path = "photo/temp/album1/img.jpg"
            
            //generate unique filname
            let name = ProcessInfo.processInfo.globallyUniqueString
            let path = "photo/temp/sweethome2/maker/\(name).jpeg"
            let tempDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
            guard let url = chosenImage.save(at: tempDirectoryUrl) else { return }
            print(url)
            pathImageMaker = path//url
            //            guard
            //                    let url = chosenImage.save(at: .documentDirectory,
            //                                       pathAndImageName: path) else { return }
            //            print(url)
        } else{
            print("Something went wrong")
        }
    }
    
    func isSelectedRowMenuTableView(indexRow: Int) {
        print("This cell was selected: \(indexRow)")
        //      router.openScreen(for: touchCoordinate)
        guard let navigationController = view?.navController else { return }
        switch indexRow {
        case 0:
            router.pushGetProductCategoriesViewController(to: navigationController, animated: true, phoneMaker: self.phoneMaker, emailMaker: self.email)
        case 1:
            router.pushAddProductViewController(to: navigationController, animated: true)
        default:
            return
        }
    }
    //вызываем редактирование данных Makera
    func isTappedEditDataMaker() {
        let error = checkForErrors()
        
        guard !error, let surnameMaker = view?.surnameTextField.text,
              let nameMaker = view?.nameTextField.text,
              let phoneNumberMaker = view?.phoneTextField.text,
              let emailMaker = view?.emailTextField.text
              //let passwordMaker = password
        else { return }
        
        interactor.editDataMaker(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: password, pathImageMaker: pathImageMaker, touchCoordinateMaker: touchCoordinate)
    }
    
    //загружаем фото мейкера и передаем ее во view
    func getMakerImage(pathImage: String?) {
        var imageMaker = UIImage()
        if let image = imageManager.getImage(pathImage: pathImage){
            imageMaker = image
        } else {
            if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil) {
                imageMaker = image
            }
        }
        
        view?.setMakerImageView(imageMAker: imageMaker)
        
    }
}

// MARK: - RegistrationInteractorOutputProtocol
extension RegistrationPresenter: RegistrationInteractorOutputProtocol {
    
    //передаем данные в Map module для формирования пина
    func fetchedMakerData(maker: MakerAnotation?, error: Errors?) {
        
        guard let maker = maker, error == nil else {
            switch error {
            case .loadCountriesError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении названий стран")
            case .loadCitiesError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении названий городов")
            case .loadMakersError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении поставщиков услуг")
            default:
                return
            }
            return
        }
        //активируем ячейку таблицы для выбора категорий продуктов мейкера
        view?.updateMenuTableView(newMakerIsSaved: true, categoriesIsSaved: nil)
        //передаем в map модуль данные для пина
        self.delegate?.fetchedNewMakerData(pinMakers: [maker])
        
    }
    
    // оповещение, если такой Maker в системе уже есть
    func existAlreadyMaker(phoneNumberMaker: String, email: String) {
        router.presentWarnMessage(title: "Внимание",
                                 descriptionText: "Поставщик услуг с номером \(phoneNumberMaker) или email \(email) уже зарегестрирован ранее. Проверьте данные.")
    }
    // оповещение, если данные успешно сохранились
    func isSavedData() {
        router.presentWarnMessage(title: "Внимание",
                                 descriptionText: "Данные успешно сохранены.")
        view?.changetitleButton()
        
    }
    
    func isEditedData() {
        router.presentWarnMessage(title: "Внимание",
                                 descriptionText: "Данные успешно изменены.")
        view?.changetitleButton()
        
    }
    
    func isNeedEditMaker(phoneNumberMaker: String, email: String) {
        view?.presentEditMessage(title: "Внимание",
                                 descriptionText: "Хотите внести изменения?")
    }
    

}

extension RegistrationPresenter: GetProductCategoriesDelegate {
    
    func isChangedProductCategoriesMakers(isChanged: Bool) {
        //активируем ячейку таблицы для выбора категорий продуктов мейкера
        view?.updateMenuTableView(newMakerIsSaved: true, categoriesIsSaved: isChanged)
    }
    
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation]) {
        self.delegate?.fetchedNewMakerData(pinMakers: pinMakers)
    }
}
