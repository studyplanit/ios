//
//  SmsAuthViewController.swift
//  Split
//
//  Created by najin on 2020/10/14.
//

import UIKit
import Alamofire

//로그인,회원가입-회원 핸드폰번호 인증 컨트롤러
class SmsAuthViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- 선언 및 초기화
    //MARK: 프로퍼티 선언
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authCheckLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    var phoneNumber = ""
    var authNumber = 135792468
    var authCount = 0
    var memberId = 0
    var timer: Timer?
    var timeLeft = 300
    
    struct Auth : Decodable {
        let authNumber : Int
        let id : Int
    }
    
    //MARK: 타이머 함수
    @objc func onTimerUpdate() {
        timeLeft = timeLeft - 1
        
        if timeLeft == 0 {
            timer?.invalidate()
        }
        if timeLeft == 297 {
            //팝업 없애기
            UIView.animate(withDuration: 0.5) {
                self.popUpView.transform = CGAffineTransform(translationX: 0, y: -100)
            }
        }
        
        let minutes = (timeLeft % 3600) / 60
        let seconds = (timeLeft % 3600) % 60
        
        if seconds >= 10 {
            sendSMSButton.setTitle("재전송 \(minutes):\(seconds)", for: .normal)
        } else {
            sendSMSButton.setTitle("재전송 \(minutes):0\(seconds)", for: .normal)
        }
        
    }
    
    //MARK: 버튼 활성화 함수
    func buttonEnableStyle(button: UIButton){
        button.backgroundColor = Common().purple
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
        button.layer.cornerRadius = 5
    }
    
    //MARK: 버튼 비활성화 함수
    func buttonDisableStyle(button: UIButton){
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 5
    }
    
    //MARK: 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //자동로그인 구현
        if UserDefaults.standard.string(forKey: "id") != nil {
            //메인페이지로 이동
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
            self.navigationController?.pushViewController(nextView!, animated: false)
        }
        
        phoneTextField.delegate = self
        authNumberTextField.delegate = self
        
        buttonDisableStyle(button: sendSMSButton)
        buttonDisableStyle(button: nextButton)
        nextButton.isHidden = true
        authNumberTextField.isHidden = true
        authCheckLabel.isHidden = true
        popUpView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.9)
        
        //이용약관 및 개인정보 동의 label
//        let underlineAttriString = NSMutableAttributedString(string: agreementLabel.text!)
//        let range1 = (agreementLabel.text! as NSString).range(of: "이용약관")
//        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
//        let range2 = (agreementLabel.text! as NSString).range(of: "개인정보동의")
//        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
//        agreementLabel.attributedText = underlineAttriString
    }
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = CGPoint(x: label.intrinsicContentSize.width, y:label.intrinsicContentSize.height)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        print("aaa")
        let text = (agreementLabel.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")

        if didTapAttributedTextInLabel(label: agreementLabel, inRange: termsRange) {
            print("이용약관")
        } else if didTapAttributedTextInLabel(label: agreementLabel, inRange: privacyRange) {
            print("개인정보동의")
        } else {
            print("??")
        }
    }
    
    //MARK: 키보드 없애기
    @IBAction func tabView(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: 입력값 유효성 검사
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //핸드폰번호길이 유효성 검사
        if authCount < 5 {
            if phoneTextField.text?.count ?? 0 > 10 {
                buttonEnableStyle(button: sendSMSButton)
            } else {
                buttonDisableStyle(button: sendSMSButton)
            }
            
            //인증번호 유효성 검사
            if authNumberTextField.text?.count == 0 {
                buttonDisableStyle(button: nextButton)
            } else {
                buttonEnableStyle(button: nextButton)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //최대 11문자만 입력가능하도록 설정
        guard let textFieldText = textField.text, let rangeOfTextToReplce = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplce]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        //숫자만 입력가능하도록 설정
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return count <= 11 && allowedCharacters.isSuperset(of: characterSet)
        
    }
    
    //MARK:- 전송버튼 누른 후
    @IBAction func sendSMSButtonClick(_ sender: UIButton) {
        //프로퍼티 상태 변경
        sendSMSButton.setTitle("재전송 5:00", for: .normal)
        phoneNumber = phoneTextField.text!
        authNumberTextField.isHidden = false
        nextButton.isHidden = false
        authNumberTextField.text = ""
        authCheckLabel.isHidden = true
        //팝업 띄우기
        UIView.animate(withDuration: 0.5) {
            self.popUpView.transform = CGAffineTransform(translationX: 0, y: 100)
        }
        //타이머 시작
        timeLeft = 300
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerUpdate), userInfo: nil, repeats: true)
        
        //sms인증 get url보내기
        struct Phone: Encodable {
            var phone: String
            var accessCode: String
        }
        let phone = Phone(phone: phoneNumber,accessCode:"C2A4D50CB9BF00320030003200300021")
        let URL = Common().baseURL+"/member/sms-auth"
        let alamo = AF.request(URL, method: .post, parameters: phone, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
        
        alamo.responseDecodable(of: Auth.self) { (response) in
            guard let auth = response.value else { return }
            self.authNumber = auth.authNumber
            self.memberId = auth.id
            print(self.authNumber)
        }
    }
    
    //MARK:- 확인 버튼 눌렀을 때
    @IBAction func nextButtonClick(_ sender: UIButton) {
        if authNumberTextField.text == String(authNumber) {
            if timeLeft == 0 {
                authCheckLabel.isHidden = false
                authCheckLabel.text = "인증번호 입력시간이 초과되었습니다."
            } else if memberId == 0 {
                //회원이 아니므로 회원가입 페이지로 이동
                MemberVO.shared.phone = phoneNumber
                let nextView = self.storyboard?.instantiateViewController(withIdentifier: "joinViewController")
                self.navigationController?.pushViewController(nextView!, animated: false)
            } else {
                //회원이므로 id정보를 가지고 get방식으로 회원정보 가져오기
                let URL = Common().baseURL+"/member/"+String(memberId)
                let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
                
                alamo.responseDecodable(of: MemberVO.self) { (response) in
                    guard let member = response.value else { return }
                    UserDefaults.standard.set(member.id, forKey: "id")
                    //메인페이지로 이동
                    let nextView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                    self.navigationController?.pushViewController(nextView!, animated: false)
                }
            }
        } else {
            //인증번호 입력횟수
            authCheckLabel.isHidden = false
            if authCount >= 5 {
                authNumber = 135792468
                authCheckLabel.text = "인증번호 입력횟수가 초과되었습니다."
                buttonDisableStyle(button: nextButton)
                buttonDisableStyle(button: sendSMSButton)
                timer?.invalidate()
                sendSMSButton.setTitle("입력횟수 초과", for: .normal)
            } else {
                authCount += 1
                authCheckLabel.text = "인증번호가 틀렸습니다(\(authCount)/5)"
            }
        }
    }
}
