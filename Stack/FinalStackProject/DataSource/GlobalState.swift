// Singleton DataCenter Object Class

import Foundation
import UIKit

final class GlobalState {
    
    static let shared = GlobalState()
    private init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentPath)
    }
    
    enum Constants: String {
        case Explore
        case Users
        case Stacks
    }
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - data Property
    var explores: [Explore] = []
    var settings: [Setting] = []
    
    var stakcs: [Stack] {
        let stackDics: [[String:String]] = UserDefaults.standard.array(forKey: Constants.Stacks.rawValue) as? [[String:String]] ?? []
        let stacks = stackDics.flatMap { (stackDic) -> Stack? in
            return Stack(with: stackDic)
        }
        return stacks
    }
    
    func addStack(stack: Stack){
        let dic: [String:String] = stack.dictionary
        var stackDics: [[String:String]] = UserDefaults.standard.array(forKey: Constants.Stacks.rawValue) as? [[String:String]] ?? []
        stackDics.append(dic)
        UserDefaults.standard.set(stackDics, forKey: Constants.Stacks.rawValue)
    }

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
