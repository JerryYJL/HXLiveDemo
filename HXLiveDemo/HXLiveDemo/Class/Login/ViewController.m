//
//  ViewController.m
//  HXLiveDemo
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 JunLiu. All rights reserved.
//

#import "ViewController.h"
#import "FriendListTableViewController.h"
#import "RegisterViewController.h"


@interface ViewController ()
@property(nonatomic,strong)UILabel *nameLabe;
@property(nonatomic,strong)UILabel *passwordLabe;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UIView *bgView;
@end

@implementation ViewController

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
    }
    return _passwordTF;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(self.view.frame.size.width/2-40, _bgView.frame.origin.y+_bgView.frame.size.height, 40, 40);
        [_loginButton setTitle:@"登录" forState:0];
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
        [_registerButton setTitle:@"注册" forState:0];
        [_registerButton setTitleColor:[UIColor blueColor] forState:0];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(void)initUI{
    self.view.layer.contents = (id)[UIImage imageNamed:@"美女.jpg"].CGImage;
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
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"登陆";
    [self initUI];
    
}

-(void)loginActin:(UIButton *)sender{
   
        //判断是否登录成功
        EMError *error = [[EMClient sharedClient]loginWithUsername:self.nameTF.text password:self.passwordTF.text];
        if (!error) {
            NSLog(@"登录成功");
            //从数据库中获取信息
            [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FriendListTableViewController *friendListTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"FriendListTableViewController"];
            [self.navigationController pushViewController:friendListTableViewController animated:NO];
        }else{
            [MBProgressHUD showError:@"请输入正确的账号、密码"];
        }
    
    
    
}

-(void)registerAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *registerViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:registerViewController animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
