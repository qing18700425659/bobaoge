//
//  Sort.h
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/7/30.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sort : NSObject

@property(nonatomic,strong)NSString *msg_type_name;//消息类型名称
@property(nonatomic,strong)NSString *msg_sub_menu;//子消息类型集合
@property(nonatomic,strong)NSString *msg_type_id;//消息类型id
@property(nonatomic,strong)NSString *msg_type_state;//消息类型状态
@property(nonatomic,strong)NSString *msg_parent_cid;//父类id
+(void)setDataForSortChoice;
@end
