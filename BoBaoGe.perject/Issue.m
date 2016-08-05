//
//  Issue.m
//  BoBaoGe.perject
//
//  Created by DC-002 on 16/7/30.
//  Copyright © 2016年 DC-002. All rights reserved.
//

#import "Issue.h"

@interface Issue ()<CZPickerViewDataSource,CZPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
{
    NSArray *short_array;
    NSMutableArray *receiveData;
    NSMutableArray *find_goods,*shangquan_array;
    NSString *strImageEncod;
    UIImage *image_ui;
    int a;
    NSString *b;
    UICollectionViewCell *cell_s;
    
    CLLocationManager *locationManager;
    NSString *city;
    NSString *start_location;
    NSString *time_city;
}
@property(nonatomic,strong)UITableView *tableview_find;
@property(nonatomic,strong)UITableView *tableview_shangquan;
@end

@implementation Issue

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectview reloadData];
    [self setNavigation];
   b=@"1";
    short_array=@[@"要如图款式，有货请联系",@"招台针横机，有空请联系",@"招台针套机，有空请联系",@"招平车,有空请联系",@"招绣花，有空请联系",@"我有台针横机空闲，需要的请联系"];
    //发布消息页面数据请求
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSendMessage:) name:@"获取发布信息" object:nil];
    //获取商圈列表信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHongHe:) name:@"获取商圈列表" object:nil];
    [GoodsMany getGoodsManyData:a];
    //获取分类信息列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSortMessage:) name:@"获取分类列表数据" object:nil];
    [Sort setDataForSortChoice];
    
    
    
     [self getLocation];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//设置【导航栏】的颜色方法
-(void)setNavigation{
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    UILabel *title = [[UILabel alloc] initWithFrame:self.view.bounds];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"发布";
    title.font=[UIFont systemFontOfSize:21];
    self.navigationItem.titleView = title;
}
//【弹窗】快捷输入按钮
- (IBAction)shortPutOut:(id)sender {
    CZPickerView *pick=[[CZPickerView alloc]initWithHeaderTitle:@"快捷输入" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    pick.headerTitleFont = [UIFont systemFontOfSize: 30];
    pick.dataSource=self;
    pick.delegate=self;
    pick.needFooterView=NO;
    pick.headerBackgroundColor=[UIColor redColor];
    [pick show];
}
//【弹窗】拾取每一行
-(NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    return short_array[row];
}
//【弹窗】拾取物品数
-(NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return short_array.count;
}
//【弹窗】委托方法选中其中一个目标
-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    _textView.text=short_array[row];
}
//清除按钮
- (IBAction)clearKey:(id)sender {
    self.textView.text=nil;
}
//找货源按钮
- (IBAction)findGoods:(id)sender {
    if ([_tableview_shangquan isMemberOfClass:[UITableView class]]) {
        [_tableview_shangquan removeFromSuperview];
    }
    _tableview_find=[[UITableView alloc]initWithFrame:CGRectMake(50, 100, 150, 300)];
    _tableview_find.dataSource=self;
    _tableview_find.delegate=self;
    _tableview_find.tag=1;
    [_tableview_find registerClass:[UITableViewCell class] forCellReuseIdentifier:@"findcell"];
    [self.view addSubview:_tableview_find];
   }
