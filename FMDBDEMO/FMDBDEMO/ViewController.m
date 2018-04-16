//
//  ViewController.m
//  FMDBDEMO
//
//  Created by 小崔 on 2018/4/10.
//  Copyright © 2018年 CJW. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "NavView.h"

//#import "agreeFirstNav.h"
#import "AddViewController.h"
//
#import "AlterViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NavView *nav;
@property(nonatomic,strong)FMDatabase *db;
@property(strong,nonatomic)NSMutableArray *nameArr;
@property(strong,nonatomic)NSMutableArray *ageArr;
@property(strong,nonatomic)NSMutableArray *idArr;


@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self lockData];
}
-(void)lockData{
    self.nameArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.ageArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.idArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //1,获取数据库文件路劲
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * fileName = [doc stringByAppendingPathComponent:@"userData.sqlite"];
    
    //2,获得数据库
    FMDatabase * db = [FMDatabase databaseWithPath:fileName];
    
    if ([db open]){
        
    }
    self.db = db;
    
    //1,执行查询语句
    FMResultSet * resultSet = [self.db executeQuery:@"SELECT * FROM t_userData"];
    while ([resultSet next]) {
        NSString * nameStr = [resultSet stringForColumn:@"userName"];
        [self.nameArr addObject:nameStr];
        
        NSString * ageStr = [resultSet stringForColumn:@"userAge"];
        [self.ageArr addObject:ageStr];
        
        NSString * idStr = [resultSet stringForColumn:@"id"];
        [self.idArr addObject:idStr];
        
        NSLog(@"保存的数据为：：%@,%@,%@",_nameArr,_ageArr,_idArr);
    }
    
    [self.myTableView reloadData];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nav = [[NavView alloc]initWithLeftBtn:@"delete" andWithBgImg:nil andTitle:@"数据列表" andWithRightBtn:@"addNav" andwithLab1Btn:nil andWithLab2Btn:nil];
    
    [self.nav.leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.nav.rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)leftBtn:(UIButton*)sender{
    [self deletaAllData];
}

-(void)rightBtn:(UIButton*)sender{
    AddViewController * avc = [[AddViewController alloc]init];
    [self.navigationController pushViewController:avc  animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ageArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlterViewController * avc = [[AlterViewController alloc]init];
    
    avc.userId = _idArr[indexPath.row];
    avc.userAge = _ageArr[indexPath.row];
    avc.userName = _nameArr[indexPath.row];
    
    [self.navigationController pushViewController:avc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"姓名：%@ 年龄：%@岁",_nameArr[indexPath.row],_ageArr[indexPath.row]];
    return cell;
}

//删除ab数组
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewCellStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString * str  = [NSString stringWithFormat:@"%@",_idArr[indexPath.row]];
        int count = [str intValue];
        [self deleteData:count];
    }];
    return @[action];
}

//删除一条数据
-(void)deleteData:(NSInteger)userid{
    NSLog(@"%ld",(long)userid);
    //1,获取数据库文件路劲
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filename = [doc stringByAppendingPathComponent:@"userData.sqlite"];
    //2，获取数据库
    FMDatabase * db = [FMDatabase databaseWithPath:filename];
    
    if ([db open]){
        NSString * str = [NSString stringWithFormat:@"DELETE FROM t_userData WHERE id = %ld",userid];
        BOOL res = [db executeUpdate:str];
        if (!res){
            NSLog(@"删除数据失败");
            [self lockData];
        }else{
            NSLog(@"删除成功");
            [self lockData];
        }
        [db close];
    }
    
}

-(void)deletaAllData{
    //1,获得数据库文件的路劲
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * fileName = [doc stringByAppendingPathComponent:@"userData.sqlite"];
    
    //2，获得数据库
    FMDatabase * db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        NSString * str = @"DELETE FROM t_userData";
        BOOL res = [db executeUpdate:str];
        if (!res){
            NSLog(@"数据清除失败");
            [self lockData];
        }else{
            NSLog(@"数据清除成功");
            [self lockData];
        }
        [db close];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
