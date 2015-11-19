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
    layout.minimumInteritemSpacing = 5.0f;
    layout.minimumLineSpacing = 20.0f;
    
    gridView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [gridView setDelegate:self];
    [gridView setDataSource:self];
    [gridView setBounces:YES];
    [gridView setBackgroundColor:[UIColor clearColor]];
    [gridView registerClass:[CMHomeViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:gridView];
    
    [CMServerHelper fetchAllTopics];
    dataArr = [CMDataProvider getAllCategoriesByFilter:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"Code Monk";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllTopics:)
                                                 name:UPDATED_ALL_TOPICS object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self setGradient];
    
    gridView.frame = self.view.frame;
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
                                                (id)[[CMUtils getAverageColorFromImage:appIcon] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:gradientView];
    [self.view sendSubviewToBack:gradientView];
}


#pragma mark - Collection View Helpers

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    
    if (indexPath.row == 0) {
        size = CGSizeMake(self.view.frame.size.width, 180);
    }
    else if (indexPath.row == (dataArr.count-1)){
        size = CGSizeMake(self.view.frame.size.width, 60);
    }
    else {
        size = CGSizeMake(self.view.frame.size.width/2.5, 90);
    }
    
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //NSLog(@"dataArr.count : %lu",(unsigned long)dataArr.count);
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
    NSLog(@"didSelectItemAtIndexPath");
}

@end
