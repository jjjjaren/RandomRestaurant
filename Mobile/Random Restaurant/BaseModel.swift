//
//  BaseModel.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/7/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

enum UIBaseItemInputType {
    case ReadOnly
    case Text
    case Number
    case Date
}

enum UIBaseItemStyle {
    case Default
}

class UIBaseItem {
    let identifier: String
    let title: String
    let inputType: UIBaseItemInputType
    let style: UIBaseItemStyle
    var enabled: Bool
    var onChange: ((UIBaseItem) -> Void)?
    var value: String {
        didSet {
            onChange?(self)
        }
    }
    init(identifier: String, title: String, value: String = "", inputType: UIBaseItemInputType = .ReadOnly, style: UIBaseItemStyle = .Default, enabled: Bool = true, onChange: ((UIBaseItem) -> Void)? = nil ) {
        self.identifier = identifier
        self.title = title
        self.inputType = inputType
        self.style = style
        self.enabled = enabled
        self.value = value
        self.onChange = onChange
    }
}

class UIBaseSection {
    let title: String
    let footer: String
    var items: [UIBaseItem]
    init(title: String? = nil, footer: String? = nil, items: [UIBaseItem] = [UIBaseItem]()) {
        self.title = title ?? ""
        self.footer = footer ?? ""
        self.items = items
    }
}