//
//  CVZPViewModel.h
//  ValidateChileanRun
//
//  Created by Camilo Castro on 02-10-14.
//  Copyright (c) 2014 Cervezapps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface CVZPViewModel : NSObject

@property (nonatomic) NSString * rut;

- (RACSignal *) isValidRUTSignal;

- (RACSignal *) formattedRUTSignal;

@end
