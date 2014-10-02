
# iOS Chilean RUT-RUN Validator / Generator

Validates Chilean National Unique Identifiers (Rol Unico Nacional, Rol Unico Tributario) RUT/RUN.

## Installation
Copy **CVZPChileanRUT.h** and **CVZPChileanRUT.m** to your project.

## Usage

```objective-c

// Import Library
#import "CVZPChileanRUT.h"

// Code

- (void) validate {
    NSString * rut = @"123456789";
    
	BOOL isValid = [CVZPChileanRUT isValidRUT:rut];
	
	NSLog(@"RUT %@ is %@ valid", rut, (isValid ? @"": @"not"));
}

```

** More Info**
> See *ValidateChileanRunTests.m* and the Example Project for Usage Info.
