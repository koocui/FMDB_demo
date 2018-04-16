//
//  AlterViewController.m
//  FMDBDEMO
//
//  Created by 小崔 on 2018/4/16.
//  Copyright © 2018年 CJW. All rights reserved.
//

#import "AlterViewController.h"
#import "FMDB.h"
#import "NavView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH [UISCreen mainScreen].bounds.size.height

@interface AlterViewController ()
@property(nonatomic,strong)FMDatabase * db;
@property(nonatomic,strong)NavView * nav;
@property(nonatomic,strong)NSString * dbPath;
@property(nonatomic,strong)UITextField * nameTxteField;
@property(nonatomic,strong)UITextField * ageTextField;
@end

@implementation AlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.nav = [[NavView alloc]initWithLeftBtn:@"back" andWithBgImg:nil andTitle:@"数据修改" andWithRightBtn:nil andwithLab1Btn:nil andWithLab2Btn:nil];
    [self.view addSubview:_nav];
    
    [self content];
    
}
-(void)content{
    self.nameTxteField = [[UITextField alloc]initWithFrame:CGRectMake(10, 95, SCREEN_WIDTH-20, 50)];
    self.nameTxteField.layer.borderWidth = 1.0;
    self.nameTxteField.layer.cornerRadius = 5.0;
    self.nameTxteField.layer.borderColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1].CGColor;
    self.nameTxteField.clipsToBounds = YES;
    self.nameTxteField.text = _userName;
    [self.view addSubview:_nameTxteField];
    
    self.ageTextField = [[UITextField alloc]initWithFrame:CGRectMake(10,175 , SCREEN_WIDTH-20, 50)];
    self.ageTextField.text = _userAge;
    self.ageTextField.layer.cornerRadius = 5;
    self.nameTxteField.layer.borderColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
    self.ageTextField.clipsToBounds = YES;
    self.ageTextField.layer.borderWidth = 1.0;
    self.ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_ageTextField];
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 250, SCREEN_WIDTH-20, 50)];
    saveBtn.backgroundColor = [UIColor redColor];
    [saveBtn setTitle:@"保存" forState:0];
    [saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}
-(void)saveBtn:(UIButton*)sender{
    if (![_nameTxteField.text  isEqual: @""] && ![_ageTextField.text  isEqual: @""]) {
        [self updateData];
    }
}
-(void)updateData{
    //
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath = [doc stringByAppendingPathComponent:@"userData.sqlite"];
    self.dbPath = filePath;
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]){
        NSString * sql = @"UPDATE t_userData SET userName = ? , userAge = ? WHERE id = ?";
        BOOL res = [db executeUpdate:sql,_nameTxteField.text,_ageTextField.text,_userId];
        if (!res){
            NSLog(@"数据库修改失败");
        }else{
            NSLog(@"数据库修改成功");
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据库修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
        }
        [db close];
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
