//
//  SendMessageSpm.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/8/2.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "SendMessageSpm.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
@implementation SendMessageSpm

#pragma mark获取发布信息数据
-(void)getSendMessageType:(NSNumber *)type andZone_id:(NSString *)zone_id andcContent:(NSString *)content andCity:(NSString *)adss{
//增加设备唯一标示符
    NSDictionary *dict;
    NSString *imei=@"bobaoge";
    dict=@{
           @"imei":imei,
           @"zone_id":zone_id,
           @"type":type,
           @"user_id":@"大东",
           @"content":content,
           @"phone":@"18700425659",
           @"ads":adss
           
           };
    //请求地址
   NSString *url=@"http://172.16.3.237/broadcast/?action=message&func=issueMessage";
    NSString *parmars=[self urlWithDict:dict];
    
    //追加签名
    NSString *send_token=[self getSend_tokenWithParams:parmars url:url];
    
    NSMutableDictionary *mudict=[NSMutableDictionary dictionaryWithDictionary:dict];
    
    [mudict addEntriesFromDictionary:@{@"spm":self.getSPM,@"bobao_token":send_token}];
    NSLog(@"%@&%@&spm=%@&bobao_token=%@",url,parmars,[mudict valueForKey:@"spm"],[mudict valueForKey:@"bobao_token"]);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableSet *set=[NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes=set;
        [manager GET:url parameters:mudict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToNumber:@1]) {
            NSArray *array=responseObject[@"message"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"获取发布信息" object:array];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息%@",error.localizedDescription);
    }];
    }
-(NSString *)urlWithDict:(NSDictionary *)dict{
//公共方法,将字典转化成连接式
    //取值
    NSArray *keys=[dict allKeys];
    //去掉最后一个&符号
    NSMutableString *string=[NSMutableString string];
    //用循环
    for (NSString *str in keys) {
        if ([str isEqualToString:[keys firstObject]]) {
            [string appendFormat:@"%@=%@",str,[dict valueForKey:str]];
        }else{
            [string appendFormat:@"&%@=%@",str,[dict valueForKey:str]];
        }
    }
    return string;
}
//加密第一部分spm
-(NSString *)getSPM{
//手机型号.版本号.用户id.整点时间戳.是否校验用户真实姓名iPhone4S.1.7.0.1462946400.0
//   时间戳
    NSTimeInterval interval=[[NSDate date]timeIntervalSince1970];
    NSString *time=[NSString stringWithFormat:@"%d",(int)interval/3600 *3600];
    NSDictionary *infonDict=[[NSBundle mainBundle]infoDictionary];
    NSString *app_version=[infonDict objectForKey:@"CFBundleShortVersionString"];
//    组合spm
    NSMutableString *spm=[NSMutableString string];
    //A.iOS source_id
    NSString *source_id = @"iPhone";
    [spm appendFormat:@"%@.",source_id];//iPhone5S.
    
    //B.版本号
    //    NSString *app_BundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    [spm appendFormat:@"%@",app_version];//iPhone5S.1.7
    
    //C.用户id
    [spm appendFormat:@".%@",[self getUserID]];//iPhone5S.1.7.0
    //D.时间戳
    [spm appendFormat:@".%@",time];//iPhone5S.1.7.0.1462946400
    //E.1为检测用户 0不
    [spm appendString:@".0"];//iPhone5S.1.7.0.1462946400.0
    return spm;
}


-(NSString *)getSend_tokenWithParams:(NSString *)params  url:(NSString *)url{
//时间戳  整点
    NSTimeInterval interval=[[NSDate date]timeIntervalSince1970];
    NSString *time=[NSString stringWithFormat:@"%d",(int)interval/3600 *3600];
    NSString *source_id=@"iPhone";
//    加密第二部分
//    产品签名bobao_token
    NSString *sendKey=@"bobaogeHongHe3V1drzrT1";
//    参数为空
    if ([params isEqualToString:@""]) {
        url=[NSString stringWithFormat:@"%@&%@&sourceID=%@time=%@&token_key=%@",url,params,source_id,time,sendKey];
    }else{
    url=[NSString stringWithFormat:@"%@&%@&sourceID=%@time=%@&token_key=%@",url,params,source_id,time,sendKey];
    }
    //排序
    NSArray *subURL=[url componentsSeparatedByString:[NSString stringWithFormat:@"%@/?",@"http://172.16.3.237/broadcast"]];
    NSArray *subValue=[subURL[1]componentsSeparatedByString:@"&"];
    subValue=[subValue sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
//    根据排序结果获取value
    NSMutableArray *valueArray=[NSMutableArray array];
    for (int i=0; i<[subValue count]; i++) {
        NSString *value=[subValue[i]componentsSeparatedByString:@"="][1];
        [valueArray addObject:value];
    }
//    拼接send_token
    NSMutableString *send_token=[NSMutableString string ];
    for (int i=0; i<[valueArray count]; i++) {
        [send_token appendString:[NSString stringWithFormat:@"%@",valueArray[i]]];
    }
    return [SendMessageSpm md5:send_token];
}
-(NSString *)getUserID{
    NSUserDefaults *defult=[NSUserDefaults standardUserDefaults];
    NSDictionary *user=[defult objectForKey:@"userInfo"];
    if (user==nil) {
        return @"0";
    }
    return [user valueForKey:@"user_id"];
}
+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *tempstr= [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return [tempstr lowercaseString];
}

@end
