//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *labelUsername;
@property (nonatomic, retain) UILabel *labelSeptext;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize labelUsername = _labelUsername;
@synthesize labelSeptext = _labelSeptext;
@synthesize date = _date;

+ (CGFloat)height
{
    return 50.0;
}

- (void)setDate:(NSDate *)value
{
    if (self.label)
    {
        self.label.text = [commonUtils dateToString:value dateFormat:@"hh:mm a"];
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, [UIBubbleHeaderTableViewCell height] / 3, [[UIScreen mainScreen] bounds].size.width - 30, [UIBubbleHeaderTableViewCell height] / 3)];
    self.label.text = [commonUtils dateToString:value dateFormat:@"hh:mm a"];
//    self.label.font = [UIFont systemFontOfSize:12];
    self.label.font = [UIFont fontWithName:@"Averta-Regular" size:13];

    if (self.type >= 0) {
        self.label.textAlignment = NSTextAlignmentLeft;
    }
    else {
        self.label.textAlignment = NSTextAlignmentRight;
    }
//    self.label.shadowOffset = CGSizeMake(0, 1);
//    self.label.shadowColor = [UIColor whiteColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    
}

- (void)setUsername:(NSString *)username
{
    if (self.labelUsername)
    {
        self.labelUsername.text = username;
        return;
    }
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelUsername = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [[UIScreen mainScreen] bounds].size.width - 30, [UIBubbleHeaderTableViewCell height] / 3)];
    self.labelUsername.text = username;
//    self.labelUsername.font = [UIFont boldSystemFontOfSize:13];
    self.labelUsername.font = [UIFont fontWithName:@"Averta-Regular" size:13];

    if (self.type >= 0) {
        self.labelUsername.textAlignment = NSTextAlignmentLeft;
    }
    else {
        self.labelUsername.textAlignment = NSTextAlignmentRight;
    }
//    self.labelUsername.shadowOffset = CGSizeMake(0, 1);
//    self.labelUsername.shadowColor = [UIColor whiteColor];
    self.labelUsername.textColor = [UIColor whiteColor];
    self.labelUsername.backgroundColor = [UIColor clearColor];
    [self addSubview:self.labelUsername];
}


- (void)setType:(int)type
{
//    self.type = type;
    if (self.labelUsername)
    {
        if (type == 1) {
            self.labelUsername.textAlignment = NSTextAlignmentLeft;
        }
        else {
            self.labelUsername.textAlignment = NSTextAlignmentRight;
        }
        
    }
    if (self.label)
    {
        if (type == 1) {
            self.label.textAlignment = NSTextAlignmentLeft;
        }
        else {
            self.label.textAlignment = NSTextAlignmentRight;
        }
        
    }
}

- (void)setSeptext:(NSString *)septext
{
    
    if (self.labelSeptext)
    {
        self.labelSeptext.text = septext;
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelSeptext = [[UILabel alloc] initWithFrame:CGRectMake(100, [UIBubbleHeaderTableViewCell height] / 4, [[UIScreen mainScreen] bounds].size.width - 200, [UIBubbleHeaderTableViewCell height] / 2)];
    
    self.labelSeptext.text = septext;
//    self.labelSeptext.font = [UIFont boldSystemFontOfSize:13];
    self.labelSeptext.font = [UIFont fontWithName:@"Averta-Regular" size:13];

    self.labelSeptext.textAlignment = NSTextAlignmentCenter;
    
//    self.labelSeptext.shadowOffset = CGSizeMake(0, 1);
//    self.labelSeptext.shadowColor = COLOR_GRAY;
    self.labelSeptext.textColor = [UIColor whiteColor];
    self.labelSeptext.backgroundColor = [UIColor clearColor];
    self.labelSeptext.layer.borderColor = [[UIColor grayColor] CGColor];
    self.labelSeptext.layer.borderWidth = 1;
    self.labelSeptext.layer.cornerRadius = [UIBubbleHeaderTableViewCell height] / 8;
    [self addSubview:self.labelSeptext];
    
}


@end
