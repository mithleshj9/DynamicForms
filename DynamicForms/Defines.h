//
//  Defines.h
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/6/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#ifndef DynamicForms_Defines_h
#define DynamicForms_Defines_h

// Control Properties
extern NSString *const kWidgetName;
extern NSString *const kInputType;
extern NSString *const kHint;
extern NSString *const kText;
extern NSString *const kAction;

// Validation rules
extern NSString *const kValidationRules;
extern NSString *const kMinLength;
extern NSString *const kMaxLength;
extern NSString *const kRequired;
extern NSString *const kErrorMessage;
extern NSString *const kCheckValidity;



extern NSString *const kEditText;
extern NSString *const kTextCapWords;
extern NSString *const kTextEmailAddress;


enum {
    eFileNotFoundError = 1,
    eNoConfigExists,
    eInvalidJsonError
};

typedef enum {
    eWidgetTextField = 0,
    eWidgetButton,
    eWidgetSwitch
    
}EWidget;

#endif
