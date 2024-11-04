//
//  SignUp.swift
//  WorkWave
//
//  Created by 조규연 on 11/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUp {
    @ObservableState
    struct State: Equatable {
        var email = ""
        var nickname = ""
        var phone = ""
        var password = ""
        var confirmPassword = ""
        var isEmailValid = false
        var isNicknameValid = false
        var isPhoneValid = false
        var isPasswordValid = false
        var isEmailDuplicateValid = false
        var signupButtonValid = false
        var invalidFieldTitles: Set<String> = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case signupButtonTapped
        case emailCheckButtonTapped
        case formatPhoneNumber(String)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.phone):
                let cleanedPhone = state.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() // 숫자가 아닌 문자열을 기준으로 분리하고 합침 == 문자열 제거
                return .run { send in
                    await send(.formatPhoneNumber(cleanedPhone))
                }
            case .binding:
                state.signupButtonValid = checkSignupButtonValid(state: state)
                return .none
            case .exitButtonTapped:
                return .none
            case .signupButtonTapped:
                state.isEmailValid = isValidEmail(state.email)
                state.isNicknameValid = isValidNickname(state.nickname)
                
                let cleanedPhone = state.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                state.isPhoneValid = isValidPhone(cleanedPhone)
                state.isPasswordValid = isValidPassword(state.password)
                
                state.invalidFieldTitles = getInvalidFieldTitles(state)
                return .none
            case .emailCheckButtonTapped:
                return .none
            case let .formatPhoneNumber(phone):
                state.phone = formatPhoneNumber(phone)
                return .none
            }
        }
    }
}

// MARK: 유효성 검사
private extension SignUp {
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }
    
    func isValidNickname(_ nickname: String) -> Bool {
        return !nickname.isEmpty && nickname.count <= 30
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = #"^01\d{8,9}$"# // 01로 시작하는 10~11자리 수
        return phone.range(of: phoneRegex, options: .regularExpression) != nil || phone.isEmpty
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // 8자 이상, 하나 이상의 대문자, 소문자, 숫자, 특수문자
        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"#
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
    
    func checkSignupButtonValid(state: State) -> Bool {
        return !state.email.isEmpty && !state.nickname.isEmpty && !state.password.isEmpty && !state.confirmPassword.isEmpty
    }
    
    private func getInvalidFieldTitles(_ state: State) -> Set<String> {
        var invalidFieldTitles: Set<String> = [] // 초기화
        if !state.isEmailValid {
            invalidFieldTitles.insert("이메일")
        }
        if !state.isNicknameValid {
            invalidFieldTitles.insert("닉네임")
        }
        if state.phone.isEmpty || !state.isPhoneValid {
            invalidFieldTitles.insert("연락처")
        }
        if !state.isPasswordValid {
            invalidFieldTitles.insert("비밀번호")
        }
        if state.password != state.confirmPassword {
            invalidFieldTitles.insert("비밀번호 확인")
        }
        return invalidFieldTitles
    }
}

// MARK: 전화번호 포맷팅
private extension SignUp {
    func formatPhoneNumber(_ phone: String) -> String {
        let length = phone.count
        switch length {
        case 11:
            return "\(phone.prefix(3))-\(phone.dropFirst(3).prefix(4))-\(phone.dropFirst(7))"
        case 10:
            return "\(phone.prefix(3))-\(phone.dropFirst(3).prefix(3))-\(phone.dropFirst(6))"
        default:
            return phone
        }
    }
}
