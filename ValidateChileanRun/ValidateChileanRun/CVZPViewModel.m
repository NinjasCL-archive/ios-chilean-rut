//
//  CVZPViewModel.m
//  ValidateChileanRun
//
//  Created by Camilo Castro on 02-10-14.
//  Copyright (c) 2014 Cervezapps. All rights reserved.
//

#import "CVZPViewModel.h"
#import "CVZPChileanRUT.h"

@implementation CVZPViewModel

- (void) setRut:(NSString *)rut {
  _rut = [CVZPChileanRUT removeFormat:rut];
}

- (RACSignal *) isValidRUTSignal {

  return [RACSignal
          combineLatest:@[RACObserve(self, rut)] reduce:^id(NSString * rut){
            return @([CVZPChileanRUT isValidRUT:rut]);
          }];
}

- (RACSignal *) formattedRUTSignal {
  return [RACSignal combineLatest:@[[RACObserve(self, rut) distinctUntilChanged]] reduce:^id(NSString * rut){
    
    return [CVZPChileanRUT formatRUT:rut withDigit:YES];
  }];
}
@end
