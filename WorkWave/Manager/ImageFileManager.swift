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
    
    func saveImage(fileName: String) async {
        guard let documentDirectory else { return }
        
        let fileURL = documentDirectory.appending(path: fileName)
        
        do {
            let image = try await DefaultNetworkManager.shared.requestImage(ImageRouter.fetchImage(path: fileName))
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            
            do {
                try data.write(to: fileURL)
                print("이미지 저장 성공")
            } catch {
                print("이미지 저장 실패")
            }
        } catch {
            print("이미지 통신 실패")
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appending(path: fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
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
