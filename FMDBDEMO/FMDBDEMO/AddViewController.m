//
//  AddViewController.m
//  FMDBDEMO
//
//  Created by 小崔 on 2018/4/16.
//  Copyright © 2018年 CJW. All rights reserved.
//

#import "AddViewController.h"
#import "FMDB.h"
#import "NavView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH [UISCreen mainScreen].bounds.size.height



@interface AddViewController ()
@property(strong,nonatomic)NavView * nav;
@property(nonatomic,strong)FMDatabase * db;
@property(strong,nonatomic)NSString * dbPath;
@property(strong,nonatomic)UITextField * nameTxteField;
@property(strong,nonatomic)UITextField * ageTextField;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.nav  = [[NavView alloc]initWithLeftBtn:@"back" andWithBgImg:nil andTitle:@"数据新增" andWithRightBtn:nil andwithLab1Btn:nil andWithLab2Btn:nil];
    [self.nav.leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    [self content];
}
-(void)leftBtn:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)content{
    self.nameTxteField = [[UITextField alloc]initWithFrame:CGRectMake(10, 95, SCREEN_WIDTH-20, 50)];
    self.nameTxteField.layer.borderWidth = 1.0;
    self.nameTxteField.layer.cornerRadius = 5.0;
    self.nameTxteField.layer.borderColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1].CGColor;
    self.nameTxteField.clipsToBounds = YES;
    self.nameTxteField.placeholder = @"请输入姓名";
    [self.view addSubview:_nameTxteField];
    
    self.ageTextField = [[UITextField alloc]initWithFrame:CGRectMake(10,175 , SCREEN_WIDTH-20, 50)];
    self.ageTextField.placeholder = @"请输入年龄";
    self.ageTextField.layer.cornerRadius = 5;
    self.nameTxteField.layer.borderColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
    self.ageTextField.clipsToBounds = YES;
    self.ageTextField.layer.borderWidth = 1.0;
    self.ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_ageTextField];
    
    
    
    UIButton * save = [[UIButton alloc]initWithFrame:CGRectMake(10, 260, SCREEN_WIDTH-20, 50)];
    save.backgroundColor = [UIColor redColor];
    [save setTitle:@"保存" forState:0];
    [save addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    
}

-(void)saveBtn:(UIButton*)sender{
    if (![_nameTxteField.text isEqual:@""] && ![_ageTextField.text isEqualToString:@""]){
        [self saveData];
    }
}

-(void)saveData{
    //h获取文件路劲
    NSString * dco = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSString * fileName = [dco stringByAppendingPathComponent:@"userData.sqlite"];
    
    self.dbPath = fileName;
    
    
    //2,获得数据库
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    //3,打开数据库
    if ([db open]){
        //创建一张表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userData (id integer PRIMARY KEY AUTOINCREMENT,userName text NOT NULL,userAge text NOT NULL);"];
        if (result){
            NSLog(@"创建成功");
        }else {
            NSLog(@"创建失败");
        }
    }
    self.db = db;
    [self insert];
    
}

-(void)insert{
    BOOL res = [self.db executeUpdate:@"INSERT INTO t_userData (userName,userAge) VALUES (?,?);",_nameTxteField.text,_ageTextField.text];
    if (res){
        NSLog(@"增加数据成功");
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"新增数据成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.5];
    
    }else{
        NSLog(@"增加数据失败");
    }
}
-(void)dismiss:(UIAlertController*)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
