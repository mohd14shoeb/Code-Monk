//
//  CMTopicDetailsVC.m
//  Code Monk
//
//  Created by yogesh singh on 21/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMTopicDetailsVC.h"

#import "DZNSegmentedControl.h"
#import "CMServerHelper.h"
#import "CMUtils.h"

@interface CMTopicDetailsVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *table;

@end

@implementation CMTopicDetailsVC
@synthesize topicObj, titleStr;
@synthesize webView, table;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] init];
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    if ([topicObj.isBookmarked boolValue]) {    //load from local db
        [webView loadHTMLString:topicObj.note baseURL:nil];
    }
    else{   //fetch from server
        int idValue = [topicObj.idValue intValue];
        [CMServerHelper fetchDetailsOfTopic:[NSNumber numberWithInt:idValue]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedDetailsOfTopic:)
                                                 name:UPDATED_TOPIC_DETAILS object:nil];
    self.navigationItem.title = titleStr;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    webView.frame = self.view.frame;
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

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
