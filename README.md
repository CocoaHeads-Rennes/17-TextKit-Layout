# CocoaHeads Rennes #17 - TextKit

This repository contains the code samples that have been presented during this session about TextKit, and more specifically dedicated to text layout.
It contains two sample applications for iPad:

- **TextKitSimpleLayout** illustrates the techniques for basic text layout with TextKit. It presents a two-column layout with a shape-view providing an exclusion path and a Text attachment showing an image in the text layout flow. The columns can be resized by moving the slider; the shape-view can be moved to test the dynamic change of exclusion path.

- **TextKitSubclasses** provide examples of TextKit customization through subclassing: a round-shape text container demonstrates how easy it is to create a NSTextContainer subclass; `ColoringTextStorage` is a simple subclass of NSTextStorage (analog the example provided at WWDC 2013). Note that the Text View with the round text container is fully editable, just as any regular UITextView. **TextKitSubclasses** also include an example of a custom NSView subclass using directly TextKit to draw rich text on a path (a circle in this case).

### Licence

These code samples are provided under the MIT lience.
