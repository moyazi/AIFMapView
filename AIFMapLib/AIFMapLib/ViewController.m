//
//  ViewController.m
//  AIFMapLib
//
//  Created by moyazi on 2020/1/14.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "ViewController.h"
#import "CommonHeader.h"
#import "AIFDistributionMapViewController.h"
#import "AIIFPolygonDrawingViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AIFMapLib";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark  - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"全国分布";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"路径绘制";
        }
            break;
            
        default:{
            cell.textLabel.text = @"";
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            AIFDistributionMapViewController *vc = [AIFDistributionMapViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 1:
            {
                AIIFPolygonDrawingViewController *vc = [AIIFPolygonDrawingViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            
        default:
            break;
    }
}





#pragma mark - lazy

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
