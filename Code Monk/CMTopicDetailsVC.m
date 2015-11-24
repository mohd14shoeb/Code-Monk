//
//  CMTopicDetailsVC.m
//  Code Monk
//
//  Created by yogesh singh on 21/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMTopicDetailsVC.h"
#import "CMServerHelper.h"
#import "CMExampleDetailsVC.h"
#import "CMDataParser.h"
#import "CMUtils.h"

@interface CMTopicDetailsVC () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIBarButtonItem *bookmarkBtn;
}

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArr;

@end

NSString *exampleCell = @"exampleCell";

@implementation CMTopicDetailsVC
@synthesize topicObj, dataArr;
@synthesize segmentControl, webView, table;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[@"Note", @"Examples"];
    segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.tintColor = [CMUtils getAverageColorFromImage:appIcon];
    segmentControl.backgroundColor = [UIColor whiteColor];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:FONT_MED}
                                  forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Futura-Medium" size:20]}
                                  forState:UIControlStateSelected];
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    webView = [[UIWebView alloc] init];
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.hidden = NO;
    [self.view addSubview:webView];
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor whiteColor];
    table.hidden = YES;
    [self.view addSubview:table];
    
    BOOL shouldUseCache = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shouldCacheServerResponses"] boolValue];
    
    //fetch topic details
    if ([topicObj.hasDetails boolValue] && shouldUseCache) {    //load from local db
        [webView loadHTMLString:topicObj.note baseURL:nil];
    }
    else{   //fetch from server
        int idValue = [topicObj.idValue intValue];
        [CMServerHelper fetchDetailsOfTopic:[NSNumber numberWithInt:idValue]];
    }
    
    //fetch example details
    if (topicObj.examples.count == 0) { //fetch from server
        int idValue = [topicObj.idValue intValue];
        [CMServerHelper fetchExampleListsOfTopic:[NSNumber numberWithInt:idValue]];
    }
    else{   //load from local db
        dataArr = [topicObj.examples sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"idValue" ascending:YES]]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedDetailsOfTopic:)
                                                 name:UPDATED_TOPIC_DETAILS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedExamplesOfTopic:)
                                                 name:UPDATED_EXAMPLES_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicBookmarkToggled:)
                                                 name:BOOKMARK_TOGGLED object:nil];
    
    self.navigationItem.title = topicObj.title;
    
    bookmarkBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:([topicObj.isBookmarked boolValue]) ?
                                                                            @"bookmarked" : @"bookmark"]
                                                   style:UIBarButtonItemStylePlain target:self action:@selector(toggleBookmark:)];

    UIBarButtonItem *shareBtn =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self action:@selector(shareSelected:)];
    
    self.navigationItem.rightBarButtonItems = @[shareBtn, bookmarkBtn];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    segmentControl.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 45);
    
    CGRect availableFrame = CGRectMake(0, segmentControl.frame.origin.y + segmentControl.frame.size.height, self.view.frame.size.width,
                                       self.view.frame.size.height - (segmentControl.frame.origin.y + segmentControl.frame.size.height));
    
    webView.frame = availableFrame;
    
    table.frame = availableFrame;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Data Helpers

- (void)fetchedDetailsOfTopic:(NSNotification *)notification{
    
    topicObj = [notification.userInfo valueForKey:@"topicObject"];
    [webView loadHTMLString:topicObj.note baseURL:nil];
}

- (void)fetchedExamplesOfTopic:(NSNotification *)notification{
    
    topicObj = [notification.userInfo valueForKey:@"topicObject"];
    dataArr = [topicObj.examples sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"idValue" ascending:YES]]];
    [table reloadData];
}

- (void)toggleBookmark:(id)sender{
    
    int idValue = [topicObj.idValue intValue];
    [CMDataParser toggleBookmarkOfTopic:[NSNumber numberWithInt:idValue]];
}

- (void)topicBookmarkToggled:(NSNotification *)notification{
    topicObj = [notification.userInfo valueForKey:@"topicObject"];
    bookmarkBtn.image = [UIImage imageNamed:([topicObj.isBookmarked boolValue]) ? @"bookmarked" : @"bookmark"];
}


#pragma mark - UI Helpers

- (void)selectedSegment:(UISegmentedControl *)controller{

    table.hidden = (segmentControl.selectedSegmentIndex == 0);
    webView.hidden = !table.hidden;
}

- (void)shareSelected:(id)sender{
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[topicObj.link]
                                                        applicationActivities:nil];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exampleCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:exampleCell];
    }
    
    if (indexPath.row < dataArr.count) {
        Example *example = dataArr[indexPath.row];
        cell.textLabel.text = example.title;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < dataArr.count) {
        CMExampleDetailsVC *exampleDetailVC = [[CMExampleDetailsVC alloc] init];
        exampleDetailVC.topicObj = topicObj;
        exampleDetailVC.exampleObj = dataArr[indexPath.row];
        [self.navigationController pushViewController:exampleDetailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
