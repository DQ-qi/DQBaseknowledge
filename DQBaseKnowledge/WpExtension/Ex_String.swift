//
//  Ex_String.swift
//  xxxxx
//
//  Created by xxx on 2017/5/18.
//  Copyright © 2017年 xxx. All rights reserved.
//

import Foundation
// MARK: - String Extention
extension String {
    //获取本地语言文件的字符串
//    static func getInfoPlistStringFunction(key:String,_ tableName:String = KlanguageStringTableName)->String {
//        return NSLocalizedString(key, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
//    }
//    func draw(in rect: CGRect, withAttributes attrs: [NSAttributedStringKey : Any]? = nil){
//        let string = self as NSString
//        string.draw(in: rect, withAttributes: attrs)
//    }
//
//    func calculate(specificWidth width : CGFloat = MAXCGFLOAT,
//                   specificHeight height : CGFloat = MAXCGFLOAT) -> CGSize {
//
//        let string = self as NSString
//
//        let paragraphStryle = NSMutableParagraphStyle()
//        paragraphStryle.alignment = .center
//        paragraphStryle.lineBreakMode = .byWordWrapping
//
//        let attributes = [
//            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.0),
//            NSAttributedStringKey.paragraphStyle : paragraphStryle
//        ]
//
//
//        return string.boundingRect(with: CGSize(width:width,height:height),
//                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
//                                   attributes: attributes, context: nil).size
//    }
//
//
//
//    /**
//     *  To draw text Vertically alignmentCenter
//     *
//     */
//    func drawVertically(in rect : CGRect ,
//                        withFontSize size: CGFloat,
//                        color: UIColor = UIColor.black,
//                        andAlignment: NSTextAlignment = .center,
//                        font: UIFont? = nil){
//
//        let str = self as NSString
//        var defalutFont = UIFont.systemFont(ofSize: size)
//        if font != nil { defalutFont = font! }
//
//        var rect = rect
//        rect.origin.y += (rect.size.height - str.size(withAttributes: [NSAttributedStringKey.font : defalutFont]).height)/2.0
//
//        let style = NSMutableParagraphStyle()
//        style.alignment = andAlignment
//
//        str.draw(in: rect, withAttributes: [
//            NSAttributedStringKey.font : defalutFont,
//            NSAttributedStringKey.foregroundColor : color,
//            NSAttributedStringKey.paragraphStyle : style
//            ])
//
//    }
//
    /// String -> float
    var floatValue: Float {
        return (self as NSString).floatValue
        
    }
    var doubleValue: Double {
        return (self as NSString).doubleValue
        
    }
    /// String -> Int
    var intValue: Int{
        return (self as NSString).integerValue
    }
    ///  check String -> Int
//    var isPureInt: Bool{
//
//        return (self as NSString).mj_isPureInt()
//    }
    // "123456789" -> "6789" 提取银行卡的后四位号码
    func wp_extractBankCardNumber()->String {
        if self.count<=4 {
            return self
        }
        let index = self.index(self.endIndex, offsetBy: -4)
        let bankCardNumber = String(self.suffix(from: index))
        return bankCardNumber
    }
    
