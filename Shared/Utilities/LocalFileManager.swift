//
//  LocalFileManager.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 10.04.2022.
//

// Создаём функционал сохранения с последующим использованием некоторой даты на устройстве (в данном случае картинок)

import Foundation
import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    init() {  }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // Create folder
        createFolderIfNeeded(folderName: folderName)
        
        // Get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // Save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Saving image error \(imageName). \(error)")
        }
    }
    
    public func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLFolder(folderName: folderName) else { return }
        
        // Если папки не существует мы её создадим в "do"
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory \(folderName). \(error)")
            }
        }
    }
    
    private func getURLFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
