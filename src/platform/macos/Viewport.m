//
//  Viewport.m
//  Brogue
//
//  Created by Brian and Kevin Walker on 11/28/08.
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

#import "Viewport.h"
#import <QuartzCore/QuartzCore.h>

#define kDotChar 183

@implementation Viewport
@synthesize horizWindow = _hWindow;
@synthesize vertWindow = _vWindow;
@synthesize fastFont = _fastFont;
@synthesize slowFont = _slowFont;
@synthesize vPixels = _vPixels;
@synthesize hPixels = _hPixels;
@synthesize theFontSize = _theFontSize;
@synthesize basicFontName = _basicFontName;
@synthesize characterSizeDictionary = _characterSizeDictionary;

- (id)initWithFrame:(NSRect)rect
{
	if (![super initWithFrame:rect]) {
		return nil;
	}
    
	int i, j;
    
	for (j = 0; j < kROWS; j++) {
		for (i = 0; i < kCOLS; i++) {
            self.basicFontName = FONT_NAME;
            self.characterSizeDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
			_letterArray[i][j] = [@" " retain];
			[_letterArray[i][j] retain];
			_bgColorArray[i][j] = nil;
            _letterColorArray[i][j] = nil;
            
			_attributes[i][j] = [[NSMutableDictionary alloc] init];
			[_attributes[i][j] setObject:[self fastFont] forKey:NSFontAttributeName];
			[_attributes[i][j] setObject:[NSColor blackColor]
                                  forKey:NSForegroundColorAttributeName];
			_rectArray[i][j] = NSMakeRect(HORIZ_PX*i, (VERT_PX * kROWS)-(VERT_PX*(j+1)), HORIZ_PX, VERT_PX);
            
            _cgFont = CGFontCreateWithFontName((CFStringRef)FONT_NAME);
            
            _vPixels = VERT_PX;
            _hPixels = HORIZ_PX;
            _theFontSize = FONT_SIZE;
		}
	}
    
    // adjust font sizes
    [self setFontSize];
    
	return self;
}

#pragma mark - Fonts

// Letting OS X handle the fallback for us produces inconsistent results
// across versions, and on OS X 10.8 falls back to Emoji Color for some items
// (e.g. foliage), which doesn't draw correctly at all. So we need to use a
// cascade list forcing it to fall back to Arial Unicode MS and Apple Symbols,
// which have the desired characters.
//
// Using a cascade list, even an empty one, makes text drawing unusably
// slower. To fix this, we store two fonts, one "fast" for ASCII characters
// which we assume Monaco will always be able to handle, and one "slow" for
// non-ASCII.
//
// Because I prefer the default glyphs for all characters except for foliage,
// the cascade list is used only for foliage characters.

- (NSFont *)slowFont {
	if (!_slowFont) {
		NSFont *baseFont = [NSFont fontWithName:_basicFontName size:_theFontSize];
		NSArray *fallbackDescriptors = [NSArray arrayWithObjects:
		                                // Arial provides reasonable versions of most characters.
		                                [NSFontDescriptor fontDescriptorWithName:@"Arial Unicode MS" size:_theFontSize],
		                                // Apple Symbols provides U+26AA, for rings, which Arial does not.
		                                [NSFontDescriptor fontDescriptorWithName:@"Apple Symbols" size:_theFontSize],
		                                nil];
		NSDictionary *fodDict = [NSDictionary dictionaryWithObject:fallbackDescriptors forKey:NSFontCascadeListAttribute];
		NSFontDescriptor *desc = [baseFont.fontDescriptor fontDescriptorByAddingAttributes:fodDict];
		_slowFont = [[NSFont fontWithDescriptor:desc size:_theFontSize] retain];
        
	}
	return _slowFont;
}

- (NSFont *)fastFont {
	if (!_fastFont) {
		_fastFont = [[NSFont fontWithName:_basicFontName size:_theFontSize] retain];
    }
    
	return _fastFont;
}

- (NSFont *)fontForString:(NSString *)s {
	if (s.length == 1 && ([s characterAtIndex:0] < 128)) {
		return [self fastFont];
	} else {
		return [self slowFont];
    }
}

