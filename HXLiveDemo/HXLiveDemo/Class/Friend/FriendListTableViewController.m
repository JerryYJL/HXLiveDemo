//
//  FriendListTableViewController.m
//  HXLiveDemo
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 JunLiu. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "FriendTableViewCell.h"
#import "ChatViewController.h"
#define CellID @"CellID"
@interface FriendListTableViewController ()<EMContactManagerDelegate>

{
    NSMutableArray *dataSource;
}
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UITextField *TF;
@end

@implementation FriendListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:CellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addNavigationItem];
    dataSource = [NSMutableArray array];
    [self getFriendList];
    
    
    
}

-(void)addNavigationItem{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(backLogin:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)getFriendList{
    EMError *error = nil;
    NSArray *userList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取好友列表成功 -- %@",userList);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:userList];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.tableView reloadData];
            });
            
        });
    }
}

-(void)backLogin:(UIBarButtonItem *)sender{
    EMError *error = [[EMClient sharedClient]logout:YES];
    if (!error) {
        NSLog(@"退出登录成功");
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        NSLog(@"退出失败");
    }
}

-(void)addFriend:(UIBarButtonItem *)sender{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100/2, 0, self.view.frame.size.width/2, 100)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.layer.cornerRadius = 8.0;
        _bgView.layer.masksToBounds = YES;
        [self.view addSubview:_bgView];
        
        _TF = [[UITextField alloc]initWithFrame:CGRectMake(5, _bgView.center.y-15, _bgView.frame.size.width-10, 30)];
        
        _TF.borderStyle = UITextBorderStyleRoundedRect;
        _TF.placeholder = @"好友账号";
        [_bgView addSubview:_TF];
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(_TF.frame.origin.x, _bgView.frame.origin.y+_bgView.frame.size.height-20-10, 50, 20);
        [cancleButton setTitle:@"取消" forState:0];
        [cancleButton setTitleColor:[UIColor blueColor] forState:0];
        cancleButton.titleLabel.textAlignment = NSTextAlignmentJustified;
        cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        cancleButton.layer.cornerRadius = 4.0;
        cancleButton.layer.masksToBounds = YES;
        [_bgView addSubview:cancleButton];
        [cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkButton.frame =CGRectMake(_TF.frame.origin.x+_TF.frame.size.width-55, _bgView.frame.origin.y+_bgView.frame.size.height-20-10, 50, 20);
        [checkButton setTitle:@"确定" forState:0];
        [checkButton setTitleColor:[UIColor blueColor] forState:0];
        checkButton.titleLabel.textAlignment = NSTextAlignmentJustified;
        checkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        checkButton.layer.cornerRadius = 4.0;
        checkButton.layer.masksToBounds = YES;
        [_bgView addSubview:checkButton];
        [checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        _bgView.frame =CGRectMake(self.view.frame.size.width/2- self.view.frame.size.width/4, self.view.frame.size.height/2-100/2-64, self.view.frame.size.width/2, 100);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)cancleAction:(UIButton *)sender{
    [_bgView removeFromSuperview];
    _bgView = nil;
}

-(void)checkAction:(UIButton *)sender{
    
    
    EMError *error = [[EMClient sharedClient].contactManager addContact:_TF.text message:nil];
    if (!error) {
        NSLog(@"添加成功");
        [_bgView removeFromSuperview];
        _bgView = nil;
    }else{
         [MBProgressHUD showError:@"输入不能为空"];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听添加好友回调
//监听回调


- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", aUsername] message:aMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
        // 同意好友请求的方法
        EMError *agreeError = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!agreeError) {
            NSLog(@"发送同意成功");
            
        //获取好友列表并刷新tableView
        [self getFriendList];
                                        }
                                    }];
    
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"NO" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        // 拒绝好友请求的方法
        EMError *rejectError = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!rejectError) {
            NSLog(@"发送拒绝成功");
        }
    }];

    [alertController addAction:acceptAction];
    [alertController addAction:rejectAction];
    [self showDetailViewController:alertController sender:nil];
}

//好友申请处理结果回调
//监听回调
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSLog(@"%@同意了我的好友请求",aUsername);
    
    [self getFriendList];//获取好友列表并刷新tableView
}
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSLog(@"%@拒绝了我的好友请求",aUsername);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.userNameLabel.text =dataSource[indexPath.row];
    cell.lineView.backgroundColor = [UIColor lightGrayColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:dataSource[indexPath.row] conversationType:EMConversationTypeChat];
    chatController.title=dataSource[indexPath.row];
    [self.navigationController pushViewController:chatController animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:dataSource[indexPath.row]];
        if (!error) {
            NSLog(@"删除成功");
        }

        [dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
