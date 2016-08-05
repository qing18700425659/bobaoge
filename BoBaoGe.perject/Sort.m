//
//  Sort.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/7/30.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "Sort.h"
@implementation Sort
+(void)setDataForSortChoice {
    [[self alloc]setDataForSortChoice ];
}
-(void)setDataForSortChoice {
    AFHTTPSessionManager * manger=[AFHTTPSessionManager manager];
    NSString *url=http_getSortSourch;
    NSMutableSet *set=[NSMutableSet setWithSet:manger.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
        manger.responseSerializer.acceptableContentTypes=set;
//    NSDictionary *dict=@{@"msg_type_id":@(sortId)};
    [manger POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@1]) {
            NSArray *array_data=responseObject[@"message"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"获取分类列表数据" object:array_data];
            NSLog(@"数据模型请求到的数据信息为%@",responseObject[@"message"]);
            
        }else{
           
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"分类列表数据请求错误%@",error);
    }];
}
@end
