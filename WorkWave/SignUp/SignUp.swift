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
    let jwtKeyChain: JWTKeyChainProtocol
    let deviceTokenKeyChain: DeviceTokenKeyChainProtocol
    
    @ObservableState
    struct State: Equatable {
        var email = ""
        var nickname = ""
        var phone = ""
        var password = ""
        var confirmPassword = ""
        var toast: ToastState = ToastState(toastMessage: "", isToastPresented: false)
        
        var isEmailValid = false
        var isNicknameValid = false
        var isPhoneValid = false
        var isPasswordValid = false
        var isEmailDuplicateValid = false
        var signupButtonValid = false
        
        var invalidFieldTitles: Set<String> = []
        var focusedField: Field?
        
        enum Field: Hashable {
            case email, nickname, phone, password, confirmpassword
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case signupButtonTapped
        case emailCheckButtonTapped
        case formatPhoneNumber(String)
        case emailCheckResponse(Result<Void, ErrorResponse>)
        case emailInvalidResponse
        case signupResponse(Result<SignupDTO, ErrorResponse>)
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
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
                // validation update
                state.isEmailValid = isValidEmail(state.email)
                state.isNicknameValid = isValidNickname(state.nickname)
                
                let cleanedPhone = state.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                state.isPhoneValid = isValidPhone(cleanedPhone)
                state.isPasswordValid = isValidPassword(state.password)
                
                // invalidFieldTitles update
                state.invalidFieldTitles = getInvalidFieldTitles(state)
                
                // focus update
                if !state.isEmailDuplicateValid {
                    state.toast = ToastState(toastMessage: "이메일 중복 확인을 진행해주세요.", isToastPresented: true)
                    return .none
                } else if !state.isEmailValid {
                    state.focusedField = .email
                    return .none
                } else if !state.isNicknameValid {
                    state.focusedField = .nickname
                    state.toast = ToastState(toastMessage: "닉네임은 1글자 이상 30글자 이내로 부탁드려요.", isToastPresented: true)
                    return .none
                } else if !state.isPhoneValid {
                    state.focusedField = .phone
                    state.toast = ToastState(toastMessage: "잘못된 전화번호 형식입니다.", isToastPresented: true)
                    return .none
                } else if !state.isPasswordValid {
                    state.focusedField = .password
                    state.toast = ToastState(toastMessage: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.", isToastPresented: true)
                    return .none
                } else if state.password != state.confirmPassword {
                    state.focusedField = .confirmpassword
                    state.toast = ToastState(toastMessage: "작성하신 비밀번호가 일치하지 않습니다.", isToastPresented: true)
                    return .none
                } else {
                    let request = SignupRequest(email: state.email, password: state.password, nickname: state.nickname, phone: state.phone, deviceToken: deviceTokenKeyChain.deviceToken ?? "")
                    return .run { send in
                        do {
                            await send(.signupResponse(.success(try await userClient.signup(request))))
                        } catch let error as ErrorResponse {
                            await send(.signupResponse(.failure(error)))
                        } catch {
                            throw error
                        }
                    }
                }
                
                
            case .emailCheckButtonTapped:
                state.isEmailValid = isValidEmail(state.email)
                let request = ValidationEmailRequest(email: state.email)
                return .run { [valid = state.isEmailValid] send in
                    do {
                        guard valid else {
                            return await send(.emailInvalidResponse)
                        }
                        try await userClient.checkEmailValid(request)
                        await send(.emailCheckResponse(.success(())))
                    } catch let error as ErrorResponse {
                        await send(.emailCheckResponse(.failure(error)))
                    } catch {
                        throw error
                    }
                }
            case let .formatPhoneNumber(phone):
                state.phone = formatPhoneNumber(phone)
                return .none
            case .emailCheckResponse(.success):
                state.toast = ToastState(toastMessage: "사용 가능한 이메일입니다.", isToastPresented: true)
                state.isEmailDuplicateValid = true
                return .none
            case let .emailCheckResponse(.failure(error)):
                switch error.errorCode {
                case "E11":
                    state.toast = ToastState(toastMessage: "이메일 형식이 올바르지 않습니다.", isToastPresented: true)
                case "E12":
                    state.toast = ToastState(toastMessage: "중복된 이메일입니다.", isToastPresented: true)
                default:
                    state.toast = ToastState(toastMessage: "이메일 확인 중 오류가 발생했습니다.", isToastPresented: true)
                }
                state.isEmailDuplicateValid = false
                return .none
            case .emailInvalidResponse:
                state.toast = ToastState(toastMessage: "이메일 형식이 올바르지 않습니다.", isToastPresented: true)
                return .none
            case let .signupResponse(.success(success)):
                print("**", success)
                // workspaceview로 이동 닉네임 저장?
                return .none
            case let .signupResponse(.failure(error)):
                switch error.errorCode {
                case "E11":
                    state.toast = ToastState(toastMessage: "이메일 형식이 올바르지 않습니다.", isToastPresented: true)
                case "E12":
                    state.toast = ToastState(toastMessage: "이미 가입된 회원입니다. 로그인을 진행해주세요.", isToastPresented: true)
                default:
                    state.toast = ToastState(toastMessage: "에러가 발생했어요. 잠시 후 다시 시도해주세요.", isToastPresented: true)
                }
                return .none
            }
        }
    }
}

extension SignUp {
    struct ToastState: Equatable {
        var toastMessage: String
        var isToastPresented: Bool
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
    
    func getInvalidFieldTitles(_ state: State) -> Set<String> {
        var invalidFieldTitles: Set<String> = [] // 초기화
        if !state.isEmailValid {
            invalidFieldTitles.insert("이메일")
        }
        if !state.isNicknameValid {
            invalidFieldTitles.insert("닉네임")
        }
        if !state.isPhoneValid {
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
