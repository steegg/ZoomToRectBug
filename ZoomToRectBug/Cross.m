//
//  Cross.m
//  ZoomToRectBug
//
//  Created by Steve Greenwood on 20/11/2012.
//  Copyright (c) 2012 Alano Consulting Ltd. All rights reserved.
//

#import "Cross.h"

@implementation Cross

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];    // previously clearColor
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    //    NSLog(@"Cross drawRect rect: %@", NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Set the stroke colour to be BLACK
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);

    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextMoveToPoint(context, 0.0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, 0.0);

	CGContextSetLineWidth(context, 4.0);
    CGContextStrokePath(context);
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    // clean up drawing environment
    UIImageView *box = [[UIImageView alloc] initWithImage:outputImage];
    box.frame = rect;
}

@end


