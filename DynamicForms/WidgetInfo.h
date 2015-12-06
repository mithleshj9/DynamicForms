//
//  WidgetInfo.h
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/6/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetInfo : NSObject

- (instancetype) initWithConfigDictionary:(NSDictionary*)configDictionary;

+ (BOOL) validateConfigDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
