//
//  CMExampleDetailsVC.m
//  Code Monk
//
//  Created by yogesh singh on 23/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMExampleDetailsVC.h"
#import "CMServerHelper.h"
#import "CMDataParser.h"
#import "CMUtils.h"

@interface CMExampleDetailsVC () <UIWebViewDelegate> {
    UIBarButtonItem *bookmarkBtn;
}

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CMExampleDetailsVC
@synthesize topicObj, exampleObj;
@synthesize segmentControl, webView;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[@"Statement", @"Solution"];
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
    
    if ([exampleObj.hasDetails boolValue]) {    //load from local db
        [webView loadHTMLString:exampleObj.statement baseURL:nil];
    }
    else{   //fetch from server
        int exampleID = [exampleObj.idValue intValue];
        int topicID = [topicObj.idValue intValue];
        
        [CMServerHelper fetchDetailsOfExample:[NSNumber numberWithInt:exampleID] ofTopic:[NSNumber numberWithInt:topicID]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedDetailsOfExample:)
                                                 name:UPDATED_EXAMPLE_DETAILS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicBookmarkToggled:)
                                                 name:BOOKMARK_TOGGLED object:nil];
    
    self.navigationItem.title = exampleObj.title;
    
    bookmarkBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:([exampleObj.isBookmarked boolValue]) ?
                                                          @"bookmarked" : @"bookmark"]
                                                   style:UIBarButtonItemStylePlain target:self action:@selector(toggleBookmark:)];
    
    UIBarButtonItem *shareBtn =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self action:@selector(shareSelected:)];
    
    self.navigationItem.rightBarButtonItems = @[shareBtn, bookmarkBtn];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    segmentControl.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 45);
    
    webView.frame = CGRectMake(0, segmentControl.frame.origin.y + segmentControl.frame.size.height, self.view.frame.size.width,
                               self.view.frame.size.height - (segmentControl.frame.origin.y + segmentControl.frame.size.height));
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Helpers

- (void)fetchedDetailsOfExample:(NSNotification *)notification{

    topicObj = [notification.userInfo valueForKey:@"topicObject"];
    exampleObj = [notification.userInfo valueForKey:@"exampleObject"];
    
    [webView loadHTMLString:(segmentControl.selectedSegmentIndex == 0) ? exampleObj.statement : exampleObj.solution
                    baseURL:nil];
}

- (void)selectedSegment:(UISegmentedControl *)controller{
    
    [webView loadHTMLString:(segmentControl.selectedSegmentIndex == 0) ? exampleObj.statement : exampleObj.solution
                    baseURL:nil];
}

- (void)toggleBookmark:(id)sender{
    
    int topicID = [topicObj.idValue intValue];
    int exampleID = [exampleObj.idValue intValue];
    [CMDataParser toggleBookmarkOfExample:[NSNumber numberWithInt:exampleID] forTopic:[NSNumber numberWithInt:topicID]];
}

- (void)topicBookmarkToggled:(NSNotification *)notification{
    
    exampleObj = [notification.userInfo valueForKey:@"exampleObject"];
    bookmarkBtn.image = [UIImage imageNamed:([exampleObj.isBookmarked boolValue]) ? @"bookmarked" : @"bookmark"];
}

- (void)shareSelected:(id)sender{
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[exampleObj.link]
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

@end
