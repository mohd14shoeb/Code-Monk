//
//  CMTopicsListVC.m
//  Code Monk
//
//  Created by yogesh singh on 21/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMTopicsListVC.h"
#import "CMUtils.h"

@interface CMTopicsListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@end

NSString *cellId = @"cellId";

@implementation CMTopicsListVC
@synthesize titleStr, dataArr;
@synthesize table;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor blackColor];
    [self.view addSubview:table];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self setGradient];
    
    table.frame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = titleStr;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Helpers

- (void)setGradient{
    
    UIView *gradientView = [[UIView alloc] initWithFrame:self.view.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[CMUtils getAverageColorFromImage:appIcon] CGColor],
                                                (id)[RGB(147, 209, 255) CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:gradientView];
    [self.view sendSubviewToBack:gradientView];
}


#pragma mark - Table View Helpers

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < dataArr.count) {
        
        Topic *topic = dataArr[indexPath.row];
        
        cell.textLabel.text = topic.title;
        cell.detailTextLabel.text = topic.text;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < dataArr.count) {
        
    }
}

@end
