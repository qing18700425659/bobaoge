//
//  GoodsManyViewController.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/8/1.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "GoodsManyViewController.h"
@interface GoodsManyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
int zoneID;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *data_shangquan;
@end

@implementation GoodsManyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    //通知中心添加观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"获取商圈列表" object:nil];
    //类调用类方法
    [GoodsMany getGoodsManyData:zoneID];
    
}
-(void)setNavigation{
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    UILabel *title = [[UILabel alloc] initWithFrame:self.view.bounds];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"商圈";
    title.font=[UIFont systemFontOfSize:21];
    self.navigationItem.titleView = title;
}
-(void)getData:(NSNotification *)noti{
    self.data_shangquan=[NSMutableArray array];
    //给数组里添加通知传过来的值
    [self.data_shangquan addObjectsFromArray:noti.object];
    //在通知回调的时候实例化tableview
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,50*4)];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.rowHeight=50;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_shangquan.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    GoodsMany *data=self.data_shangquan[indexPath.row];
    cell.textLabel.text=data.zone_name;
    zoneID=data.zone_id;
    NSLog(@"%d......",zoneID);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell的点击样式
    cell.layer.borderColor=[[UIColor lightGrayColor]CGColor];//设置cell的边框颜色
    cell.layer.borderWidth=0.5;//设置cell的边框宽度
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    jumpViewController *jump=[self.storyboard instantiateViewControllerWithIdentifier:@"jumpViewController"];
    GoodsMany *data_goods=self.data_shangquan[indexPath.row];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"商圈每一行的id为%@",[data_goods valueForKey:@"zone_id"]] forKey:@"行数"];
    [self.navigationController pushViewController:jump animated:YES];
   
    
    }
//懒加载
-(NSMutableArray *)data_shangquan{
    if (_data_shangquan) {
        return _data_shangquan;
    }else{
       return _data_shangquan=[NSMutableArray array];
    }
}
//移除观察者和移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"获取商圈列表" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jumpViewController *jump=[story instantiateViewControllerWithIdentifier:@"jumpViewController"];
    [self.navigationController pushViewController:jump animated:YES];
 
}
@end
