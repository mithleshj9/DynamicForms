//
//  WidgetInfo.m
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/6/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#import "WidgetInfo.h"

@implementation WidgetInfo

- (instancetype) initWithConfigDictionary:(NSDictionary*)configDictionary {

    self = [super init];
    if (self) {
        
    }
    
    return self;
}

+ (BOOL) validateConfigDictionary:(NSDictionary*)dictionary error:(NSError**)error {
    
    /**
     Rules for validation
        1) Check if the values of the known configuration keys are valid
        2) Check if the value of validation rules key is a dictionary and validate the dictionary.
        3) If some of the keys are not present, the dictionary is still valid.
        4) If there are some extraneous key/value pairs, we ignore it but don't report it as invalid dictionary.
     */
    return YES;
}


@end
