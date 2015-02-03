//
//  CVZPChileanRUT.m
//  Created by Camilo Castro on 30-09-14.
//  Copyright (c) 2014 Cervezapps.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Camilo Castro
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "CVZPChileanRUT.h"

// Static Var for Verbose Output
static BOOL _verbose = NO;

@implementation CVZPChileanRUT

#pragma mark - Abstract Methods

/*!
 * Verbose Output for all methods
 * @param verbose
 */
+ (void) setVerbose: (BOOL) verbose {
  _verbose = verbose;
}

/*!
 * Generate a Valid Random RUT
 * @param BOOL formatted set if the generated RUT must be formatted
 * @return NSString Valid RUT
 */
+ (NSString *) createRandomRUTFormatted: (BOOL) formatted {
  
  if (_verbose)
    NSLog(@"Creating Random Rut %@", (formatted ? @"Formatted" : @""));
    

  NSInteger number = round(arc4random() * (25000000 - 5000000)) + 5000000;
  
  NSString * rut = [NSString stringWithFormat:@"%ld", (long) number];
  
  NSString * digit = [[self class] getDigit:rut];
  
  NSString * formattedRut = [NSString stringWithFormat:@"%@%@", rut, digit];
    
  if (formatted) {
    formattedRut =  [[self class] formatRUT:formattedRut withDigit:YES];
  }
  
  if (_verbose)
    NSLog(@"Created with Number %ld, Digit %@, Formatted %@", (long) number, digit, formattedRut);

  return formattedRut;
}

/*!
 * Generate a quantity of Valid Random RUT
 * @param BOOL formatted set if the generated RUT must be formatted
 * @param NSInteger quantity of generated Random RUT
 * @return NSArray of Valid NSString RUT
 */
+ (NSArray *) createRandomRUTFormatted:(BOOL)formatted withQuantity: (NSInteger) quantity {

  NSMutableArray * ruts = [@[] mutableCopy];
  
  for (int i = 0; i < quantity; i++) {
    [ruts addObject:[[self class] createRandomRUTFormatted:formatted]];
  }
  
  return [ruts copy];
}


#pragma mark Formatting Methods


/*!
 * Format a Number String to RUT Format
 * Example '123456789' => '12.345.678-9'
 * @param NSString rut
 * @param BOOL withDigit
 * @return NSString Formatted RUT
 */
+ (NSString *) formatRUT : (NSString *) rut withDigit : (BOOL) withDigit {
  
  if (_verbose)
    NSLog(@"Start Formatting RUT %@", rut);
  
  
  rut = [[self class] removeFormat:rut];
  
  // End function if empty or nil
  if (!rut || [rut isEqualToString:@""]) {

    if (_verbose)
      NSLog(@"Could not format %@", rut);
    
    return @"";
  }
  
  // Substring Closure
  NSString * ( ^ substring ) (NSString *, NSInteger , NSInteger);
  
  substring = ^(NSString * string, NSInteger from, NSInteger to) {
    
    NSString * digit = @"";
    NSMutableString * sub = [@"" mutableCopy];
    
    for (NSInteger i = from; i < to; i++) {
      digit = [NSString stringWithFormat:@"%c", [string characterAtIndex:i]];
      [sub appendString:digit];
    }
    
    if (_verbose)
      NSLog(@"Substring %@ From %ld To %ld Result %@ ", string, from, to, sub);
    
    return sub;
  };
  
  // Get Digit
  // from String
  // and create something like -8
  // Using Module 11 method for get the correct digit

  NSString * formattedRut;
  
  
  // If digit is included in the string
  // we do not need to calculate it
  if (withDigit)
    
    // Get the last digit
     formattedRut = [NSString stringWithFormat:@"-%@", [rut substringFromIndex:rut.length - 1]];
  else
   
    // Calculate it
     formattedRut = [NSString stringWithFormat:@"-%@", [[self class] getDigit:[rut substringToIndex:rut.length - 1]]];
  
  
  // We need to know when
  // put the dots
  int counter = 0;
  
  // Now iterate over string from
  // the last 2 characters to the beginning of the string
  // this is needed so does not put a point
  // at the beginning of the string
  for (NSInteger i = (rut.length - 2); i >= 0; i--) {
    
    // Get a specific character
    // from end to the begining of the string
    // Example
    // Substring 214748364818 From 5 To 6 Result 8
    // Substring 214748364818 From 4 To 5 Result 4

    formattedRut = [NSString stringWithFormat:@"%@%@", substring(rut, i, i + 1), formattedRut];
    
    counter++;
    
    // Every three numbers add a dot
    // and reset the counter
    if (counter == 3 && i != 0) {
      formattedRut = [NSString stringWithFormat:@".%@", formattedRut];
      counter = 0;
    }
    
  }
  
  // So now we got something like
  // 14179587204 => 1.417.958.720-4
  if (_verbose)
    NSLog(@"Input %@, Formatted %@", rut, formattedRut);
    
  
  return formattedRut;
}

/*!
 * Unformat a RUT String to Number Format
 * Example '12.345.678-9' => '123456789'
 * @return NSString Unformatted RUT
 */
+ (NSString *) removeFormat : (NSString *) rut {
  
  if (_verbose)
    NSLog(@"Removing Format to RUT %@", rut);
  
  NSMutableString * newRut = [rut mutableCopy];
  
  // Remove spaces
  [newRut setString:[newRut stringByReplacingOccurrencesOfString:@" " withString:@""]];
  
  // Remove dots
  [newRut setString:[newRut stringByReplacingOccurrencesOfString:@"." withString:@""]];
  
  // Remove dashes
  [newRut setString:[newRut stringByReplacingOccurrencesOfString:@"-" withString:@""]];
  
  // Return String
  if (_verbose)
    NSLog(@"Removed Format %@", newRut);
  
  return [newRut copy];
}

