//
//  ViewController.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/7/30.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int type_id;
    int father_id;
   
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *repciteData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    self.view.backgroundColor=[UIColor whiteColor];
//    通知请求分类数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"获取分类列表数据" object:nil];
//    注册tableview
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    设置tableview行高
    self.tableview.rowHeight=50;
//    类调用类方法
    [Sort setDataForSortChoice ];
}
-(void)setNavigation{
    //导航栏颜色设置
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    //导航栏标题
    UILabel *title = [[UILabel alloc] initWithFrame:self.view.bounds];
    //标题颜色
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    //标题位置
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"分类选项";
    title.font=[UIFont systemFontOfSize:21];
    self.navigationItem.titleView = title;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.repciteData.count;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.repciteData[section][@"msg_sub_menu"]count]==0) {
        return 1;
    }
    return [self.repciteData[section][@"msg_sub_menu"]count];
}
//绘制cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    Sort *data_sort=self.repciteData[indexPath.row];
    if ([self.repciteData[indexPath.section][@"msg_sub_menu"]count]==0) {
        cell.textLabel.text=self.repciteData[indexPath.section][@"msg_type_name"];
    }else{
        cell.textLabel.text=self.repciteData[indexPath.section][@"msg_sub_menu"][indexPath.row][@"msg_type_name"];
    }
    
    cell.layer.borderColor=[[UIColor grayColor]CGColor];
    cell.layer.borderWidth=0.5;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    return cell;
 
    
}

//设置标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return self.repciteData[section][@"msg_type_name"];
}
//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
//点击每一行跳转页面传id值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     jumpViewController *jump=[self.storyboard instantiateViewControllerWithIdentifier:@"jumpViewController"];
     NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
     [def setObject:[NSString stringWithFormat:@"分类选项的id为%i",[self.repciteData[indexPath.section][@"msg_type_id"]intValue] ] forKey:@"行数"];
     [self.navigationController pushViewController:jump animated:YES];

}
//通知的回调方法
-(void)getData:(NSNotification *)noti{
    self.repciteData=[NSMutableArray array];
    [self.repciteData addObjectsFromArray:noti.object];
    [self.tableview reloadData];
    }
- (IBAction)back:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jumpViewController *jump=[story instantiateViewControllerWithIdentifier:@"jumpViewController"];
    [self.navigationController pushViewController:jump animated:YES];
}
//懒加载
-(NSMutableArray *)repciteData{
    if (_repciteData) {
        return _repciteData;
    }else{
        return  _repciteData=[NSMutableArray array];
    }
}
//移除观察者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"获取分类列表数据" object:nil];
}

@end
