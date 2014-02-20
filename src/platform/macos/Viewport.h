//
//  Viewport.h
//  Brogue
//
//  Created by Brian and Kevin Walker.
//  Updated by Seth Howard on 8/15/2013
//  Copyright 2012. All rights reserved.
//
//  This file is part of Brogue.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Cocoa/Cocoa.h>

#define	VERT_PX		18
#define	HORIZ_PX	11

#define kROWS		(30+3+1)
#define kCOLS		100

// This is only used as a starting point for the calculation after the
// window resizes.
#define FONT_SIZE	10
// This is only the basic font.  There are also fixed-name fallback fonts.
#define FONT_NAME	@"Monaco"

@interface Viewport : NSView
{
	NSString *_letterArray[kCOLS][kROWS];
	CGColorRef _bgColorArray[kCOLS][kROWS];
    CGColorRef _letterColorArray[kCOLS][kROWS];
	NSMutableDictionary *_attributes[kCOLS][kROWS];
	NSMutableDictionary *_characterSizeDictionary;
	NSRect _rectArray[kCOLS][kROWS];
    unsigned short _charArray[kCOLS][kROWS];
    NSSize _fastFontCharSize;
    CGContextRef _context;
    CGFontRef _cgFont;
    
    short _hWindow;
    short _vWindow;
    short _vPixels;
    short _hPixels;
    short _theFontSize;
    
    NSFont *_slowFont;
    NSFont *_fastFont;
    
    CGGlyph _glyphString[1];
    
    NSString *_basicFontName;
}

- (void)setString:(NSString *)c
   withBackground:(CGColorRef)bgColor
  withLetterColor:(CGColorRef)letterColor
	  atLocationX:(short)x
		locationY:(short)y
    withFancyFont:(bool)fancyFont
         withChar:(unsigned short)character;

- (void)drawTheString:(NSString *)theString centeredIn:(NSRect)rect withAttributes:(NSMutableDictionary *)theAttributes withChar:(unsigned short)character;

- (void)setHorizWindow:(short)hPx
			vertWindow:(short)vPx
			  fontSize:(short)size;

// window size
@property (nonatomic, assign) short horizWindow;
@property (nonatomic, assign) short vertWindow;
// TODO: rename to fastFont and slowFont and use the custom getter already provided (fastfont)
@property (nonatomic, retain) NSFont *slowFont;
@property (nonatomic, retain) NSFont *fastFont;
// The approximate size of one rectangle, which can be off by up to 1 pixel:
@property (nonatomic, assign) short vPixels;
@property (nonatomic, assign) short hPixels;
@property (nonatomic, assign) short theFontSize; // Will get written over when windowDidResize
@property (nonatomic, copy) NSString *basicFontName;
@property (nonatomic, retain) NSDictionary *characterSizeDictionary;

@end