#pragma mark - Drawing

- (NSSize)getStringSizeForString:(NSString *)aString withAttributes:(NSDictionary *)attributes {
    NSSize stringSize;
    id cachedSize = [_characterSizeDictionary objectForKey:aString];
    if (cachedSize == nil) {
        stringSize = [aString sizeWithAttributes:attributes];	// quite expensive
        [_characterSizeDictionary setObject:[NSValue valueWithSize:stringSize] forKey:aString];
    } else {
        stringSize = [[_characterSizeDictionary objectForKey:aString] sizeValue];
    }
    
    return stringSize;
}

- (void)setString:(NSString *)c
   withBackground:(CGColorRef)bgColor
  withLetterColor:(CGColorRef)letterColor
	  atLocationX:(short)x
		locationY:(short)y
    withFancyFont:(bool)fancyFont
         withChar:(unsigned short)character
{
    NSRect updateRect;
    NSSize stringSize;
    
    [_letterArray[x][y] release];
    CGColorRelease(_bgColorArray[x][y]);
    CGColorRelease(_letterColorArray[x][y]);
    
    _letterArray[x][y] = [c retain];
    _bgColorArray[x][y] = bgColor;
    _letterColorArray[x][y] = letterColor;
    _charArray[x][y] = character;
    
    // we only need these attributes if we're drawing unicode
    if (character > 127 && character != kDotChar) {
        // this exists to support 10.7 and under otherwise we'd use [NSColor colorWithCGColor:letterColor] 
        const CGFloat *components = CGColorGetComponents(letterColor);
        [_attributes[x][y] setObject:[NSColor colorWithCalibratedRed:components[0] green:components[1] blue:components[2] alpha:1.] forKey:NSForegroundColorAttributeName];
        [_attributes[x][y] setObject:(fancyFont ? [self slowFont] : [self fastFont]) forKey:NSFontAttributeName];
        stringSize = [self getStringSizeForString:c withAttributes:_attributes[x][y]];
    }
    else {
        stringSize = _fastFontCharSize;
    }
    
    stringSize.width++;
    
    if (stringSize.width >= _rectArray[x][y].size.width) { // custom update rectangle
        updateRect.origin.y = _rectArray[x][y].origin.y;
        updateRect.size.height = _rectArray[x][y].size.height;
        updateRect.origin.x = _rectArray[x][y].origin.x + (_rectArray[x][y].size.width - stringSize.width - 10)/2;
        updateRect.size.width = stringSize.width + 10;
        [self setNeedsDisplayInRect:updateRect];
    } else { // fits within the cell rectangle; no need for a custom update rectangle
        [self setNeedsDisplayInRect:_rectArray[x][y]];
    }
}

- (void)drawRect:(NSRect)rect
{
	int i, j, startX, startY, endX, endY;
    
    startX = (int) (kCOLS * (rect.origin.x) / _hWindow);
    startY = kROWS - (int) (kCOLS * (rect.origin.y + rect.size.height + _vPixels - 1 ) / _vWindow);
    endX = (int) (kCOLS * (rect.origin.x + rect.size.width + _hPixels - 1) / _hWindow);
    endY = kROWS - (int) (kROWS * rect.origin.y / _vWindow);
    
    if (startX < 0) {
        startX = 0;
    }
    if (endX > kCOLS) {
        endX = kCOLS;
    }
    if (startY < 0) {
        startY = 0;
    }
    if (endY > kROWS) {
        endY = kROWS;
    }
    
    _context = [[NSGraphicsContext currentContext] graphicsPort];
    CGColorRef prevColor = nil;
    
    for ( j = startY; j < endY; j++ ) {
        for ( i = startX; i < endX; i++ ) {
            CGColorRef color = _bgColorArray[i][j];
            
            if (!CGColorEqualToColor(prevColor, color)) {
                CGContextSetFillColorWithColor(_context, color);
                prevColor = color;
            }
            
            CGContextFillRect(_context, *(CGRect *)&_rectArray[i][j]);
        }
    }
    
    CGContextSetTextMatrix(_context, CGAffineTransformMakeScale(1.0, 1.0));
    CGContextSetFontSize(_context, _theFontSize);
    CGContextSetFont(_context, _cgFont);
    
    // now draw the ascii chars
    for ( j = startY; j < endY; j++ ) {
        for ( i = startX; i < endX; i++ ) {
            if (!CGColorEqualToColor(prevColor, _letterColorArray[i][j])) {
                CGContextSetFillColorWithColor(_context, _letterColorArray[i][j]);
                prevColor = _letterColorArray[i][j];
            }
            
            [self drawTheString:_letterArray[i][j] centeredIn:_rectArray[i][j] withAttributes:_attributes[i][j] withChar:_charArray[i][j]];
        }
    }
}

