//
//  FormEntry.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

protocol FormEntry {
    var cell: UITableViewCell { get }
}

protocol MultipleLineText: FormEntry {
    var maximumCount: Int { get }
    var placeholder: String? { get }
    var onUpdate: Delegate<String, Void> { get }
}

class RoomNameText: MultipleLineText {
        
    let maximumCount = 50
    let placeholder: String? = "Hello"
    let onUpdate = Delegate<String, Void>()

    lazy var cell = render()
    
    func render() -> UITableViewCell {
        return OpenChatRoomNameTableViewCell(style: .default, reuseIdentifier: nil)
    }
}

class RoomDescriptionText: MultipleLineText {
    
    let maximumCount = 200
    let placeholder: String? = "Hello"
    let onUpdate = Delegate<String, Void>()
    
    lazy var cell = render()
    
    func render() -> UITableViewCell {
        let c = UITableViewCell(style: .default, reuseIdentifier: nil)
        c.contentView.backgroundColor = .yellow
        return c
    }
}

class Option<T: CustomStringConvertible>: FormEntry {
    let selectedOption: T
    let options: [T]
    let title: String?

    let onValueChange = Delegate<T, Void>()
    let onSelected = Delegate<T, Void>()
    
    lazy var cell = render()
    
    init(title: String?, options: [T]) {
        self.title = title
        self.options = options
        guard !options.isEmpty else {
            Log.fatalError("No selectable options provided. Check your data source.")
        }
        self.selectedOption = options[0]
    }
    
    func render() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.font = .systemFont(ofSize: 15.0)
        cell.textLabel?.textColor = .LineSDKLabel
        cell.textLabel?.text = title
        cell.detailTextLabel?.font = .systemFont(ofSize: 15.0)
        cell.detailTextLabel?.textColor = .LineSDKSecondaryLabel
        cell.detailTextLabel?.text = selectedOption.description
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

class Toggle: FormEntry {
    
    let title: String?
    let initialValue: Bool
    
    let onValueChange = Delegate<Bool, Void>()
    
    lazy var cell = render()
    
    init(title: String?, initialValue: Bool = false) {
        self.title = title
        self.initialValue = initialValue
    }
    
    private func render() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15.0)
        cell.textLabel?.textColor = .LineSDKLabel
        cell.textLabel?.text = title
        cell.accessoryView = searchOptionSwitch
        return cell
    }
    
    private lazy var searchOptionSwitch: UISwitch = {
        let searchSwitch = UISwitch()
        searchSwitch.isOn = initialValue
        searchSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return searchSwitch
    }()
    
    @objc
    private func switchValueDidChange(_ sender: UISwitch) {
        onValueChange.call(sender.isOn)
    }
}