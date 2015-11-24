//
//  CMTopicsListVC.m
//  Code Monk
//
//  Created by yogesh singh on 21/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMBookmarksListVC.h"
#import "CMDataProvider.h"
#import "CMTopicDetailsVC.h"
#import "CMExampleDetailsVC.h"
#import "UIView+Toast.h"
#import "CMUtils.h"

@interface CMBookmarksListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArr;

@end

NSString *bookmarkID = @"bookmarkID";

@implementation CMBookmarksListVC
@synthesize topicsArr, exampleArr, dataArr;
@synthesize segmentControl, table;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *items = [NSMutableArray array];
    if (topicsArr.count > 0)  [items addObject:@"Topics"];
    if (exampleArr.count > 0) [items addObject:@"Examples"];
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.tintColor = [CMUtils getAverageColorFromImage:appIcon];
    segmentControl.backgroundColor = [UIColor whiteColor];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:FONT_MED}
                                  forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Futura-Medium" size:20]}
                                  forState:UIControlStateSelected];
    segmentControl.selectedSegmentIndex = 0;
    dataArr = topicsArr;
    
    [segmentControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
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
    
    segmentControl.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 45);
    
    table.frame = CGRectMake(0, segmentControl.frame.origin.y + segmentControl.frame.size.height, self.view.frame.size.width,
                             self.view.frame.size.height - (segmentControl.frame.origin.y + segmentControl.frame.size.height));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    topicsArr  = [CMDataProvider getAllBookmarkedTopics];
    exampleArr =  [CMDataProvider getAllBookmarkedExamples];
    
    if (topicsArr.count == 0 && exampleArr.count == 0) {
        segmentControl.alpha = 0.3;
        table.alpha = 0.3;
        [self.view makeToast:@"No Topics or Examples are bookmarked" duration:3.0
                    position:[NSValue valueWithCGPoint:self.view.center]
                       title:nil image:[UIImage imageNamed:@"codemonk_logo"] style:nil
                  completion:^(BOOL didTap) {
                      
                      [self.navigationController popToRootViewControllerAnimated:YES];
                   }];
        
        dataArr = nil;
    }
    else if (topicsArr.count == 0){
        if(segmentControl.numberOfSegments > 1) [segmentControl removeSegmentAtIndex:0 animated:NO];
        [segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Futura-Medium" size:20]}
                                      forState:UIControlStateNormal];
        segmentControl.selectedSegmentIndex = 0;
        dataArr = exampleArr;
    }
        
    else if (exampleArr.count == 0){
        if(segmentControl.numberOfSegments > 1) [segmentControl removeSegmentAtIndex:1 animated:NO];
        [segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Futura-Medium" size:20]}
                                      forState:UIControlStateNormal];
        segmentControl.selectedSegmentIndex = 0;
        dataArr = topicsArr;
    }
    else if (segmentControl.numberOfSegments == 1 && (topicsArr.count > 0) && (exampleArr.count >0)){
//        add segment
//        [segmentControl insertSegmentWithTitle:<#(nullable NSString *)#> atIndex:<#(NSUInteger)#> animated:<#(BOOL)#>]
    }
    else{
        dataArr = (segmentControl.selectedSegmentIndex == 0) ? topicsArr : exampleArr;
    }

    [table reloadData];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"Bookmarks";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self action:@selector(shareSelected:)];
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
    gradient.colors = [NSArray arrayWithObjects:(id)[RGB(147, 209, 255) CGColor],
                       (id)[RGB(147, 209, 255) CGColor],
                       (id)[[UIColor whiteColor] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:gradientView];
    [self.view sendSubviewToBack:gradientView];
}

- (void)shareSelected:(id)sender{
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[LINK_TO_SHARE]
                                                        applicationActivities:nil];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)selectedSegment:(id)sender{
    dataArr = (segmentControl.selectedSegmentIndex == 0) ? topicsArr : exampleArr;
    [table reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookmarkID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bookmarkID];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < dataArr.count) {
        
        id obj = dataArr[indexPath.row];
        
        if ([obj isKindOfClass:[Topic class]]) {
            
            Topic *topic = obj;
            
            cell.textLabel.text = topic.title;
            cell.detailTextLabel.text = topic.text;
        }
        else if ([obj isKindOfClass:[Example class]]){
            
            Example *example = obj;
            
            cell.textLabel.text = example.title;
            cell.detailTextLabel.text = example.exampleOfTopic.title;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < dataArr.count) {
        
        id obj = dataArr[indexPath.row];
        
        if ([obj isKindOfClass:[Topic class]]) {
            
            Topic *topic = obj;
            
            CMTopicDetailsVC *detailsVC = [[CMTopicDetailsVC alloc] init];
            detailsVC.topicObj = topic;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
        else if ([obj isKindOfClass:[Example class]]){
            
            Example *example = obj;
            
            CMExampleDetailsVC *detailsVC = [[CMExampleDetailsVC alloc] init];
            detailsVC.exampleObj = example;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