//商圈按钮
- (IBAction)shangquan:(id)sender {
    if ([_tableview_find isMemberOfClass:[UITableView class]]) {
        [_tableview_find removeFromSuperview];
    }
    _tableview_shangquan=[[UITableView alloc]initWithFrame:CGRectMake(50, 150, 150, 180)];
    _tableview_shangquan.dataSource=self;
    _tableview_shangquan.delegate=self;
    _tableview_shangquan.tag=2;
    [_tableview_shangquan registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shangquancell"];
    [self.view addSubview:_tableview_shangquan];
   }


- (IBAction)back:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jumpViewController *jump=[story instantiateViewControllerWithIdentifier:@"jumpViewController"];
    [self.navigationController pushViewController:jump animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==2) {
        return shangquan_array.count;
    }else {
        return find_goods.count;
    }
}
//绘制cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView.tag==1) {
         cell=[tableView dequeueReusableCellWithIdentifier:@"findcell" forIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"findcell"];
        }
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"shangquancell" forIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shangquancell"];
        }
    }
    cell.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    if (tableView.tag==1) {
        Sort *data=find_goods[indexPath.row];
        cell.textLabel.text=[data valueForKey:@"msg_type_name"];
    }else if(tableView.tag==2){
        GoodsMany *data=shangquan_array[indexPath.row];
        cell.textLabel.text=[data valueForKey:@"zone_name"];
            }
    
    return cell;
}
//点击每一行改变button的标题
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [_findgoods setTitle:find_goods[indexPath.row][@"msg_type_name"] forState:UIControlStateNormal];
        
        tableView.hidden=YES;
    }else {
        [_shangquan setTitle:[shangquan_array[indexPath.row] valueForKey:@"zone_name"] forState:UIControlStateNormal];
        b=[shangquan_array[indexPath.row] valueForKey:@"zone_id"];
        tableView.hidden=YES;
    }
}
//发布【消息】页面通知
-(void)getSendMessage:(NSNotification *)noti{
    receiveData=[NSMutableArray array];
    [receiveData addObject:noti.object];
}
//获取【洪合】的数据列表的通知回调方法
-(void)getHongHe:(NSNotification *)noti_object{
    shangquan_array=[NSMutableArray array];
    [shangquan_array addObjectsFromArray:noti_object.object];
    NSLog(@"传过来的商圈列表值为%@",[shangquan_array valueForKey:@"zone_id"]);
}
//获取【分类】列表的数据通知回调方法
-(void)getSortMessage:(NSNotification *)noti_obj{
    find_goods=[NSMutableArray array];
    [find_goods addObjectsFromArray:noti_obj.object];
    NSLog(@"分类列表的数据%@",find_goods);
}
- (IBAction)photoImage:(id)sender {
    //实例化照片拾取器
    TZImagePickerController *image_Tz=[[TZImagePickerController alloc]initWithMaxImagesCount:0 delegate:self];
    //是否选择原图
    image_Tz.allowPickingOriginalPhoto=YES;
    //设置用户勾选
    [image_Tz setSelectedAssets:_photo_array];
    //选择照片完成之后按下【确定键】进入到代码块
    [image_Tz setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _photo_array=[NSMutableArray arrayWithArray:assets];
        //photo是选中的照片
        _image_photo =[NSMutableArray array];
        [_image_photo addObjectsFromArray:photos];
        
        //判断是否是原图
        if (isSelectOriginalPhoto) {
            for (PHAsset *asset_photo in _photo_array) {
                [[TZImageManager manager]getOriginalPhotoWithAsset:asset_photo completion:^(UIImage *photo, NSDictionary *info) {
                    
                }];
            }
        }else{
         
        }
        
        [self.collectview reloadData];
    }];
    //页面跳转，框架带页面跳回
    [self presentViewController:image_Tz animated:YES completion:nil];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _image_photo.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    cell_s=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (int i=0; i<self.image_photo.count; i++) {
        if (i%3==0) {
            UIImageView *image_phot=[[UIImageView alloc]initWithFrame:CGRectMake(0, i*cell_s.frame.size.height+3, cell_s.frame.size.width,i*cell_s.frame.size.height+0.5f)];
            image_phot.image=self.image_photo[indexPath.row];
            cell_s.backgroundView=image_phot;
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            [cell_s addGestureRecognizer:tap];
        }
    }
    
    return cell_s;
}
-(void)tapImage:(UITapGestureRecognizer *)sender{
   
    [self photoImage:sender];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80) ;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.1f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(13,0, 10,0);
}
-(NSMutableArray *)photo_array{
    if (_photo_array) {
        return _photo_array;
    }
    return _photo_array=[NSMutableArray array];
}
-(NSMutableArray *)image_photo{
    if (_image_photo) {
        return _image_photo;
    }else{
        return _image_photo=[NSMutableArray array];
    }
}
//发送调用数据模型里的方法
- (IBAction)sendBut:(id)sender {
       [[[SendMessageSpm alloc]init]getSendMessageType:@1 andZone_id:b andcContent:_textView.text andCity:time_city];
    jumpViewController *jump=[self.storyboard instantiateViewControllerWithIdentifier:@"jumpViewController"];
    [self.navigationController pushViewController:jump animated:YES];
}
-(void)getLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager=[[CLLocationManager alloc]init];
        locationManager.delegate=self;
        [locationManager requestAlwaysAuthorization];//永久授权
        
        //设置定位精度
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        city=[[NSString alloc]init];
        [locationManager requestWhenInUseAuthorization];//是使用中授权
        //进行定位
        [locationManager startUpdatingLocation];
        //方向定位
        [locationManager startUpdatingHeading];
        
    }
}
//定位成功调用的方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation=[locations lastObject];//最后一个值为最新位置
    [locationManager stopUpdatingLocation];//停止定位
//    获取经度纬度
    CLLocationCoordinate2D coor2d=newLocation.coordinate;
    double latitude=coor2d.latitude;
    double longitude=coor2d.longitude;
    NSLog(@"经度%f  ,  纬度%f",latitude,longitude);
    //精度
    CLLocationAccuracy horiz=newLocation.horizontalAccuracy;
    CLLocationAccuracy vertical=newLocation.verticalAccuracy;
    NSLog(@"水平%f    垂直%f",horiz,vertical);
    //高度
    CLLocationDistance height=newLocation.altitude;
    NSLog(@"高度为%f",height);
    //取当前位置
    NSDate *date_timestamp=[newLocation timestamp];
    //  实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //  设定时间格式
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    [dateFormat setAMSymbol:@"AM"];         //  显示中文, 改成"上午"
    [dateFormat setPMSymbol:@"PM"];
    //  求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    NSString *dateString = [dateFormat stringFromDate:date_timestamp];
    NSLog(@"此时此刻时间 = %@",dateString);
        CLGeocoder *locationCode=[[CLGeocoder alloc]init];
//    NSLog(@"经度:%f     纬度:%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    //反编码
    
    [locationCode reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark *place_mark=placemarks[0];
            city=place_mark.locality;
            NSLog(@"...city%@",city);
            //当位置请求成功的时候调用发布的方法：位置==定位到的当前位置
time_city=[[NSString alloc]initWithFormat:@"来源:%@,发送时间:%@",city,dateString ];
            if (!city) {
                //四大直辖市无法通过locality进行定位，只能通过省份来获取
                city=place_mark.administrativeArea;
               
            }
        }else if (error==nil&&placemarks.count==0){
           city=@"没有订到当前位置";
        }
    }];
    


}
#pragma mark 定位失败Method
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位错误%@",error);

    }


//商圈列表数组的懒加载
-(NSMutableArray *)shangquan_array{
    if (shangquan_array) {
        return shangquan_array;
    }else{
        return shangquan_array=[NSMutableArray array];
    }
}
-(NSMutableArray *)find_goods{
    if (find_goods) {
        return find_goods;
    }else{
        return find_goods=[NSMutableArray array];
    }
}
//移除通知和观察者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"获取发布信息" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"获取分类列表数据" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"获取商圈列表" object:nil];
}

@end
