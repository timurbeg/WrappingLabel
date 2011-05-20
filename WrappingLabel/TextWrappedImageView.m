//
//  WrapLabel.m
//  WrappingLabel
//
//  Created by Timur Begaliev on 5/14/11.
//  Copyright 2011 DataSite Technologies. All rights reserved.
//

#import "TextWrappedImageView.h"


@implementation TextWrappedImageView

@synthesize height;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImageView:(UIImageView *)view frame:(CGRect)frame wrapText:(NSString *)text; {

    self = [super initWithFrame:frame];
    if (self) {
        
        imageView = [view retain];
        wrappingText = text;
        height = 0;
        
        self.backgroundColor = [UIColor clearColor];
        [self prepareLayout];
    }
    return self;
}

- (void)prepareLayout {
    
    layoutView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat origX = 0;
    CGFloat origY = 0;
    CGFloat sizeW = self.frame.size.width;
    CGFloat sizeH = self.frame.size.height;
    
    CGFloat imageViewWidth = imageView.frame.size.width;
    CGFloat imageViewHeight = imageView.frame.size.height;
    CGFloat proportion = imageView.image.size.width / imageView.image.size.height;
    CGFloat defaultProp = imageViewWidth / imageViewHeight;
    
    if (imageView.image.size.height < imageViewHeight && imageView.image.size.width < imageViewWidth) {
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        
    } else if (proportion < defaultProp) {
        
        imageViewWidth = imageViewHeight * proportion;
        [imageView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];        

    } else {
        
        imageViewHeight = imageViewWidth / proportion;
        [imageView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    }
    [layoutView addSubview:imageView];
    [imageView release];
    
    CGFloat textIndent = 5;
    CGFloat rightOrigX = imageViewWidth + textIndent;
    CGFloat widthOfWrapLabel = sizeW - rightOrigX;
    
    UILabel *rightWrapLabel = [self labelWithFrame:CGRectZero
                                          boldFont:NO fontName:@"Helvetica" fontSize:12.0f
                                         textColor:[UIColor blackColor] bgColor:[UIColor clearColor]
                                              text:wrappingText lines:0 lineBrMode:UILineBreakModeWordWrap
                                         textAlign:UITextAlignmentLeft];
    
    CGFloat realHeight = [self heightForLabel:rightWrapLabel withWidth:widthOfWrapLabel];
    rightWrapLabel.frame = CGRectMake(rightOrigX, origY, widthOfWrapLabel, realHeight);
    
    if (realHeight > imageViewHeight) {

        float numberOfLinesInWrapLabel = ceil(imageViewHeight / rightWrapLabel.font.leading);
        CGFloat roundedHeight = numberOfLinesInWrapLabel * rightWrapLabel.font.leading;
        CGSize leftSize = CGSizeMake(widthOfWrapLabel, roundedHeight);
        NSString *textOnRightSide = [self trimToWord:wrappingText sizeConstraints:leftSize withFont:rightWrapLabel.font];
        rightWrapLabel.text = textOnRightSide;
        rightWrapLabel.frame = CGRectMake(rightOrigX, origY, widthOfWrapLabel, roundedHeight);

         height += roundedHeight;

        NSString *bottomText = [wrappingText substringFromIndex:textOnRightSide.length];
        bottomText = [bottomText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        UILabel *bottomWrapLabel = [self labelWithFrame:CGRectZero 
                                               boldFont:NO fontName:@"Helvetica" fontSize:12.0f
                                              textColor:[UIColor blackColor] bgColor:[UIColor clearColor]
                                                   text:bottomText lines:0 lineBrMode:UILineBreakModeWordWrap
                                              textAlign:UITextAlignmentLeft];
        
        CGFloat limitedHeight = sizeH - roundedHeight - textIndent;
        if (limitedHeight > bottomWrapLabel.font.leading) {
            
            realHeight = [self heightForLabel:bottomWrapLabel withWidth:sizeW];
            
            if (realHeight > limitedHeight) {
                
                numberOfLinesInWrapLabel =  floor(limitedHeight / bottomWrapLabel.font.leading);
                realHeight = numberOfLinesInWrapLabel * bottomWrapLabel.font.leading;
            }
            
            [bottomWrapLabel setFrame:CGRectMake(origX, origY + roundedHeight, sizeW, realHeight)];
            [layoutView addSubview:bottomWrapLabel];
            
            height += realHeight;
        }
        
    } else {
        
        height += realHeight;
        rightWrapLabel.text = wrappingText;
    }
    
    layoutView.frame =  CGRectMake(0, 0, sizeW, height);
    [layoutView addSubview:rightWrapLabel];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

     [self addSubview:layoutView];
}

#pragma Helper methods

- (UILabel *)labelWithFrame:(CGRect)rect boldFont:(BOOL)bold fontName:(NSString *)name 
                   fontSize:(CGFloat)size textColor:(UIColor *)tColor bgColor:(UIColor *)bgColor 
                       text:(NSString *)text lines:(NSInteger)lines lineBrMode:(UILineBreakMode)lbMode
                  textAlign:(UITextAlignment)alignment {
	
	UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	UIFont *font = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont fontWithName:name size:size];
	[label setFont:font];
	[label setTextColor:tColor];
	[label setBackgroundColor:bgColor];
	[label setText:text];
	[label setNumberOfLines:lines];
	[label setLineBreakMode:lbMode];
	[label setTextAlignment:alignment];
    
	return label;
}

- (CGFloat)heightForLabel:(UILabel *)label withWidth:(CGFloat)width {
    
    CGSize expectedSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize realSize = [label.text sizeWithFont:label.font constrainedToSize:expectedSize
                                 lineBreakMode:label.lineBreakMode];
    
    return realSize.height;
}

- (NSString*)rewindOneWord:(NSString*)str {
    // rewind by one word
    NSRange lastspace = [str rangeOfString:@" " options:NSBackwardsSearch];
    if (lastspace.location != NSNotFound) {
        return [str substringToIndex:lastspace.location];
    } else {
        // no spaces, lets just rewind 2 characters at a time
        return [str substringToIndex:[str length] - 2];
    }
}

// returns only how much text it could render with the given stipulations   
- (NSString*)trimToWord:(NSString*)str sizeConstraints:(CGSize)availableSize withFont:(UIFont*)font {
    if(str == @"")
        return str;

    CGSize constrSize = CGSizeMake(availableSize.width, CGFLOAT_MAX);
    CGSize measured = [str sizeWithFont:font constrainedToSize:constrSize lineBreakMode:UILineBreakModeWordWrap];
    // 'guess' how much we will need to cut to save on processing time
    float choppedPercent = (((double)availableSize.height)/((double)measured.height));
    if(choppedPercent >= 1.0) {
        //entire string can fit in availableSize
        return str;
    }
    
    if (1 / choppedPercent > 1.2) {
        
        choppedPercent = (availableSize.height * 1.2) / measured.height;
        int endIndex = choppedPercent * [str length];
        str = [str substringToIndex:endIndex];
    }
    
    // rewind to the beginning of the word in case we are in the middle of one
    do {
        str = [self rewindOneWord:str];
        measured = [str sizeWithFont:font constrainedToSize:constrSize lineBreakMode:UILineBreakModeWordWrap];
    } while(measured.height > availableSize.height);
    
    return str;
}


- (void)dealloc
{
    [layoutView release];
    [super dealloc];
}

@end
