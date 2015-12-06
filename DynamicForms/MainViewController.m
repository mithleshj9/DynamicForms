//
//  ViewController.m
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/5/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#import "MainViewController.h"
#import "WidgetInfo.h"
#import "Defines.h"

#define JSON_FILE_NAME @"WidgetsInfo.json"

@interface MainViewController () {
    
}

@property (atomic, strong) NSError *widgetsInfoLoadingError;
@property (nonatomic, strong) NSArray *widgetsConfigurations;

- (void) widgetsInfoLoadingStarted;
- (void) widgetsInfoLoaded;
- (void) widgetsInfoLoadingFailed;


@end


@implementation MainViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoadingWidgetsInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void) setErrorWithDomain:(NSString*)domain code:(NSInteger)code {
    
    NSString * errorMessage = nil;
    switch (code) {
        case eFileNotFoundError:
            errorMessage = NSLocalizedString(@"The file containing widgets configuration is not found", @"File Not Found");
            break;
        case eNoConfigExists:
            errorMessage = NSLocalizedString(@"No widgets exist to show", @"Configuration not available");
            break;
        default:
            errorMessage = @"Unknown error";
            break;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
    self.widgetsInfoLoadingError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                       code:eFileNotFoundError
                                                   userInfo:userInfo];
}

- (NSData*) widgetInfoData {
    
    // Locate the widgets configuration file
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:JSON_FILE_NAME ofType:nil];
    if (jsonFilePath == nil) {
        [self setErrorWithDomain:NSCocoaErrorDomain code:eFileNotFoundError];
        return nil;
    }
    
    // Load Json data from the file.
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonFilePath];
    
    if (jsonData == nil || jsonData.length == 0) {
        // Widgets config file does not contain any data
        [self setErrorWithDomain:NSCocoaErrorDomain code:eNoConfigExists];
    }
    return jsonData;
}

- (WidgetInfo *) widgetInfoWithConfigDictionary:(NSDictionary*)configDict error:(NSError**)error {
    
    WidgetInfo *wI = [[WidgetInfo alloc] init];
    return wI;
}

- (void) invalidJsonFoundWithErrorDomain:(NSString*)domain {
    [self setErrorWithDomain:domain code:eInvalidJsonError];
    [self performSelectorOnMainThread:@selector(widgetsInfoLoadingFailed) withObject:nil waitUntilDone:YES];
}


#pragma mark - Public Methods
- (void) startLoadingWidgetsInfo {
    NSData *jsonData = [self widgetInfoData];
    
    if (jsonData == nil) {
        [self performSelectorOnMainThread:@selector(widgetsInfoLoadingFailed) withObject:nil waitUntilDone:YES];
        return;
    }
        
    NSError *error = nil;
    
    // The top level object must be an array. If it is not, we'll check if it's a dictionary of single widget entry and add it to a newly created array.
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (jsonObject == nil) {
        if (error != nil) {
            [self invalidJsonFoundWithErrorDomain:error.domain];
            return;
        }
    }
    
    if (![jsonObject isKindOfClass:[NSArray class]]) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = nil;
            WidgetInfo *wI = [self widgetInfoWithConfigDictionary:jsonObject error:&error];
            
            if (wI != nil)
                self.widgetsConfigurations = [NSArray arrayWithObject:wI];
            else {
                self.widgetsInfoLoadingError = error;
                [self performSelectorOnMainThread:@selector(widgetsInfoLoadingFailed) withObject:nil waitUntilDone:YES];
                return;
            }
                
        } else {
            // Anything other than array of dictionary at the top level is to be considered an invalid json
            [self invalidJsonFoundWithErrorDomain:NSCocoaErrorDomain];
            return;
        }
    } else {
        NSMutableArray *mArr = [NSMutableArray new];
        for (id object in jsonObject) {
             //Even if a single object is an invalid dictionary or a different type, we choose to report an error
            if (![object isKindOfClass:[NSDictionary class]]) {
                [self invalidJsonFoundWithErrorDomain:error.domain];
                return;
            } else {
                NSError *error = nil;
                WidgetInfo *wI = [self widgetInfoWithConfigDictionary:jsonObject error:&error];
                
                if (wI != nil)
                    [mArr addObject:wI];
                else {
                    self.widgetsInfoLoadingError = error;
                    [self performSelectorOnMainThread:@selector(widgetsInfoLoadingFailed) withObject:nil waitUntilDone:YES];
                    return;
                }

            }
            
        }
        self.widgetsConfigurations = [NSArray arrayWithArray:mArr];
        [self performSelectorOnMainThread:@selector(widgetsInfoLoaded) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - Extension methods

- (void) widgetsInfoLoadingStarted {
    [self.activityIndicator startAnimating];
    
    self.messageLabel.hidden = NO;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.text = NSLocalizedString(@"Initializing Form...", @"Initialization Message");
    
}

- (void) widgetsInfoLoaded {
    self.messageLabel.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void) widgetsInfoLoadingFailed {
    self.messageLabel.hidden = NO;
    
    // We don't take eNoConfigExists code as error and take it simply as no widgets available to display
    if (self.widgetsInfoLoadingError.code != eNoConfigExists)
        self.messageLabel.textColor = [UIColor redColor];
    else
        self.messageLabel.textColor = [UIColor lightGrayColor];
    
    if (self.widgetsInfoLoadingError.userInfo != nil)
        self.messageLabel.text = [self.widgetsInfoLoadingError.userInfo valueForKey:NSLocalizedDescriptionKey];
    else
        self.messageLabel.text = NSLocalizedString(@"An error occurred in reading form specification", @"Initialization Failed");
    
    [self.activityIndicator stopAnimating];
}


@end
