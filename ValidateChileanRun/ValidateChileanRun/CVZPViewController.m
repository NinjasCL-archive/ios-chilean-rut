//
//  CVZPViewController.m
//  ValidateChileanRun
//
//  Created by Camilo Castro on 30-09-14.
//  Copyright (c) 2014 Cervezapps. All rights reserved.
//

#import "CVZPViewController.h"
#import "CVZPChileanRUT.h"
#import "CVZPViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface CVZPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *rut1;

@property (weak, nonatomic) IBOutlet UITextField *rut2;

@property (weak, nonatomic) IBOutlet UILabel *isValid;


@property (nonatomic) CVZPViewModel * viewModel;

@end

@implementation CVZPViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  // Reactive Cocoa is Needed for AutoFormat
  // on key press, but the library is standalone
  
  // Create View Model
  self.viewModel = [CVZPViewModel new];
  
  // Bind Properties
  RAC(self.rut2, text) = [RACObserve(self.viewModel, rut) distinctUntilChanged];

  @weakify(self);
  
   [[self.rut2.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString * rut) {
     
     @strongify(self);
     
     self.viewModel.rut = rut;
  }];
  
  // Validate on change
  [[self.viewModel.isValidRUTSignal distinctUntilChanged] subscribeNext:^(NSNumber * isValid) {
    
    @strongify(self);
    
    
    self.isValid.text = ([isValid boolValue] ? @"RUT is Valid": @"RUT is not Valid");
  }];
  
  [[self.viewModel.formattedRUTSignal distinctUntilChanged] subscribeNext:^(NSString * rut) {
    NSLog(@"%@", rut);
  }];
  
}

- (IBAction)formatRut1:(id)sender {
  self.rut1.text = [CVZPChileanRUT formatRUT:self.rut1.text withDigit:YES];
}


@end