/*!
 *    Removes any character that does not belongs to a RUT.
 *    Valid characters are 0123546789kK.-
 *
 *    @param NSString with the rut
 *
 *    @return NSString with removed invalid characters
 */
+ (NSString *) removeInvalidCharacters:(NSString *)rut {
    
    // Strip unwanted chars
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0123546789kK.-]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString * newRut = [regex stringByReplacingMatchesInString:rut options:kNilOptions range:NSMakeRange(0, [rut length]) withTemplate:@""];
    

    if (_verbose) {
        NSLog(@"Removed From %@ to %@", rut, newRut);
    }
    
    return newRut;
}

/*!
 * Get a Digit given an unformatted RUT String
 * without digit
 * Example '12345678' => 9
 * @param NSString rut
 * @return NSString with a RUT Digit
 */
+ (NSString *) getDigit : (NSString *) rut {
  
  // Module 11 Algorithm
  
  if (_verbose)
    NSLog(@"Beggining Module 11 Algorithm for RUT %@", rut);
    
  
  int digit = 0;
  int counter = 2;
  int multiple = 0;
  int acumulator = 0;
  
  NSInteger numeric_rut = [[[self class ] removeFormat:rut] integerValue];
  
  NSString * newDigit;
  
  while (numeric_rut != 0) {
    multiple = (numeric_rut % 10) * counter;
    acumulator = acumulator + multiple;
    numeric_rut = numeric_rut / 10;
    
    counter = counter + 1;
    
    if (counter == 8) {
      counter = 2;
    }
    
  }
  
  digit = 11 - (acumulator % 11);
  
  newDigit = [NSString stringWithFormat:@"%d", digit];
  
  if (digit == 10) {
      newDigit = @"k";
  }
  
  if (digit == 11) {
      newDigit = @"0";
  }
  
  if (_verbose)
    NSLog(@"Found Digit %@", newDigit);
  
  return newDigit;
}

#pragma mark - Validation Methods

/*!
 * Check the validity of a RUT String
 * @param NSString rut
 * @return YES if is Valid
 */
+ (BOOL) isValidRUT : (NSString *) rut {
  
  if (_verbose)
    NSLog(@"Begin Validation of %@", rut);
  
  // Trim format
  rut = [[self class] removeFormat:rut];
  
  // Trim Invalid Chars
  rut = [[self class] removeInvalidCharacters:rut];
    
  // Check for digit validity
  // with a closure
  BOOL (^ hasValidDigits)(NSString *);
  
  hasValidDigits = ^(NSString * rut) {
    NSString * digit;
    
    BOOL isValid = NO;
    
    for (int i = 0; i < rut.length; i++) {
      digit = [NSString stringWithFormat:@"%c", [rut characterAtIndex:i]];
      
      isValid = [[self class] isValidDigit:digit];
      
      if (!isValid)
        break;
      
    }
    
    return isValid;
  };
  
  
  // Begin Validation
  BOOL isValid = NO;
  
  
  // Check Length
  // Minimum is 2
  if (rut.length >= 2) {
    
    // Check for valid digits
    if(hasValidDigits(rut)) {
      
      // Check for correct verification digit
      NSString  * digit = [rut substringFromIndex:rut.length - 1];
      
      if ([[self class] isValidRUT:rut withDigit:digit]) {
        // If digit corresponds to rut
        // then we have a  valid rut
        if (_verbose)
          NSLog(@"%@ is Valid", rut);
        
        isValid = YES;
      }
    }
    
  } else {
    if (_verbose)
      NSLog(@"%@ is too short", rut);
  }
  
  return isValid;
}

/*!
 * Check the validity of a RUT Digit String
 * @param NSString digit
 * @return YES if is Valid
 */
+ (BOOL) isValidDigit : (NSString *) digit {
  
  if (_verbose)
    NSLog(@"Validating Digit %@", digit);
  
  NSCharacterSet * validChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789k"];
  
  NSCharacterSet * invalidChars = [validChars invertedSet];
  
  NSRange invalidCharacterRange = [[digit lowercaseString] rangeOfCharacterFromSet:invalidChars];
  
  // Digit is valid only
  // where its just one
  // and there are no invalid characters present
  BOOL isValid = (digit.length == 1 && invalidCharacterRange.location == NSNotFound);
  
  if (_verbose)
    NSLog(@"Digit %@ is %@ valid", digit, (isValid ? @"" : @"not"));
    
  return isValid;
}

/*!
 * Check if the digit corresponds with the RUT
 * Example
 * rut '123456789' digit 9 => YES
 * rut '12345678K' digit 9 => NO
 *
 * @return YES if is Valid
 */
+ (BOOL) isValidRUT:(NSString *) rut withDigit : (NSString *) digit {
  
  if (_verbose)
    NSLog(@"Validate %@ with Digit %@", rut, digit);
    
  
  // Trim format and last digit
  rut = [[[self class] removeFormat:rut] substringToIndex:rut.length - 1];
  
  // Get the Correct Digit
  NSString * correctDigit = [[self class] getDigit:rut];
  
  // compare
  BOOL isValid = ([[digit lowercaseString] isEqualToString:[correctDigit lowercaseString]]);
  
  if (_verbose)
    NSLog(@"Param Digit %@, Correct Digit %@, Digits are %@", digit, correctDigit, (isValid ? @"Equal" : @"Diferent"));
  
  return isValid;
}


@end
