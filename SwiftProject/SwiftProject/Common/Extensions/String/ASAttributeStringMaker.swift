//
//  ASAttributeStringMaker.swift
//  Dojo
//
//  Created by Ankit Saini on 30/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

///https://github.com/AzenXu/AttributedStringMaker/blob/master/AttributeStringMaker/ViewController.swift

import Foundation
import UIKit

//MARK:- String
public extension String {
    
    /// NSMutableAttributedString
    var attriString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

//MARK:- NSString
extension NSString {
    
    /// NSMutableAttributedString
    var attriString: NSMutableAttributedString {
        return NSMutableAttributedString.init(string: String(self))
    }
}

//MARK:- NSMutableAttributedString
public extension NSMutableAttributedString {
    
    /// Append String
    /// - Parameter string: NSAttributedString
    func append(string: NSAttributedString) -> NSMutableAttributedString {
        self.append(string)
        return self
    }
    
    /// Set attributes
    /// - Parameter attrMaker: AttributeMaker
    func setAtt(_ attrMaker: (_ maker: AttributeMaker) -> Void) -> NSMutableAttributedString {
        let maker = AttributeMaker()
        attrMaker(maker)
        self.setAttributes(maker.dictionary, range: NSRange.init(location: 0, length: self.length))
        if maker.attachment != nil {
            let attriForAttach = NSAttributedString(attachment: maker.attachment!)
            self.append(attriForAttach)
        }
        return self
    }
    
    /// AttributeMaker
    class AttributeMaker {
        
        /// [NSAttributedString.Key : Any]
        var dictionary: [NSAttributedString.Key: Any] = [:]
        
        /// NSMutableParagraphStyle
        let defaultParagraphStyle = NSMutableParagraphStyle()
        
        
        /// Set font properties, default: Font: Helvetica (Neue) Font size: 12
        open var font: UIFont? {
            didSet {
                if let font = self.font {
                    self.dictionary.updateValue(font, forKey: NSAttributedString.Key.font)
                }
            }
        }
        
        /// Set the font color, the value is UIColor object, the default value is black
        open var color: UIColor? {
            didSet {
                if let color = self.color {
                    self.dictionary.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
                }
            }
        }
        
        /// Set the background color of the area where the font is located. The value is the UIColor object. The default value is nil, transparent.
        open var backgroundColor: UIColor? {
            didSet {
                if let backgroundColor = self.backgroundColor {
                    self.dictionary.updateValue(backgroundColor, forKey: NSAttributedString.Key.backgroundColor)
                }
            }
        }
        
        /// Set the character spacing, the value is NSNumber object (integer), the positive value spacing is widened, and the negative value spacing is narrowed.
        open var kern: NSNumber? {
            didSet {
                if let kern = self.kern {
                    self.dictionary.updateValue(kern, forKey: NSAttributedString.Key.kern)
                }
            }
        }
        