    //检查ip 是不是合法的ip
    func ipIsValidity(ip:String)->Bool {
        let isIP = "^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))(\\.([0-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))){3}$"
        do {
            let regular = try NSRegularExpression.init(pattern: isIP, options: [])
            let results = regular.matches(in: ip, options: [], range: NSRange.init(location: 0, length: ip.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
    //检查手机是不是合法的手机号码
    func numberIsPhoneNumber()->Bool {
        if self.count != 11 {
            return false
        }
        let isIP = "^(1[3-8][0-9])\\d{8}$"
        do {
            let regular = try NSRegularExpression.init(pattern: isIP, options: [])
            let results = regular.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
    
    func moneyStrIsLegal()->Bool {
        //金额的正则 (^[1-9](\\d+)?(\\.\\d{1,2})?$)|(^0$)|(^\\d\\.\\d{1,2}$)
        // (^[0-9].$) 可以是0. 9. 这样的格式
        let isRegular = "(^[1-9](\\d+)?(\\.\\d{1,2})?$)|(^0$)|(^\\d\\.\\d{1,2}$)"
        do {
            let regular = try NSRegularExpression.init(pattern:isRegular, options: [])
            let results = regular.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
    //0. 3. 3245. 这格式的验证
    func moneyNotLegal()->Bool {
        let isRegular = "(^[1-9](\\d+)?(\\.)?$)|(^0$)|(^\\d\\.$)"
        do {
            let regular = try NSRegularExpression.init(pattern:isRegular, options: [])
            let results = regular.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
    //检查银行卡号 只检测 16 到20 位的数字其他的不管
    func numberIsBankCard()->Bool {
        let isIP = "^([1-9])\\d{15,19}$"
        do {
            let regular = try NSRegularExpression.init(pattern: isIP, options: [])
            let results = regular.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
   
    func dq_baseRegularValidation(regular:String)->Bool {
        do {
            let regular = try NSRegularExpression.init(pattern: regular, options: [])
            let results = regular.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            return results.count > 0
        } catch let error {
            print(error)
            
        }
        return false
    }
    
    //字符串是不是一个链接
    func contentIslegal()->Bool {
        if let schUrl = URL.init(string: self) {
            if let schStr = schUrl.scheme?.lowercased() {
                if schStr == "ws" || schStr == "http" || schStr == "wss" || schStr == "https" {
                    return true
                } else {
                    let regular = "(^|[\\s.:;?\\-\\]<\\(])" +
                        "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
                        "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
                   return self.dq_baseRegularValidation(regular: regular)
                }
            }
        }
       return false
    }
    
   func phoneNumberSecurityShow()->String? {
        guard self.count == 11 else {
            return self
        }
        var newNumber = self
        newNumber.replaceSubrange(String.Index.init(encodedOffset: 3)...String.Index.init(encodedOffset: 6), with: repeatElement("*", count: 4))
        return newNumber
    }

    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
}
extension NSMutableAttributedString {
    /**
     *  To draw attributed Vertically alignmentCenter
     *
     */
//    func drawVertically(in rect : CGRect ,
//                        withFontSize size: CGFloat,
//                        color: UIColor = UIColor.black,
//                        andAlignment: NSTextAlignment = .center){
//        
//        let tempStr = self.string
//        let str = tempStr as NSString
//        let font = UIFont.systemFont(ofSize: size)
//        
//        var rect = rect
//        rect.origin.y += (rect.size.height - str.size(withAttributes: [NSAttributedStringKey.font : font]).height)/2.0
//        
//        let style = NSMutableParagraphStyle()
//        style.alignment = andAlignment
//        let attributes = [
//            NSAttributedStringKey.font : font,
//            NSAttributedStringKey.foregroundColor : color,
//            NSAttributedStringKey.paragraphStyle : style
//        ]
//        
//        self.addAttributes(attributes, range: NSRange(location:0, length: self.length - 1))
//        
//        
//        self.draw(in: rect)
//        
//    }
//    
//    
//    func drawVertically(in rect : CGRect ,
//                        frontNSRange: NSRange,
//                        endNSRange: NSRange,
//                        andAlignment: NSTextAlignment = .left){
//        
//        let tempStr = self.string
//        let str = tempStr as NSString
//        let font = UIFont.systemFont(ofSize: 14.0)
//        
//        var rect = rect
//        rect.origin.y += (rect.size.height - str.size(withAttributes: [NSAttributedStringKey.font : font]).height)/2.0
//        
//        let style = NSMutableParagraphStyle()
//        style.alignment = andAlignment
//        let attributes1 = [
//            NSAttributedStringKey.font : font,
//            NSAttributedStringKey.foregroundColor : UIColor(red:0.47, green:0.47, blue:0.47, alpha:1.00),
//            NSAttributedStringKey.paragraphStyle : style
//        ]
//        let attributes2 = [
//            NSAttributedStringKey.font : font,
//            NSAttributedStringKey.foregroundColor : UIColor(red:0.86, green:0.12, blue:0.15, alpha:1.00),
//            NSAttributedStringKey.paragraphStyle : style
//        ]
//        
//        self.addAttributes(attributes1, range: frontNSRange)
//        self.addAttributes(attributes2, range: endNSRange)
//        
//        self.draw(in: rect)
//        
//    }
}

//extension String {
//    var  timeStamp: String? {
//        return DQCommonFunctionTool.GetTimeFormatForm(timeStr: self )
//    }
//    var dq_timeStamp: String? {
//        let muStr:NSMutableString = NSMutableString.init()
//        let str = DQCommonFunctionTool.dq_GetTimeFormatForm(timeStr: self )
//        muStr.append(str)
//        muStr.append(":00")
//        return muStr as String
//    }
//}

