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
#import <CoreText/CTFramesetter.h>
#import <CoreText/CTParagraphStyle.h>
#import <CoreText/CTStringAttributes.h>
#import <Foundation/NSDictionary.h>

// Comment this out to hide guidelines
#define SHOW_GUIDLINES 1

@interface RootViewController ()

-(UIImage *)imageFromCATextLayer:(CATextLayer *)layer andPaddingSize:(CGSize)paddingSize;

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
    CGRect viewRect = CGRectMake(50.0f, 50.0f, 92.0f, 95.0f);
    
    NSString *text = @"\n aaaa \n";
    UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:22.0f];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationNone;
    textLayer.string = text;
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
    
    // Create "padded" images
    
    UIImage *textImage2 = [self imageFromCATextLayer:textLayer andPaddingSize:CGSizeMake(10.0f, 10.0f)];
    UIImageView *textImageView2 = [[UIImageView alloc] initWithImage:textImage2];
    textImageView2.frame = CGRectMake(40.0f, 340.0f, 110.0f, 114.0f);
    [self.view addSubview:textImageView2];
    UIImageView *textImageView3 = [[UIImageView alloc] initWithImage:textImage2];
    textImageView3.frame = CGRectMake(440.0f, 40.0f, 110.0f, 114.0f);
    [self.view addSubview:textImageView3];
    
#ifdef SHOW_GUIDLINES
    // Use these guidelines to test alignment
    UIColor *guidelineColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.5f];
    
    UIView *topGuideline = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, 768.0f, 10.0f)];
    topGuideline.backgroundColor = guidelineColor;
    [self.view addSubview:topGuideline];
    
    UIView *leftGuideline = [[UIView alloc] initWithFrame:CGRectMake(46.0f, 0.0f, 10.0f, 1024.0f)];
    leftGuideline.backgroundColor = guidelineColor;
    [self.view addSubview:leftGuideline];
    
    UIView *bottomGuideline = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 92.0f, 768.0f, 10.0f)];
    bottomGuideline.backgroundColor = guidelineColor;
    [self.view addSubview:bottomGuideline];
    
    UIView *rightGuideline = [[UIView alloc] initWithFrame:CGRectMake(105.0f, 0.0f, 10.0f, 1024.0f)];
    rightGuideline.backgroundColor = guidelineColor;
    [self.view addSubview:rightGuideline];
#endif
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

-(UIImage *)imageFromCATextLayer:(CATextLayer *)layer andPaddingSize:(CGSize)paddingSize
{
    CGFloat paddingWidth = paddingSize.width;
    CGFloat paddingHeight = paddingSize.height;
    CGRect textBounds = layer.frame;
    CGRect paddedImageBounds = CGRectMake(0.0f, 0.0f, textBounds.size.width + 2 * paddingWidth, textBounds.size.height + 2 * paddingHeight);
	UIGraphicsBeginImageContextWithOptions(paddedImageBounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0f, paddedImageBounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGContextSetFillColorWithColor(context, layer.backgroundColor);
    CGContextFillRect(context, paddedImageBounds);
    
    CTTextAlignment alignment;
    if ([layer.alignmentMode isEqualToString: kCAAlignmentLeft]) {
        alignment = kCTLeftTextAlignment;
    }
    else if ([layer.alignmentMode isEqualToString: kCAAlignmentCenter]) {
        alignment = kCTCenterTextAlignment;
    }
    else if ([layer.alignmentMode isEqualToString: kCAAlignmentRight]) {
        alignment = kCTRightTextAlignment;
    }
    else {
        alignment = kCTLeftTextAlignment;
    }
    
    CTParagraphStyleSetting paragraphSettings = {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(&paragraphSettings, 1);
    
    CFStringRef fontName = CTFontCopyFullName(layer.font);
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontName, layer.fontSize, nil);
    CFRelease(fontName);
    
    CFDictionaryValueCallBacks cbs = {0, NULL, NULL, NULL, NULL};
    CFMutableDictionaryRef cfdict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &cbs);
    CFDictionarySetValue(cfdict, kCTFontAttributeName, fontRef);
    CFDictionarySetValue(cfdict, kCTParagraphStyleAttributeName, paragraphStyle);
    CFDictionarySetValue(cfdict, kCTForegroundColorAttributeName, layer.foregroundColor);
    NSMutableDictionary *dict = (__bridge NSMutableDictionary *)cfdict;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:layer.string attributes:dict];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGMutablePathRef p = CGPathCreateMutable();
    CGPathAddRect(p, NULL, CGRectMake(paddingWidth, paddingHeight+ 0.25 * layer.fontSize, textBounds.size.width, textBounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,0), p, NULL);
    CTFrameDraw(frame, context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	return image;
}

@end