        /// Set strikethrough
        open var deleteLineNum: Int? {
            didSet {
                if let num = self.deleteLineNum {
                    self.dictionary.updateValue(num as AnyObject, forKey: NSAttributedString.Key.strikethroughStyle)
                }
            }
        }
        /**Set the strikethrough color, the value is UIColor object, the default value is black*/
        open var deleteLineColor: UIColor? {
            didSet {
                if let color = self.deleteLineColor {
                    self.dictionary.updateValue(color, forKey: NSAttributedString.Key.strikethroughColor)
                }
            }
        }
        /**Whether to use the default conjoined characters*/
        open var ligature: Bool? {
            didSet {
                if let ligature = self.ligature {
                    self.dictionary.updateValue(ligature ? 1 : 0, forKey: NSAttributedString.Key.ligature)
                }
            }
        }
        /**Set underline*/
        open var underLine: NSUnderlineStyle? {
            didSet {
                if let underLine = self.underLine {
                    self.dictionary.updateValue(underLine.rawValue, forKey: NSAttributedString.Key.underlineStyle)
                }
            }
        }
        /**Set the underline color, the value is the UIColor object, the default value is black*/
        open var underLineColor: UIColor? {
            didSet {
                if let underLineColor = self.underLineColor {
                    self.dictionary.updateValue(underLineColor, forKey: NSAttributedString.Key.underlineColor)
                }
            }
        }
        /**Set the stroke width, the value is NSNumber object (integer), negative value fill effect, positive value hollow effect*/
        open var strokeWidth: NSNumber? {
            didSet {
                if let strokeWidth = self.strokeWidth {
                    self.dictionary.updateValue(strokeWidth, forKey: NSAttributedString.Key.strokeWidth)
                }
            }
        }
        /**Fill part of the color, not the font color*/
        open var strokeColor: UIColor? {
            didSet {
                if let strokeColor = self.strokeColor {
                    self.dictionary.updateValue(strokeColor, forKey: NSAttributedString.Key.strokeColor)
                }
            }
        }
        /**Set shadow properties*/
        open var shadow: NSShadow? {
            didSet {
                if let shadow = self.shadow {
                    self.dictionary.updateValue(shadow, forKey: NSAttributedString.Key.shadow)
                }
            }
        }
        /**Set the text special effect, the value is NSString object, currently only the plate printing effect is available*/
        open var textEffect: NSString? {
            didSet {
                if let textEffect = self.textEffect {
                    self.dictionary.updateValue(textEffect, forKey: NSAttributedString.Key.textEffect)
                }
            }
        }
        /**Set the baseline offset value, which is NSNumber (float), positive value is biased, negative value is biased*/
        open var baseLineOffset: NSNumber? {
            didSet {
                if let baseLineOffset = self.baseLineOffset {
                    self.dictionary.updateValue(baseLineOffset, forKey: NSAttributedString.Key.baselineOffset)
                }
            }
        }
        /**Set the glyph tilt, the value is NSNumber (float), positive value is right, left negative*/
        open var obliqueness: NSNumber? {
            didSet {
                if let obliqueness = self.obliqueness {
                    self.dictionary.updateValue(obliqueness, forKey: NSAttributedString.Key.obliqueness)
                }
            }
        }
        /**Sets the text horizontal stretch property, which is NSNumber (float), positive value stretches text horizontally, negative value horizontally compresses text*/
        open var expansion: NSNumber? {
            didSet {
                if let expansion = self.expansion {
                    self.dictionary.updateValue(expansion, forKey: NSAttributedString.Key.expansion)
                }
            }
        }
        /**Set the writing direction of the text, writing from left to right or writing from right to left*/
        open var writingDirectionFromLeft: Bool? {
            didSet {
                if let writingDirectionFromLeft = self.writingDirectionFromLeft {
                    self.dictionary.updateValue(writingDirectionFromLeft ? 1 : 0, forKey: NSAttributedString.Key.writingDirection)
                }
            }
        }
        /**Set the text layout direction, the value is NSNumber object (integer), 0 is horizontal text, 1 is vertical text*/
        open var verticalGlyphForm: Bool? {
            didSet {
                if let verticalGlyphForm = self.verticalGlyphForm {
                    self.dictionary.updateValue(verticalGlyphForm ? 1 : 0, forKey: NSAttributedString.Key.verticalGlyphForm)
                }
            }
        }
        /**Set the link property, click to call the browser to open the specified URL address*/
        open var link: URL? {
            didSet {
                if let link = self.link {
                    self.dictionary.updateValue(link as AnyObject, forKey: NSAttributedString.Key.link)
                }
            }
        }
        /**Set the text attachment, the value is NSTextAttachment object, often used for text image mixing*/
        open var attachment: NSTextAttachment?
        /**Set text paragraph layout format*/
        open var paragraphStyle: NSParagraphStyle? {
            didSet {
                if let paragraphStyle = self.paragraphStyle {
                    self.dictionary.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
                }
            }
        }
        /**Line spacing PS. requires numberOfLines = 0 to be valid */
        open var lineSpacing: CGFloat? {
            didSet {
                if let lineSpacing = self.lineSpacing {
                    defaultParagraphStyle.lineSpacing = lineSpacing
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Segment spacing PS. requires numberOfLines = 0 to be valid */
        open var paragraphSpacing: CGFloat? {
            didSet {
                if let paragraphSpacing = self.paragraphSpacing {
                    defaultParagraphStyle.paragraphSpacing = paragraphSpacing
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Alignment PS. requires numberOfLines = 0 to be valid */
        open var alignment: NSTextAlignment? {
            didSet {
                if let alignment = self.alignment {
                    defaultParagraphStyle.alignment = alignment
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**First line indent PS. Requires numberOfLines = 0 to be valid */
        open var firstLineHeadIndent: CGFloat? {
            didSet {
                if let firstLineHeadIndent = self.firstLineHeadIndent {
                    defaultParagraphStyle.firstLineHeadIndent = firstLineHeadIndent
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**In addition to the first line, other lines are indented PS. Requires numberOfLines = 0 to be valid. */
        open var headIndent: CGFloat? {
            didSet {
                if let headIndent = self.headIndent {
                    defaultParagraphStyle.headIndent = headIndent
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**The width of each line accommodates characters. PS. requires numberOfLines = 0 to be valid. */
        open var tailIndent: CGFloat? {
            didSet {
                if let tailIndent = self.tailIndent {
                    defaultParagraphStyle.tailIndent = tailIndent
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Line feed mode PS. requires numberOfLines = 0 to be valid. */
        open var lineBreakMode: NSLineBreakMode? {
            didSet {
                if let lineBreakMode = self.lineBreakMode {
                    defaultParagraphStyle.lineBreakMode = lineBreakMode
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Minimum line height PS. Requires numberOfLines = 0 to be valid */
        open var minimumLineHeight: CGFloat? {
            didSet {
                if let minimumLineHeight = self.minimumLineHeight {
                    defaultParagraphStyle.minimumLineHeight = minimumLineHeight
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Maximum line height PS. Requires numberOfLines = 0 to be valid */
        open var maximumLineHeight: CGFloat? {
            didSet {
                if let maximumLineHeight = self.maximumLineHeight {
                    defaultParagraphStyle.maximumLineHeight = maximumLineHeight
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /**Writing method PS. requires numberOfLines = 0 to be valid */
        open var baseWritingDirection: NSWritingDirection? {
            didSet {
                if let baseWritingDirection = self.baseWritingDirection {
                    defaultParagraphStyle.baseWritingDirection = baseWritingDirection
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /** PS. requires numberOfLines = 0 to be valid */
        open var lineHeightMultiple: CGFloat? {
            didSet {
                if let lineHeightMultiple = self.lineHeightMultiple {
                    defaultParagraphStyle.lineHeightMultiple = lineHeightMultiple
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /** PS. requires numberOfLines = 0 to be valid */
        open var paragraphSpacingBefore: CGFloat? {
            didSet {
                if let paragraphSpacingBefore = self.paragraphSpacingBefore {
                    defaultParagraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /** PS. requires numberOfLines = 0 to be valid */
        open var hyphenationFactor: Float? {
            didSet {
                if let hyphenationFactor = self.hyphenationFactor {
                    defaultParagraphStyle.hyphenationFactor = hyphenationFactor
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /** PS. requires numberOfLines = 0 to be valid */
        open var tabStops: [NSTextTab]? {
            didSet {
                if let tabStops = self.tabStops {
                    defaultParagraphStyle.tabStops = tabStops
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
        /** PS. requires numberOfLines = 0 to be valid */
        open var defaultTabInterval: CGFloat? {
            didSet {
                if let defaultTabInterval = self.defaultTabInterval {
                    defaultParagraphStyle.defaultTabInterval = defaultTabInterval
                    paragraphStyle = defaultParagraphStyle
                }
            }
        }
    }
}
