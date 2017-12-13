
import UIKit

class CustomTextField: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth = self.bounds.size.height / 3
        let resultRect = CGRect(x: 10, y: self.bounds.height/2-leftViewWidth/2, width: leftViewWidth, height: leftViewWidth)
        return resultRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let edgeInsetRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 10, 0, 0))
        // 컨텐트 안쪽으로 들어가는 패딩값 (+는 패딩값 up / -는 마진값 up)
        return edgeInsetRect
    }
    
    /*
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(
            self.bounds,
            UIEdgeInsetsMake(0, self.bounds.size.height/2+10, 0, 0))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let edgeInsetRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, self.bounds.size.height/2+10, 0, 0))
        return edgeInsetRect
    }
    */

    func configureAttributedString(
        string: String,
        range: NSRange,
        stringColor: UIColor
    ){
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(
            NSAttributedStringKey.foregroundColor,
            value: stringColor,
            range: range)
        // NSMutableAttributedString는 class이기 때문에 let으로 선언했으나 내부 속성 바꿔도 OK
        self.attributedPlaceholder = attributedString
    }
    
}
