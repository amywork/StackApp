// Singleton DataCenter Object Class

import Foundation
import UIKit

final class GlobalState {
    
    static let shared = GlobalState()
    private init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        loadSettingData()
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
        get {
            let stackDics: [[String:String]] = UserDefaults.standard.array(forKey: Constants.Stacks.rawValue) as? [[String:String]] ?? []
            let stacks = stackDics.compactMap { (stackDic) -> Stack? in
                return Stack(with: stackDic)
            }
            return stacks
        }set {
            let newStacks = newValue
            var newDicArr: [[String:String]] = []
            newStacks.forEach { (stack) in
                return newDicArr.append(stack.dictionary)
            }
            UserDefaults.standard.set(newDicArr, forKey: Constants.Stacks.rawValue)
        }
    }
    
    func addStack(stack: Stack){
        let dic: [String:String] = stack.dictionary
        var stackDics: [[String:String]] = UserDefaults.standard.array(forKey: Constants.Stacks.rawValue) as? [[String:String]] ?? []
        stackDics.append(dic)
        UserDefaults.standard.set(stackDics, forKey: Constants.Stacks.rawValue)
    }
    
    // MARK: - load data method
    func loadSettingData() {
        let settingDataURL = documentDirectory.appendingPathComponent("Setting.plist")
        let settingDataPath = settingDataURL.path
        print(settingDataPath)
        
        if !FileManager.default.fileExists(atPath: settingDataPath) {
            guard let plistURL = Bundle.main.url(forResource: "Setting", withExtension: "plist") else { return }
            try! FileManager.default.copyItem(at: plistURL, to: settingDataURL)
        }
        
        guard let settingDataArr = NSArray(contentsOf: settingDataURL) as? [[String:Any]] else { return }
        for settingDataDic in settingDataArr {
            self.settings.append(Setting(with: settingDataDic))
        }
    }

}

