//
//  Together_Auth_Phone.m
//  TaxiTogether
//
//  Created by Fragarach on 7/31/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Together_Auth_Phone.h"


@implementation Together_Auth_Phone
@synthesize phone, toolbar, prevnext, done;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
