//
//  CMHomeViewCell.m
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMHomeViewCell.h"
#import "CMUtils.h"

@implementation CMHomeViewCell
@synthesize titleLab;

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.numberOfLines = 2;
        titleLab.font = FONT_LRG;
        titleLab.textColor = [UIColor blackColor];
        titleLab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLab];
        
        self.backgroundColor = [CMUtils getAverageColorFromImage:appIcon];
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        UIBezierPath *shadow = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor   = [UIColor blackColor].CGColor;
        self.layer.shadowOffset  = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath    = shadow.CGPath;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    titleLab.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor lightGrayColor];
    self.selectedBackgroundView = bgView;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    titleLab.text = nil;
}

@end
