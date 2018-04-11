//
//  NavView.h
//  FMDBDEMO
//
//  Created by 小崔 on 2018/4/10.
//  Copyright © 2018年 CJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView
@property(strong,nonatomic) UIImageView * bgImg;
@property(strong,nonatomic) UIButton * rightBtn;
@property(strong,nonatomic) UIButton * lab1Btn;
@property(strong,nonatomic) UILabel  * titleLab;
@property(strong,nonatomic) UIButton * leftBtn;
@property(strong,nonatomic) UIButton * lab2Btn;
-(instancetype)initWithLeftBtn:(NSString*)leftBtn andWithBgImg:(UIImageView*)bgImg andTitle:(UILabel*)titleLabel andWithRightBtn:(UIButton*)ringtBtn andwithLab1Btn:(UIButton*)lab1Btn andWithLab2Btn:(UIButton*)lab2Btn;;
@end
