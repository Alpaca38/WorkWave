//
//  DMChattingView.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import SwiftUI
import ComposableArchitecture

struct DMChattingView: View {
    @Bindable var store: StoreOf<DMChatting>
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        content
            .task { store.send(.task) }
            .onChange(of: scenePhase) { oldValue, newValue in
                switch newValue {
                case .active:
                    store.send(.active)
                case .background:
                    store.send(.background)
                case .inactive:
                    break
                @unknown default:
                    break
                }
            }
    }
}

private extension DMChattingView {
    var content: some View {
        VStack {
            chattingListView()
            
            messageInputView()
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .customToolbar(
            title: store.dmRoom.user.nickname,
            leftItem: .init(icon: .chevronLeft, action: {
                store.send(.backButtonTapped)
            })
        )
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func chattingListView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(store.message) { message in
                        messageListView(message: message)
                    }
                }
                .padding(.horizontal, 20)
                .id(store.scrollViewID)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                proxy
                    .scrollTo(store.scrollViewID, anchor: .bottom)
            }
            .onChange(of: store.message.count, { _, _ in
                withAnimation {
                    proxy.scrollTo(store.scrollViewID, anchor: .bottom)
                }
            })
        }
    }
    
    @ViewBuilder
    func messageListView(message: Chatting) -> some View {
        if message.isMine {
            myMessageView(message: message)
                .padding(.top, 5)
        } else {
            othersMessageView(message: message)
                .padding(.top, 5)
        }
    }
    
    func myMessageView(message: Chatting) -> some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .bottom) {
                Spacer()
                
                let date = DateManager.shared.toDate(createdAt: message.date) ?? Date()
                let dateString = date.isToday
                ? date.toString(.todayChat)
                : date.toString(.pastChat)
                Text(dateString)
                    .applyFont(font: .caption)
                    .foregroundStyle(.secondaryText)
                
                VStack(alignment: .trailing) {
                    if let text = message.text, !text.isEmpty {
                        Text(text)
                            .applyFont(font: .bodyRegular)
                            .padding(9)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.brandGreen)
                            )
                    }
                    if !message.imageNames.isEmpty {
                        NavigationLink {
                            ImageDetailView(imageNames: message.imageNames)
                        } label: {
                            ChattingImageView(imageNames: message.imageNames)
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
    
    func othersMessageView(message: Chatting) -> some View {
        HStack(alignment: .top) {
            LoadedImage(urlString: message.profile ?? "",
                             size: 34)
            .asButton {
                store.send(.profileImageTapped(message.user))
            }
            
            VStack(alignment: .leading) {
                Text(message.name)
                    .applyFont(font: .caption)
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        if let text = message.text, !text.isEmpty {
                            Text(text)
                                .applyFont(font: .bodyRegular)
                                .padding(9)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.primaryBackground)
                                )
                        }
                        if !message.imageNames.isEmpty {
                            NavigationLink {
                                ImageDetailView(imageNames: message.imageNames)
                            } label: {
                                ChattingImageView(imageNames: message.imageNames)
                            }
                        }
                    }
                    
                    let date = DateManager.shared.toDate(createdAt: message.date) ?? Date()
                    let dateString = date.isToday
                    ? date.toString(.todayChat)
                    : date.toString(.pastChat)
                    Text(dateString)
                        .applyFont(font: .caption)
                        .foregroundStyle(.secondaryText)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    func dynamicHeigtTextField() -> some View {
        VStack {
            TextField("메세지를 입력하세요", text: $store.messageText, axis: .vertical)
                .lineLimit(1...5)
                .background(.clear)
                .applyFont(font: .bodyRegular)
        }
    }
    
    func messageInputView() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                // 이미지 선택 버튼
                CustomPhotoPicker(
                    selectedImages: $store.selectedImages,
                    maxSelectedCount: 5
                ) {
                    Image(.plus)
                        .resizable()
                        .frame(width: 22, height: 20)
                        .foregroundStyle(.secondaryText)
                }
                .disabled(store.selectedImages?.count == 5)
                
                VStack(alignment: .leading) {
                    // 메시지 입력 필드
                    dynamicHeigtTextField()
                    if let images = store.selectedImages, !images.isEmpty {
                        selectePhotoView(images: images)
                    }
                }
                // 전송버튼
                Image(systemName: "paperplane")
                    .font(.system(size: 20))
                    .foregroundStyle(store.messageButtonValid
                                     ? .brandGreen : .secondaryText)
                    .asButton {
                        store.send(.sendButtonTapped)
                    }
                    .disabled(!store.messageButtonValid)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.primaryBackground)
            )
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
    }
    
    func selectePhotoView(images: [UIImage]?) -> some View {
        LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 12, content: {
            if let images = store.selectedImages {
                ForEach(images, id: \.self) { image in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                            .background(
                                Circle().size(width: 20, height: 20)
                                    .foregroundStyle(.white)
                            )
                            .offset(x: 20, y: -20)
                            .asButton {
                                store.send(.imageDeleteButtonTapped(image))
                            }
                    }
                    
                }
            }
            
        })
        .frame(height: 55)
    }
}
