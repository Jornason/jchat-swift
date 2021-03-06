//
//  JChatConversationListCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc(JChatConversationListCell)
class JChatConversationListCell: UITableViewCell {

  var conversationAvatar:UIImageView!
  var title:UILabel!
  var lastMessage:UILabel!
  var timeLable:UILabel!
  var unReadCount:UILabel!
  var conversationID:String?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.conversationAvatar = UIImageView()
    self.conversationAvatar.layer.cornerRadius = 22.5
    self.conversationAvatar.layer.masksToBounds = true
    self.contentView.addSubview(self.conversationAvatar)
    self.conversationAvatar.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(5)
      make.bottom.equalTo(self.contentView).offset(-5)
      make.width.equalTo(45)
      make.height.equalTo(145)
      make.left.equalTo(self.contentView).offset(7)
    }

    self.timeLable = UILabel()
    self.contentView.addSubview(self.timeLable)
    self.timeLable.textAlignment = .right
    self.timeLable.textColor = UIColor.gray
    self.timeLable.font = UIFont.systemFont(ofSize: 13)
    self.timeLable.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(7)
      make.width.equalTo(100)
      make.height.equalTo(11)
      make.right.equalTo(self.contentView).offset(-6)
    }
    
    self.title = UILabel()
    self.contentView.addSubview(self.title)
    self.title.font = UIFont.systemFont(ofSize: 15)
    self.title.textColor = UIColor(netHex: 0x3f80dd)
    self.title.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(7)
      make.left.equalTo(self.conversationAvatar.snp.right).offset(10)
      make.height.equalTo(17)
      make.right.equalTo(self.timeLable.snp.left)
    }
    
    self.lastMessage = UILabel()
    self.contentView.addSubview(self.lastMessage)
    self.lastMessage.textColor = UIColor(netHex: 0x808080)
    self.lastMessage.font = UIFont.systemFont(ofSize: 13)
    self.lastMessage.snp.makeConstraints { (make) -> Void in
      make.height.equalTo(21)
      make.bottom.equalTo(self.contentView).offset(-5)
      make.top.equalTo(self.title.snp.bottom).offset(3)
      make.left.equalTo(self.conversationAvatar.snp.right).offset(10)
    }
    
    self.unReadCount = UILabel()
    self.contentView.addSubview(unReadCount)
    self.unReadCount.textColor = UIColor.white
    self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    self.unReadCount.layer.borderWidth = 1
    self.unReadCount.layer.borderColor = UIColor.white.cgColor
    self.unReadCount.layer.cornerRadius = 11
    self.unReadCount.layer.masksToBounds = true
    self.unReadCount.textAlignment = .center
    self.unReadCount.font = UIFont.systemFont(ofSize: 11)
    self.unReadCount.snp.makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 22, height: 22))
      make.right.equalTo(self.conversationAvatar).offset(3)
      make.top.equalTo(self.conversationAvatar).offset(-3)
    }
  }
  
  func setCellData(_ conversation:JMSGConversation) {
    self.conversationID = self.conversationIdWithConversation(conversation)
    self.title.text = conversation.title

    conversation.avatarData { (data, ObjectId, error) -> Void in
      if error == nil {
        if data != nil {
          self.conversationAvatar.image = UIImage(data: data!)
        } else {
          switch conversation.conversationType {
          case .single:
            self.conversationAvatar.image = UIImage(named: "headDefalt")
            break
          case .group:
            self.conversationAvatar.image = UIImage(named: "talking_icon_group")
            break
          }
        }
      } else { print("get avatar fail") }
    }

    if conversation.unreadCount?.intValue > 0 {
      self.unReadCount.isHidden = false
      self.unReadCount.text = "\(conversation.unreadCount!)"
    } else {
      self.unReadCount.isHidden = true
    }

    if conversation.latestMessage?.timestamp != nil {
      var time = conversation.latestMessage?.timestamp.doubleValue
      
      if time > 1999999999 {
        time! /= 1000
      }
      
      self.timeLable.text = NSString.getFriendlyDateString(time!, forConversation: true)
    } else {
      self.timeLable.text = ""
    }

    self.lastMessage.text = conversation.latestMessageContentText()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func conversationIdWithConversation(_ conversation: JMSGConversation) -> String {
    var conversationid = ""
    switch conversation.conversationType {
    case .single:
      let user = conversation.target as! JMSGUser
      conversationid = "\(user.username)_\(conversation.conversationType)"
      break
    case .group:
      let group = conversation.target as! JMSGGroup
      conversationid = "\(group.gid)_\(conversation.conversationType)"
      break
    }
    return conversationid
  }

  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    }
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)

    if highlighted {
      self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    }
  }

}
