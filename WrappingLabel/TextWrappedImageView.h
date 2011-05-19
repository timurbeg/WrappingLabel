//
//  WrapLabel.h
//  WrappingLabel
//
//  Created by Timur Begaliev on 5/14/11.
//  Copyright 2011 DataSite Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextWrappedImageView : UIView {

    UIView *layoutView;
    
    UIImageView *imageView;
    NSString *wrappingText;
    
    NSInteger height;
}

@property (nonatomic, assign) NSInteger height;

- (id)initWithImageView:(UIImageView *)view frame:(CGRect)frame wrapText:(NSString *)text;
- (void)prepareLayout;

- (UILabel *)labelWithFrame:(CGRect)rect boldFont:(BOOL)bold fontName:(NSString *)name 
                   fontSize:(CGFloat)size textColor:(UIColor *)tColor bgColor:(UIColor *)bgColor 
                       text:(NSString *)text lines:(NSInteger)lines lineBrMode:(UILineBreakMode)lbMode
                  textAlign:(UITextAlignment)alignment;

- (CGFloat)heightForLabel:(UILabel *)label withWidth:(CGFloat)width;

- (NSString*)rewindOneWord:(NSString*)str;
- (NSString*)trimToWord:(NSString*)str sizeConstraints:(CGSize)availableSize withFont:(UIFont*)font;

@end
