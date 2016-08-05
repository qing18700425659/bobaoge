//
//  jumpViewController.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/8/1.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "jumpViewController.h"
@interface jumpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation jumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, 50)];
    _tab.dataSource=self;
    _tab.delegate=self;
    [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tab];
   

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSUserDefaults *defult=[NSUserDefaults standardUserDefaults];
    cell.textLabel.text=[defult valueForKey:@"行数"];
    self.tab.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText=@"加载中";
    }];
    [self.tab.mj_header endRefreshing];
    return cell;
}



@end
