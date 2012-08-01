//
//  RootViewController.m
//  CoreTextCharacterCutoff
//
//  Created by Dan on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CTFont.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect viewRect = CGRectMake(50.0f, 50.0f, 345.0f, 120.0f);
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationNone;
    UIFont *font = [UIFont fontWithName:@"SnellRoundhand" size:20.0f];
    textLayer.string = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    textLayer.font = fontRef;
    CFRelease(fontRef);
    
    textLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    textLayer.foregroundColor = [[UIColor blackColor] CGColor];
    textLayer.frame = viewRect;
    
    
    UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, NO, 0);
    [textLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:textImage];
    textImageView.frame = viewRect;
    [self.view addSubview:textImageView];
    
    // Changing to a UILabel doesn't help
    
    CGRect labelRect = CGRectMake(50.0f, 200.0f, 345.0f, 120.0f);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";
    label.adjustsFontSizeToFitWidth = NO;
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentLeft;
    label.font = font;
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor blackColor];
    // Can't verically align a UILabel, so do this instead
    [label sizeToFit];
    [self.view addSubview:label];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