- (void)drawTheString:(NSString *)theString centeredIn:(NSRect)rect withAttributes:(NSMutableDictionary *)theAttributes withChar:(unsigned short)character {
	// Assuming a space character is an empty rectangle provides a major
	// increase in redraw speed.
	if (character == 32) {
		return;
	}
    
	NSPoint stringOrigin;
    
    if (character > 127 && character != kDotChar) {
        NSSize stringSize = [self getStringSizeForString:theString withAttributes:theAttributes];
        
        stringOrigin.x = rect.origin.x + (rect.size.width - stringSize.width) / 2;
        stringOrigin.y = rect.origin.y + (rect.size.height - stringSize.height) / 2;
        
        [theString drawAtPoint:stringOrigin withAttributes:theAttributes];
        
        // seems like we need to change the context back or we render incorrect glyps. We do it here assuming we call this less than the show glyphs below
        CGContextSetFont(_context, _cgFont);
        CGContextSetTextMatrix(_context, CGAffineTransformMakeScale(1.0, 1.0));
        CGContextSetFontSize(_context, _theFontSize);
    }
    else {
        // we have a unicode character. Draw it with drawAtPoint
        // if it's one of those fancy centered dots (183) toss it for a period. It's used a lot and slows things down
        if (character == kDotChar) {
            character = 46;
            stringOrigin.y = rect.origin.y - 2 + (rect.size.height - _theFontSize) * 2;
        }
        else {
            stringOrigin.y = rect.origin.y + (rect.size.height - _theFontSize);
        }
        
        stringOrigin.x = rect.origin.x + (rect.size.width - _fastFontCharSize.width) / 2;
        
        _glyphString[0] = character-29;
        CGContextShowGlyphsAtPoint(_context, stringOrigin.x, stringOrigin.y, _glyphString, 1);
    }
}

#pragma mark - Setters

- (void)setHorizWindow:(short)hPx
            vertWindow:(short)vPx
              fontSize:(short)size
{
    int i, j;
    _hPixels = hPx / kCOLS;
    _vPixels = vPx / kROWS;
    _hWindow = hPx;
    _vWindow = vPx;
    _theFontSize = size;
    [_slowFont release]; _slowFont = nil;
    [_fastFont release]; _fastFont = nil;
    
    for (j = 0; j < kROWS; j++) {
        for (i = 0; i < kCOLS; i++) {
            [_attributes[i][j] setObject:[self fontForString:_letterArray[i][j]] forKey:NSFontAttributeName];
            _rectArray[i][j] = NSMakeRect((int) (hPx * i / kCOLS),
                                          (int) (vPx - (vPx * (j+1) / kROWS)),
                                          ((int) (hPx * (i+1) / kCOLS)) - ((int) (hPx * (i) / kCOLS)),//hPixels + 1,
                                          ((int) (vPx * (j+1) / kROWS)) - ((int) (vPx * (j) / kROWS)));//vPixels + 1);
        }
    }
    
    [self setFontSize];
}

- (void)setFontSize {
    [_attributes[0][0] setObject:[self fastFont] forKey:NSFontAttributeName];
    _fastFontCharSize = [@"M" sizeWithAttributes:_attributes[0][0]];
}

@end
