//
//  ValidateChileanRunTests.m
//  ValidateChileanRunTests
//
//  Created by Camilo Castro on 30-09-14.
//  Copyright (c) 2014 Cervezapps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CVZPChileanRUT.h"

@interface ValidateChileanRunTests : XCTestCase

@end

@implementation ValidateChileanRunTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  
    [CVZPChileanRUT setVerbose:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Test RUT Generators
- (void) testThatRUTGeneratorWorks {
  
  // Validation Closure
  void (^ doValidations) (NSString *);
  
  doValidations = ^ (NSString * rut) {
    XCTAssertNotNil(rut, @"Rut Should not be Nil");
    
    BOOL isValid = [CVZPChileanRUT isValidRUT:rut];
    
    XCTAssertTrue(isValid, @"Rut %@ format is not valid", rut);
  };
  
  // Test With Format
  NSString * rut = [CVZPChileanRUT createRandomRUTFormatted:YES];

  doValidations(rut);
  
  // Test Without Format
  rut = [CVZPChileanRUT createRandomRUTFormatted:NO];
  
  doValidations(rut);
  
}

- (void) testThatRUTGeneratorWorksWith10Ruts {
  
  
  int __block quantity = 10;
  
  // Validation Closure
  void (^ doValidations ) (NSArray *);
  
  doValidations = ^ (NSArray * ruts) {
    
    BOOL isValid = NO;
    
    XCTAssertNotNil(ruts, @"Rut array cannot be nil");
    
    XCTAssertTrue((ruts.count > 0), @"Rut array cannot be empty");
    
    XCTAssertTrue((ruts.count == quantity), @"Wrong Quantity Solicited %d Given %d", quantity, ruts.count);
    
    for (NSString * rut in ruts) {
      isValid = [CVZPChileanRUT isValidRUT:rut];
      XCTAssertTrue(isValid, @"Rut %@ format is not valid", rut);
    }
  };
  
  // Generate 10 RUTs Formatted
  
  NSArray * ruts = [CVZPChileanRUT createRandomRUTFormatted:YES withQuantity:quantity];
  
  doValidations(ruts);
  
  // Generate 10 RUTs Not Formatted
  
  ruts = [CVZPChileanRUT createRandomRUTFormatted:NO withQuantity:quantity];
  
  doValidations(ruts);
  
}


#pragma mark - Formatting Rut Test Methods
- (void) testThatRutIsFormattedWhenEmptyString {
  
  XCTAssertNoThrow([CVZPChileanRUT formatRUT:nil withDigit:YES], @"Exception Throw when Nil");
  
  XCTAssertNoThrow([CVZPChileanRUT formatRUT:@"" withDigit:NO], @"Exception Throw when Empty");
  
}

- (void) testThatRutIsFormattedWithDigit {
  NSString * rut = @"123456789";
  
  NSString * formatted = [CVZPChileanRUT formatRUT:rut withDigit:YES];
  
  NSString * digit = [formatted substringFromIndex:formatted.length - 1];
  
  NSString * compare = @"9";
  
  XCTAssertEqualObjects(digit, compare, @"Given %@, Got %@, Digits are different", compare, digit);
}

- (void) testThatRutIsFormattedWithoutDigit {
  // Calculate Digit
  NSString * rut = @"123456789";
  
  NSString * formatted = [CVZPChileanRUT formatRUT:rut withDigit:NO];
  
  NSString * digit = [formatted substringFromIndex:formatted.length - 1];
  
  NSString * compare = @"5";
  
  XCTAssertEqualObjects(digit, compare, @"Given %@, Got %@, Digits are different", compare, digit);
}

- (void) testThatRutIsFormatted {
  NSString * rut = @"123456789";
  
  NSString * formatted = [CVZPChileanRUT formatRUT:rut withDigit:YES];
  
  NSString * correct = @"12.345.678-9";
  
  XCTAssertEqualObjects(formatted, correct, @"Formatter did not formatted well, input %@ expected %@ result %@", rut, correct, formatted);
}

- (void) testThatRutIsUnformatted {
  NSString * rut = @"12. 345. 67 8- 9  ";
  
  NSString * unformatted = [CVZPChileanRUT removeFormat:rut];
  
  XCTAssertEqualObjects(unformatted, @"123456789", @"Format remover does not remove dots,  dashes or spaces in %@", rut);
}

#pragma mark - isValid Rut Test Methods
- (void) testThatRutIsValid {
  
  NSString * rut = @"214748364816";
  
  XCTAssertTrue([CVZPChileanRUT isValidRUT:rut], @"Rut %@ is not valid, should be", rut);
  
}

- (void) testThatRutIsNotValid {
  
  NSString * rut = @"214748364818";
  
  XCTAssertFalse([CVZPChileanRUT isValidRUT:rut], @"Rut %@ is valid, should not", rut);
  
}

#pragma mark - isValid Digit Test Methods

- (void) testThatDigitIsValid {
  
  NSArray * validChars = @[@"0", @"1", @"2", @"3", @"4",
                           @"5", @"6", @"7", @"8", @"9",
                           @"k", @"K"];
  
  
  BOOL isValid = NO;
  
  NSString * lastDigit;
  
  for (NSString * digit in validChars) {
    isValid  = [CVZPChileanRUT isValidDigit:digit];
    
    lastDigit = digit;
    
    // Break on false
    if (!isValid)
      break;
  }
  
  
  XCTAssertTrue(isValid, @"Digit %@ must be valid, but test says is invalid", lastDigit);
  
}

- (void) testThatDigitIsNotValid {

  NSArray * invalidChars = @[@"-1", @"J", @"001", @"asdf",@"42", @"", @" "];
  
  
  BOOL isValid = YES;
  
  NSString * lastDigit;
  
  for (NSString * digit in invalidChars) {
    isValid  = [CVZPChileanRUT isValidDigit:digit];
    
    lastDigit = digit;
    
    // Break on true
    if (isValid)
      break;
  }
  
  XCTAssertFalse(isValid, @"Digit %@ must be invalid, but test says is valid", lastDigit);
}

- (void) testThatDigitCorrespondsWithTheRUT {
  NSString * rut = @"123456785";
  
  NSString * digit = @"9";
  NSString * validDigit = @"5";
  

  BOOL isValid = [CVZPChileanRUT isValidRUT:rut withDigit:digit];
  
  XCTAssertFalse(isValid, @"Digit is Valid, but shouldn't");
  
  isValid = [CVZPChileanRUT isValidRUT:rut withDigit:validDigit];
  
  XCTAssertTrue(isValid, @"Digit is not valid, but should");
  
}


@end
