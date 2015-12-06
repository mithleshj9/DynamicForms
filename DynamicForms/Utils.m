//
//  Utils.m
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/6/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) showAlertMessage: (NSString*)msg
                withTitle:(NSString*)title firstButton:(NSString*)firstBtn
             SecondButton:(NSString*)secondBtn
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:firstBtn
                                              otherButtonTitles:secondBtn, nil];
    [alertView show];
}

@end
