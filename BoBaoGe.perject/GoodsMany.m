//
//  GoodsMany.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/8/1.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "GoodsMany.h"
#import "AFNetworking.h"


@implementation GoodsMany
+(void)getGoodsManyData:(int)zoneId{
    [[self alloc]getGoodsManyData:zoneId];
}
-(void)getGoodsManyData:(int)zoneId{
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    NSString *url=http_getGoodsMany;
    NSMutableSet *set=[NSMutableSet setWithSet:manger.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manger.responseSerializer.acceptableContentTypes=set;
    [manger POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToNumber:@1]) {
            NSArray *array_data=responseObject[@"message"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"获取商圈列表" object:[GoodsMany mj_objectArrayWithKeyValuesArray :array_data]];
            NSLog(@"商圈模块的数据%@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      NSLog(@"&&&&&123%@",error);
       
    }];
}
@end
