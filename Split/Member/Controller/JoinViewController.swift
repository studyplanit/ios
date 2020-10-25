//
//  JoinViewController.swift
//  Split
//
//  Created by najin on 2020/10/14.
//

import UIKit
import Alamofire

class JoinViewController: UIViewController, UITextFieldDelegate {

    //MARK:- 선언 및 초기화
    //MARK: 프로퍼티 선언
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var nickCheckLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var baseURL = "http://203.245.28.184"
    var nickCheck = false
    var phone = ""
    
    //MARK: 버튼 활성화 함수
    func buttonEnableStyle(button: UIButton){
        button.backgroundColor = .purple
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
        nickTextField.delegate = self
        
        buttonDisableStyle(button: nextButton)
        
    }
    
    //MARK: 입력값 유효성 검사
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //핸드폰번호길이 유효성 검사
        if nickTextField.text!.count > 8 || nickTextField.text!.count < 2 {
            nickCheckLabel.text = "사용하실 닉네임을 2~8자로 설정해주세요"
            nickCheck = false
            buttonDisableStyle(button: nextButton)
        }else {
            struct Nick: Encodable {
                let nick: String
            }
            struct CheckNick : Decodable {
                let isMember : Int
            }
            
            let nickname = Nick(nick: self.nickTextField.text!)
            let URL = self.baseURL+"/member/check-nick"
            let alamo = AF.request(URL, method: .post, parameters: nickname, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)

            alamo.responseDecodable(of: CheckNick.self) { (response) in
                guard let isMemberCheck = response.value else { return }
                if isMemberCheck.isMember == 0 {
                    self.nickCheckLabel.text = "사용가능한 닉네임입니다"
                    self.nickCheck = true
                    self.buttonEnableStyle(button: self.nextButton)
                } else {
                    self.nickCheckLabel.text = "중복된 닉네임입니다"
                    self.nickCheck = false
                    self.buttonDisableStyle(button: self.nextButton)
                }
            }
        }
    }
    
    //영어,한글,숫자만 입력가능하도록 설정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        do{
            let regex = try NSRegularExpression(pattern: "[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ0-9]", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, string.count)){
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        if isBackSpace == -92{
            return true
        }
        return false
    }

    //MARK:- 완료버튼 누른 후
    @IBAction func nextButtonClick(_ sender: UIButton) {

        //회원정보 입력 post url
        struct Member: Encodable {
            var id: Int
            var nickname: String
            var phone: String
        }
        //닉네임 중복검사하기
        
//        var self.nickTextField.text
        
        let member = Member(id: 0, nickname: self.nickTextField.text!, phone: MemberVO.shared.phone!)
        let URL = self.baseURL+"/member/"
        let alamo = AF.request(URL, method: .post, parameters: member, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
        
        alamo.responseDecodable(of: MemberVO.self) { (response) in
            guard let member = response.value else { return }
            UserDefaults.standard.set(member.id, forKey: "id")
            //메인페이지로 이동
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
            self.navigationController?.pushViewController(nextView!, animated: false)
        }
    }
}
