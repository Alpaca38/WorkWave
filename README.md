# WorkWave

## 프로젝트 소개
> 업무, 스터디 등 모임을 생성하고 실시간으로 채팅할 수 있는 앱

### 화면
| 회원가입 및 로그인 | 워크스페이스 홈 | 워크스페이스 선택 | DM 목록 | DM 화면 |
| --- | --- | --- | --- | --- |
| ![Simulator Screenshot - iPhone 15 Pro - 2025-01-25 at 16 47 49](https://github.com/user-attachments/assets/10a71f63-fcb0-46a5-adbe-4b11701fdab6) | ![Simulator Screenshot - iPhone 15 Pro - 2025-01-25 at 18 10 07](https://github.com/user-attachments/assets/997860a2-3fa9-42d7-8d4d-b9af3dda48e6) | ![Simulator Screenshot - iPhone 15 Pro - 2025-01-25 at 16 58 37](https://github.com/user-attachments/assets/b1bd7e5b-f1a3-447f-888b-bda77c684900) | ![Simulator Screenshot - iPhone 15 Pro - 2025-01-25 at 18 10 07](https://github.com/user-attachments/assets/ebd1a81d-1c14-4b2c-b306-ea1d2127616f) | ![Simulator Screenshot - iPhone 15 Pro - 2025-01-25 at 18 14 39](https://github.com/user-attachments/assets/398ea10c-a47e-4735-a143-305d295cd892)

### 최소 지원 버전
> iOS 17

### 개발 기간
> 2024.10.31 ~ 2024.01.23

### 개발 환경
- **IDE** : Xcode 15.4
- **Language** : Swift 5.10

### 핵심 기능
**1. 회원등록**

    - 회원가입
    - 이메일 및 소셜 로그인
    - 프로필 수정

**2. 워크스페이스 관리**

    - 워크스페이스 생성
    - 워크스페이스 변경
    - 워크스페이스 팀원 초대

**3. 실시간 채팅**

    - 읽지 않은 채팅 수 표시
    - 이미지 첨부 가능

### 사용 기술 및 라이브러리
- SwiftUI, TCA
- Swift Concurrency
- WebSocket
- PhotosUI
- Keychain
- Alamofire

### 주요 기술
#### TCA
<img alt="image" src="https://github.com/user-attachments/assets/5d853a22-02be-40cb-9023-f7ecacc9d0b1" />
  - State를 Reducer에서만 변경할 수 있도록 단방향 아키텍처로 구성
  - 상태 변화를 추적하기 쉽고 항상 예측이 가능한 형태로 구성됨
  - 상태 변화가 아닌 비동기 부수효과(ex. API 요청)는 Effect에서 관리
  - 각 요소들이 역할에 따라 분리되어 있어 확장 및 유지보수 용이

#### 실시간 채팅
- 트래픽을 줄이기 위해 과거 채팅내역 로컬 DB에 저장
- 채팅 화면 진입 시 DB에 저장된 마지막 채팅의 Date를 기준으로 채팅 내역 조회 API 요청
- 조회한 최신 채팅 데이터를 DB에 저장
- 소켓을 연결해 실시간 데이터 수신 및 DB 저장
- DB의 데이터로 뷰 업데이트

#### Socket
- 채팅 화면 진입 시 소켓 연결, 채팅화면 퇴장 시 소켓 연결 해제
- scenePhase를 사용해 background 진입 시 소켓 연결 해제,
active 상태 시 재연결
- AsyncStream<Element>.Continuation을 사용해 채팅 Data 전달
- Result 타입을 활용해 에러 핸들링

#### Dependency
- 네트워크 요청 로직을 DependencyKey를 채택하는 Client로 구성
- @Dependency 를 사용해 의존성을 주입하여 Reducer와의 결합도 낮춤
- Mocking을 활용해 테스트 용이성 증가

#### 토큰 갱신
- 토큰 갱신 성공 시 재귀함수를 통해 기존 요청 재호출
- JSON 형식의 Error 응답을 Decoding 하여 핸들링
- @AppStorage를 사용해 토큰 갱신 실패 시 온보딩 뷰로 전환

#### 이미지 캐싱
- FileManager로 디스크 캐싱
- API 통신 시 저장

#### 채팅 UI
- ScrollViewReader를 사용해 채팅 뷰 진입 및 채팅 갱신 시 뷰를 맨 아래로
이동
- 라인 수에 따라 늘어나는 Dynamic TextField 구현

#### DTO
- API Response Model -> DB Model -> Present Model
- 뷰에 사용할 Present Model을 구성해 네트워크 계층과의 결합도 낮춤

#### KeyChain
- AccessToken 및 RefreshToken을 UserDefaults가 아닌 Keychain 으로 저장해 보안성 높힘
