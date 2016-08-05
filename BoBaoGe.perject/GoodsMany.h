//
//  GoodsMany.h
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/8/1.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsMany : NSObject
@property(nonatomic,strong)NSString *zone_name;
@property(nonatomic,assign)int zone_id;
+(void)getGoodsManyData:(int)zoneId;
@end
