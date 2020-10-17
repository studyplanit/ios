//
//  SmsAuthViewController.swift
//  Split
//
//  Created by najin on 2020/10/14.
//

import UIKit
import Alamofire

//로그인,회원가입-회원 핸드폰번호 인증 컨트롤러
class SmsAuthViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- 선언 및 초기화
    //MARK: 프로퍼티 선언
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authTimerLabel: UILabel!
    @IBOutlet weak var authCheckLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var phoneNumber = ""
    var authNumber = 135792468
    var memberId = 0
    var timer: Timer?
    var timeLeft = 300
    var baseURL = "http://203.245.28.184:8000"
    
    struct Auth : Decodable {
        let authNumber : Int
        let id : Int
    }
    
    //MARK: 타이머 함수
    @objc func onTimerUpdate() {
        timeLeft = timeLeft - 1
        
        if timeLeft == 0 {
            //인증번호 초기화하기
            timer?.invalidate()
            authTimerLabel.isHidden = true
        }
        
        let minutes = (timeLeft % 3600) / 60
        let seconds = (timeLeft % 3600) % 60
        
        if seconds >= 10 {
            authTimerLabel.text = "\(minutes):\(seconds)"
        } else {
            authTimerLabel.text = "\(minutes):0\(seconds)"
        }
        
    }
    
    //MARK: 버튼 활성화 함수
    func buttonEnableStyle(button: UIButton){
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
        button.layer.cornerRadius = 10
    }
    
    //MARK: 버튼 비활성화 함수
    func buttonDisableStyle(button: UIButton){
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 10
    }
    
    //MARK: 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
        authNumberTextField.delegate = self
        
        buttonDisableStyle(button: sendSMSButton)
        buttonDisableStyle(button: nextButton)
        authTimerLabel.isHidden = true
        authNumberTextField.isHidden = true
        authCheckLabel.isHidden = true
    }

    //MARK: 입력값 유효성 검사
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //핸드폰번호길이 유효성 검사
        if phoneTextField.text?.count ?? 0 > 8 {
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
        phoneNumber = phoneTextField.text!
        sendSMSButton.setTitle("재전송", for: .normal)
        authNumberTextField.isHidden = false
        nextButton.isHidden = false
        authTimerLabel.isHidden = false
        authNumberTextField.text = ""
        
        //타이머 시작
        timeLeft = 300
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerUpdate), userInfo: nil, repeats: true)
        
        //url보내기
        let URL = baseURL+"/member/sms-auth/"+phoneNumber
        let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
        
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
            if memberId == 0 {
                //회원이 아니므로 회원가입 페이지로 이동
                MemberVO.shared.phone = phoneNumber
                self.dismiss(animated: false, completion: nil)
                let nextView = self.storyboard?.instantiateViewController(withIdentifier: "joinViewController")
                nextView?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.present(nextView!, animated: false, completion: nil)
            } else {
                //회원이므로 id정보를 가지고 get방식으로 회원정보 가져오기
                let URL = baseURL+"/member/"+String(memberId)
                let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
                
                alamo.responseDecodable(of: Auth.self) { (response) in
                    guard let member = response.value else { return }
//                    MemberVO.shared.id = member.id
//                    MemberVO.shared.nickname = member.nick
                }
                //model에 회원정보 셋팅하기
                //홈화면으로 이동하기
                //자동로그인 구현
                UserDefaults.standard.set("id", forKey: "id")
                //로그아웃 : UserDefaults.standard.removeObject(self.id, forKey: "id")
            }
        } else {
            authCheckLabel.isHidden = false
        }
    }
    
}
