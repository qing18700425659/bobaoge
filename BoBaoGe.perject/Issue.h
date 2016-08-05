//
//  Issue.h
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/7/30.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Issue : UIViewController
- (IBAction)shortPutOut:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)clearKey:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *findgoods;
@property (weak, nonatomic) IBOutlet UIButton *shangquan;
- (IBAction)findGoods:(id)sender;
- (IBAction)shangquan:(id)sender;
- (IBAction)photoImage:(id)sender;
- (IBAction)back:(id)sender;
@property(nonatomic,strong)NSMutableArray *photo_array;
@property(nonatomic,strong)NSMutableArray *image_photo;

- (IBAction)sendBut:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectview;
@end
