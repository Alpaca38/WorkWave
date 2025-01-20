//
//  FileManager.swift
//  WorkWave
//
//  Created by 조규연 on 1/17/25.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() { }
    
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func createDirectory() {
        guard let documentDirectory else { return }
        let staticDirectory = documentDirectory.appending(path: "static")
        let dmChatsDirectory = staticDirectory.appending(path: "dmChats")
        let profilesDirectory = staticDirectory.appending(path: "profiles")
        let coverImageDirectory = staticDirectory.appending(path: "workspaceCoverImages")
        
        createDirectory(dmChatsDirectory)
        createDirectory(profilesDirectory)
        createDirectory(coverImageDirectory)
    }
    
    func saveImage(fileName: String, imageData: Data? = nil) async {
        guard let documentDirectory else { return }
        
        let fileURL = documentDirectory.appending(path: fileName.dropFirst())
        
        // 해당 경로에 저장된 이미지가 없으면
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let image = try await DefaultNetworkManager.shared.requestImage(ImageRouter.fetchImage(path: fileName))
                guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                
                do {
                    try imageData != nil ? imageData?.write(to: fileURL) : data.write(to: fileURL)
                    print("이미지 저장 성공")
                } catch {
                    print("이미지 저장 실패", error)
                }
            } catch {
                print("이미지 통신 실패")
            }
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appending(path: fileName.dropFirst())
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("로컬 이미지 불러오기 성공")
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("해당 경로에 이미지가 존재하지 않습니다.")
            return nil
        }
    }
    
    func deleteImage(fileName: String) {
        guard let documentDirectory else { return }
        
        let fileURL = documentDirectory.appending(path: fileName.dropFirst())
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("이미지 삭제 성공")
            } catch {
                print("이미지 삭제 실패", error)
            }
        } else {
            print("해당 경로에 이미지 없음")
        }
    }
    
    func removeAll() {
        guard let documentDirectory else { return }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            print("이미지 삭제 성공")
        } catch {
            print("이미지 삭제 실패")
        }
    }
}

private extension ImageFileManager {
    func createDirectory(_ directory: URL) {
        if FileManager.default.fileExists(atPath: directory.path) {
            print("\(directory) 폴더가 이미 존재합니다.")
        } else {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                print("\(directory) 폴더 생성")
            } catch {
                print("\(directory) 폴더 생성 실패", error)
            }
        }
    }
}
