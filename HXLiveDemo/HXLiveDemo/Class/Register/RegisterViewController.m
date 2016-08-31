//
//  RegisterViewController.m
//  HXLiveDemo
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 JunLiu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property(nonatomic,strong)UILabel *nameLabe;
@property(nonatomic,strong)UILabel *passwordLabe;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UIView *bgView;
@end

@implementation RegisterViewController



-(UILabel *)nameLabe{
    if (!_nameLabe) {
        _nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(0 , 5 , 50, 20)];
        _nameLabe.text = @"用户名";
        _nameLabe.textColor = [UIColor lightGrayColor];
        _nameLabe.textAlignment = NSTextAlignmentCenter;
        _nameLabe.font = [UIFont systemFontOfSize:13];
        
    }
    return _nameLabe;
}

-(UILabel *)passwordLabe{
    if (!_passwordLabe) {
        _passwordLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabe.frame.origin.x, self.nameLabe.frame.origin.y+self.nameLabe.frame.size.height+10, self.nameLabe.frame.size.width, self.nameLabe.frame.size.height)];
        _passwordLabe.text = @"密码";
        _passwordLabe.textColor = [UIColor lightGrayColor];
        _passwordLabe.textAlignment = NSTextAlignmentCenter;
        _passwordLabe.font = [UIFont systemFontOfSize:13];
    }
    return _passwordLabe;
}

-(UITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(self.nameLabe.frame.origin.x+self.nameLabe.frame.size.width+5, self.nameLabe.frame.origin.y, self.view.frame.size.width/2, self.nameLabe.frame.size.height)];
        _nameTF.layer.cornerRadius = 3.0;
        _nameTF.layer.masksToBounds = YES;
        _nameTF.layer.borderWidth = 1.0;
        _nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nameTF.placeholder = @"请输入手机号";
    }
    return _nameTF;
}

-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(self.passwordLabe.frame.origin.x+self.passwordLabe.frame.size.width+5, self.passwordLabe.frame.origin.y, self.view.frame.size.width/2, self.passwordLabe.frame.size.height)];
        _passwordTF.layer.cornerRadius = 3.0;
        _passwordTF.layer.masksToBounds = YES;
        _passwordTF.layer.borderWidth = 1.0;
        _passwordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordTF.placeholder = @"6-16位的数字或字母";
    }
    return _passwordTF;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(self.view.frame.size.width/2-40, _bgView.frame.origin.y+_bgView.frame.size.height, 40, 40);
        [_loginButton setTitle:@"确定" forState:0];
        [_loginButton setTitleColor:[UIColor blueColor] forState:0];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_loginButton addTarget:self action:@selector(loginActin:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
}

-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(self.view.frame.size.width/2-40+40, _bgView.frame.origin.y+_bgView.frame.size.height, 40, 40);
        [_registerButton setTitle:@"取消" forState:0];
        [_registerButton setTitleColor:[UIColor blueColor] forState:0];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(void)initUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width*2/3/2, 74, self.view.frame.size.width*2/3, self.view.frame.size.height/4)];
    [self.view addSubview:_bgView];
    [_bgView addSubview:self.nameLabe];
    [_bgView addSubview:self.passwordLabe];
    [_bgView addSubview:self.nameTF];
    [_bgView addSubview:self.passwordTF];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self initUI];
}

-(void)loginActin:(UIButton *)sender{
    if ([self.nameTF.text isEqualToString:@""]|| [self.passwordTF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"账号、密码不能为空"];
    }else if ( ![self validateMobile:self.nameTF.text]){
        [MBProgressHUD showError:@"请输入手机号"];
    }else if (![self checkPassword:self.passwordTF.text]){
        [MBProgressHUD showError:@"请输入6-16位数字或字母"];
    }else{
        EMError *error = [[EMClient sharedClient]registerWithUsername:self.nameTF.text password:self.passwordTF.text];
        NSLog(@"%@--%@",error.errorDescription,self.nameTF.text);
        if (error == nil) {
            NSLog(@"注册成功");
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            NSLog(@"注册失败 %@",error);
        }
    }    
}

-(void)registerAction:(UIButton *)sender{
  [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark -----------判断输入是否符合------------
//邮箱
-(BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
-(BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark ---密码正则  6-16位数字或字母的密码---
-(BOOL)checkPassword:(NSString *)password{
    NSString *pattern = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
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
