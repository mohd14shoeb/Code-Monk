//
//  CMHomeVC.m
//  Code Monk
//
//  Created by yogesh singh on 18/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMHomeVC.h"
#import "CMServerHelper.h"
#import "CMDataProvider.h"
#import "CMHomeViewCell.h"
#import "CMTopicsListVC.h"
#import "CMBookmarksListVC.h"
#import "UIView+Toast.h"
#import "CMUtils.h"

NSString *cellIdentifier = @"cellIdentifier";

@interface CMHomeVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UICollectionView *gridView;

@end

@implementation CMHomeVC
@synthesize dataArr, gridView;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 20.0f;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    gridView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [gridView setDelegate:self];
    [gridView setDataSource:self];
    [gridView setContentOffset:CGPointZero];
    [gridView setBackgroundColor:[UIColor clearColor]];
    [gridView registerClass:[CMHomeViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:gridView];
    
    [CMServerHelper fetchAllTopics];
    dataArr = [CMDataProvider getAllCategoriesByFilter:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllTopics:)
                                                 name:UPDATED_ALL_TOPICS object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 135, 45)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    img.frame = CGRectMake(0, 2.5, 40, 40);
    img.contentMode = UIViewContentModeScaleAspectFit;
    [titleView addSubview:img];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width + 5, 0, 85, 45)];
    titleLab.font = [UIFont boldSystemFontOfSize:24];
    titleLab.text = @"Code Monk";
    titleLab.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:titleLab];
    titleView.center = self.navigationItem.titleView.center;
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *bookmarksList = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmarkList"]
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(showBookmarks:)];
    self.navigationItem.rightBarButtonItem = bookmarksList;
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                            target:self action:@selector(shareSelected:)];
    self.navigationItem.leftBarButtonItem = shareBtn;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self setGradient];

    gridView.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Data Helpers

- (void)updateAllTopics:(NSNotification *)notification{
    
    dataArr = [CMDataProvider getAllCategoriesByFilter:nil];
    [gridView reloadData];
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

- (void)showBookmarks:(id)sender{
    
    NSArray *bookmarkedTopics = [CMDataProvider getAllBookmarkedTopics];
    
    NSArray *bookmarkedExamples = [CMDataProvider getAllBookmarkedExamples];
    
    if ((bookmarkedTopics.count > 0) || (bookmarkedExamples.count > 0)) {

        CMBookmarksListVC *bookmarksVC = [[CMBookmarksListVC alloc] init];
        bookmarksVC.topicsArr = bookmarkedTopics;
        bookmarksVC.exampleArr = bookmarkedExamples;
        [self.navigationController pushViewController:bookmarksVC animated:YES];
    }
    else{
        gridView.alpha = 0.3;
        
        [self.view makeToast:nil duration:2.0
                    position:[NSValue valueWithCGPoint:self.view.center]
                       title:@"No Topics or Examples are bookmarked"
                       image:[UIImage imageNamed:@"codemonk_logo"]
                       style:nil
                  completion:^(BOOL didTap) {
                           
                           [UIView animateWithDuration:0.5 animations:^{
                                           gridView.alpha = 1;
                           }];
        }];
    }
}


#pragma mark - Collection View Helpers

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    
    if (indexPath.row == 0) {
        size = CGSizeMake(self.view.frame.size.width, 180);
    }
    else if (indexPath.row == (dataArr.count-1)){
        size = CGSizeMake(self.view.frame.size.width - 40, 60);
    }
    else {
        size = CGSizeMake((self.view.frame.size.width-80)/2, 90);
    }
    
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CMHomeViewCell *cell = (CMHomeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CMHomeViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 90)];
    }
    
    if (indexPath.row < dataArr.count) {
        
        cell.titleLab.text = dataArr[indexPath.row];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < dataArr.count) {
        
        CMTopicsListVC *topicsVC = [[CMTopicsListVC alloc] init];
        
        topicsVC.titleStr = (indexPath.row == 0) ? @"All Topics" : dataArr[indexPath.row];
        
        topicsVC.dataArr = [CMDataProvider getAllTopicsByFilter:(indexPath.row == 0) ? nil : dataArr[indexPath.row]];
        
        [self.navigationController pushViewController:topicsVC animated:YES];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
