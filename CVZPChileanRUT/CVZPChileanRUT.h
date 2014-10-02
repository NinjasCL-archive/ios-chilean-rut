//
//  CVZPChileanRUT.h
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

#import <Foundation/Foundation.h>

/*!
 * ChileanRUT Enables to Format, Unformat and Check the Validity
 * of Chilean RUN or RUT National Identification Numbers
 *
 */
@interface CVZPChileanRUT : NSObject

#pragma mark - Instance Properties

@property (nonatomic) NSString * rut;

#pragma mark - Instance Methods

#pragma mark - Abstract Methods

/*!
 * Verbose Output for all methods
 * @param verbose
 */
+ (void) setVerbose: (BOOL) verbose;

#pragma mark Generator Methods

/*!
 * Generate a Valid Random RUT
 * @param BOOL formatted set if the generated RUT must be formatted
 * @return NSString Valid RUT
 */
+ (NSString *) createRandomRUTFormatted: (BOOL) formatted;

/*!
 * Generate a quantity of Valid Random RUT
 * @param BOOL formatted set if the generated RUT must be formatted
 * @param NSInteger quantity of generated Random RUT
 * @return NSArray of Valid NSString RUT
 */
+ (NSArray *) createRandomRUTFormatted:(BOOL)formatted withQuantity: (NSInteger) quantity;

#pragma mark Formatting Methods

/*!
 * Format a Number String to RUT Format
 * Example '123456789' => '12.345.678-9'
 * @param NSString rut
 * @param BOOL withDigit tells if the rut includes digit or must calculte it
 * @return NSString Formatted RUT
 */
+ (NSString *) formatRUT : (NSString *) rut withDigit : (BOOL) withDigit;


/*!
 * Unformat a RUT String to Number Format
 * Example '12.345.678-9' => '123456789'
 * @return NSString Unformatted RUT
 */
+ (NSString *) removeFormat : (NSString *) rut;

/*!
 * Get a Digit given an unformatted RUT String
 * without digit
 * Example '12345678' => 9
 * @param NSString rut
 * @return NSString with a RUT Digit
 */
+ (NSString *) getDigit : (NSString *) rut;

#pragma mark Validation Methods

/*!
 * Check the validity of a RUT String
 * @param NSString rut
 * @return YES if is Valid
 */
+ (BOOL) isValidRUT : (NSString *) rut;

/*!
 * Check the validity of a RUT Digit String
 * @param NSString digit
 * @return YES if is Valid
 */
+ (BOOL) isValidDigit : (NSString *) digit;

/*!
 * Check if the digit corresponds with the RUT
 * Example 
 * rut '123456789' digit 9 => YES
 * rut '12345678K' digit 9 => NO
 *
 * @return YES if is Valid
 */
+ (BOOL) isValidRUT:(NSString *) rut withDigit : (NSString *) digit;

@end
