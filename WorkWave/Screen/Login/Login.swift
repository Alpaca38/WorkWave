//
//  Login.swift
//  WorkWave
//
//  Created by 조규연 on 11/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Login {
    @ObservableState
    struct State: Equatable {
        var email = ""
        var password = ""
        var toast: ToastState = ToastState(toastMessage: "")
        
        var isEmailValid = false
        var isPasswordValid = false
        var loginButtonValid = false
        
        var invalidFieldTitles: Set<String> = []
        var focusedField: Field?
        
        enum Field: Hashable {
            case email, password
        }
        
        var isWorkInitSheetPresented = false
        var optionalWorkInit: WorkspaceInitial.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitButtonTapped
        case loginButtonTapped
        case loginResponse(Result<SignupDTO, ErrorResponse>)
        
        case setSheet(isPresented: Bool)
        case optionalWorkInit(WorkspaceInitial.Action)
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.jwtKeyChain) var jwtKeyChain
    @Dependency(\.deviceKeyChain) var deviceTokenKeyChain
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                state.loginButtonValid = !state.email.isEmpty &&  !state.password.isEmpty
                return .none
            case .exitButtonTapped:
                return .none
            case .loginButtonTapped:
                state.isEmailValid = isValidEmail(state.email)
                state.isPasswordValid = isValidPassword(state.password)
                
                state.invalidFieldTitles = getInvalidFieldTitles(state)
                
                if !state.isEmailValid {
                    state.focusedField = .email
                    state.toast = ToastState(toastMessage: "이메일 형식이 올바르지 않습니다.", isToastPresented: true)
                    return .none
                } else if !state.isPasswordValid {
                    state.focusedField = .password
                    state.toast = ToastState(toastMessage: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.", isToastPresented: true)
                    return .none
                } else {
                    let request = LoginRequest(email: state.email, password: state.password, deviceToken: deviceTokenKeyChain.deviceToken ?? "")
                    return .run { send in
                        do {
                            await send(.loginResponse(.success(try await userClient.login(request))))
                        } catch let error as ErrorResponse {
                            await send(.loginResponse(.failure(error)))
                        } catch {
                            print(error)
                        }
                    }
                }
            case let .loginResponse(.success(success)):
                return .run { send in
                    UserDefaultsManager.user = User(userID: success.userID, nickname: success.nickname, email: success.email, phoneNumber: success.phone)
                    jwtKeyChain.handleLoginSuccess(accessToken: success.token.accessToken, refreshToken: success.token.refreshToken)
                    await send(.setSheet(isPresented: true))
                }
            case let .loginResponse(.failure(error)):
                switch error.errorCode {
                case "E03":
                    state.toast = ToastState(toastMessage: "이메일 또는 비밀번호가 올바르지 않습니다.", isToastPresented: true)
                default:
                    state.toast = ToastState(toastMessage: "에러가 발생했어요. 잠시 후 다시 시도해주세요.", isToastPresented: true)
                }
                return .none
            case .setSheet(isPresented: true):
                state.isWorkInitSheetPresented = true
                state.optionalWorkInit = WorkspaceInitial.State()
                return .none
            case .setSheet(isPresented: false):
                state.isWorkInitSheetPresented = false
                state.optionalWorkInit = nil
                return .none
            case .optionalWorkInit:
                return .none
            }
        }
        .ifLet(\.optionalWorkInit, action: \.optionalWorkInit) {
            WorkspaceInitial()
        }
    }
}

private extension Login {
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && (email.contains(".com") || email.contains(".net") || email.contains(".co.kr") )
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // 8자 이상, 하나 이상의 대문자, 소문자, 숫자, 특수문자
        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"#
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
    
    func getInvalidFieldTitles(_ state: State) -> Set<String> {
        var invalidFieldTitles: Set<String> = [] // 초기화
        if !state.isEmailValid {
            invalidFieldTitles.insert("이메일")
        }
        if !state.isPasswordValid {
            invalidFieldTitles.insert("비밀번호")
        }
        return invalidFieldTitles
    }
}
