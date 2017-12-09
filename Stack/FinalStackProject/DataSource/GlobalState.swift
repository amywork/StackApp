// Singleton DataCenter Object Class

import Foundation
import UIKit

final class GlobalState {
    
    static let shared = GlobalState()
    private init() { }
    
    enum Constants: String {
        case Explore
        case Users
        case userStackKey
    }
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var uuid: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    // MARK: - data Property
    var explores: [Explore] = []
    var settings: [Setting] = []
    var stacks: [Stack] = []
    
    // MARK: - load data method
    func loadSettingData() {
        let settingDataURL = documentDirectory.appendingPathComponent("Settings.plist")
        let settingDataPath = settingDataURL.path
        print(settingDataPath)
        
        if !FileManager.default.fileExists(atPath: settingDataPath) {
            guard let plistURL = Bundle.main.url(forResource: "Settings", withExtension: "plist") else { return }
            try! FileManager.default.copyItem(at: plistURL, to: settingDataURL)
        }
        
        guard let settingDataArr = NSArray(contentsOf: settingDataURL) as? [[String:Any]] else { return }
        for settingDataDic in settingDataArr {
            self.settings.append(Setting(with: settingDataDic))
        }
    }

}
