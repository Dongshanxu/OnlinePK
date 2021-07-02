//
//  NETSMicRequestViewController.m
//  NLiteAVDemo
//
//  Created by vvj on 2021/4/26.
//  Copyright © 2021 Netease. All rights reserved.
//

#import "NETSMicRequestViewController.h"
#import "NETSRequestConnectMicCell.h"
#import "NETSLiveApi.h"
#import "NETSConnectMicModel.h"

@interface NETSMicRequestViewController ()<UITableViewDelegate,UITableViewDataSource,NETSMicRequestViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NETSMicRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)nets_initializeConfig {
    self.roomId = (NSString *)self.params;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:NotificationName_Anchor_RefreshSeats object:nil];
}

- (void)nets_addSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(240);
    }];
}

- (void)nets_getNewData {
    
    [NETSLiveApi requestMicSeatsResultListWithRoomId:self.roomId type:NETSUserStatusApply successBlock:^(NSDictionary * _Nonnull response) {
        NSArray *list = response[@"/data/seatList"];
        if (list && [list isKindOfClass:[NSArray class]]) {
            self.dataArray = [[NSMutableArray alloc]initWithArray:list];
        } else {
            self.dataArray = [NSMutableArray array];
        }
        [self.tableView reloadData];
        YXAlogInfo(@"请求邀请上麦列表成功,response = %@",response);
    } failedBlock:^(NSError * _Nonnull error, NSDictionary * _Nullable response) {
        YXAlogError(@"请求邀请上麦列表失败，error = %@",error.description);
    }];
}

- (void)refreshData:(NSNotification *)notification {
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    if (index == 1) {
        [self nets_getNewData];
    }
}

#pragma mark - NETSMicRequestViewDelegate

-(void)dealMicRequestAccept:(BOOL)isAccept accountId:(nonnull NSString *)accountId{
    if (isAccept) {//接受上麦
        [NETSLiveApi requestSeatManagerWithRoomId:self.roomId userId:accountId index:1 action:NETSSeatsOperationAdminAcceptJoinSeats successBlock:^(NSDictionary * _Nonnull response) {
            YXAlogDebug(@"主播同意上麦成功,response = %@",response);
        } failedBlock:^(NSError * _Nonnull error, NSDictionary * _Nullable response) {
            if (error) {
                [NETSToast showToast:response[@"msg"]];
            }
            YXAlogError(@"主播同意上麦失败，error = %@",error.description);
        }];
    }else {//拒绝上麦
        [NETSLiveApi requestSeatManagerWithRoomId:self.roomId userId:accountId index:1 action:NETSSeatsOperationAdminRejectAudienceApply successBlock:^(NSDictionary * _Nonnull response) {
            YXAlogDebug(@"主播拒绝观众上麦成功,response = %@",response);
        } failedBlock:^(NSError * _Nonnull error, NSDictionary * _Nullable response) {
            YXAlogError(@"主播拒绝观众上麦失败，error = %@",error.description);
        }];
    }
    //硬删除数据
    for (NETSConnectMicMemberModel *userModel in self.dataArray) {
        if ([userModel.accountId isEqualToString:accountId]) {
            NSInteger index = [self.dataArray indexOfObject:userModel];
            [self.dataArray removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NETSConnectMicMemberModel *userModel = self.dataArray[indexPath.row];
    NETSRequestConnectMicCell *requestCell = [NETSRequestConnectMicCell loadRequestConnectMicCellWithTableView:tableView];
    requestCell.cellIndexPath = indexPath;
    requestCell.userModel = userModel;
    requestCell.delegate = self;
    return requestCell;
}

#pragma mark - Get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end