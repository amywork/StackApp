// Singleton DataCenter Object Class

import Foundation


final class GlobalState {
    
    static let shared = GlobalState()
 
    private init() {
    }
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    enum Constants: String {
        case Explore
        case userStackKey
    }
    
    var stacks: [Stack] {
        get {
            let list = UserDefaults.standard.value(forKey: GlobalState.Constants.userStackKey.rawValue) as? [Stack] ?? []
            return list
        }set {
            UserDefaults.standard.set(stacks, forKey: GlobalState.Constants.userStackKey.rawValue)
        }
    }
    
    // MARK: - data Property
    var explores: [Explore] = []
    var settingDataList: [SettingData] = []
    
    func addStack(_ data: Stack) {
        stacks.append(data)
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
            self.settingDataList.append(SettingData(with: settingDataDic))
        }
    }

}
