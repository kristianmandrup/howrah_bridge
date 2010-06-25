# howrah ##

This project has the goal of making it possible to take snippets of HTML, convert it to prawn PDF constructs and render these onto a prawn PDF document.
So far the focus has been on parsing and converting CSS styles to PDF equivalents. 

## Future ##

Future goals 

* Make it easy to extend with "plugins", for rendering HTML elements or CSS styles

## Requirements ##

Gems
* prawn >= 0.10
* nokogiri >= 1.4.1
* kmandrup-colorist >= 0.1.2
* html_css_decorator >= 0.1.2

## Usage

<pre>
simple_html = '<p style="font-size:20; color: red"><span style="color: #0f0; font-size:10; font-weight:bold; font-style: italic">Hello Kitty</span>Katty</p>'    

doc = Prawn::Document.new(:page_size => "A4")    
Howrah::Html.generate(doc) do
  apply_html(simple_html)
end    


PdfGenerator::Html.generate('kitty_adv.pdf', :page_size => "A4") do
  apply_html(simple_html)
end

Prawn::Document.new(:page_size => "A4") do |doc|
  Howrah::Html.generate(doc) do
    apply_html(simple_html)  
  end
end
</pre>
   
Note: The DSL is still experimental. It needs polishing and fine tuning...!

## Design notes ##

Basic algorithm:
1. Create HTML/CSS model
2. Traverse model
3. Use style stack
4. Render HTML element to PDF 

### Create HTML/CSS model ###
The HTML text is read into a HTML model using Nokogiri. Then a CSS decorator for Nokogiri is used to decorate the model with CSS information for each element as it would apply in the browser.

### Traverse model ###
The model is traversed recursively, starting with the HTML element. Only XML::Element and XML::TextElement are considered for rendering to the PDF.
The HTML element calls a HTML renderer which takes it from there. 

### HTML element Renderers ###
Each renderer is initialized with the current generator state, the element to render and any options. A renderer can contain default options it uses to fill out its
style if none are provided. The "real styles" should simply be merged with the default styles, with the 'real' style overriding and taking precedence.

### Style stack ###
For each element the current PDF style is calculated by converting the currently applying CSS style and adding it to a style stack. This style will then be the base for
all elements within. When this element has finished rendering, its style will be popped from the stack.

The current_style will be calculated by merging it with the top level style in the style stack. When the current element for which the style applies goes out of context, the current_style should revert back to the previous style on the stack that was calculated in the same fashion.

### Render HTML element to PDF ###
Each type of HTML element should map to a specific PDF renderer which is executed with the current style stack.
Each PDF renderer should have a 'before_render' method to do any pre-rendering, such as positioning and a 'after_render' to do any post-rendering 
such as positioning, fx creating a newline effect. The main 'render' method should render to the pdf document using the element (with children) and the style stack.

### Prawn styles ###  
Prawn 0.10 has support for a small set of styles. As part of this project we are extending Prawn to have options that let it support more of the common CSS styles. 
Styles that have been added are 

* background-color
* margin (left, top, bottom)
* border (width, color, style)

The prawn core team is currently working on a Document::Layout feature that should make it much easier to work with internal layout regions in the prawn document, such as
a CSS box model. We are currently waiting for this feature to stabilize before we do further work on the box model within the *Howrah* project.

### Inline text elements ###  
Currently the Text::Formatted::Box class is used internally to render a set of XML::TextElement. This works well for inline texts. 
Text::Formatted::Box also handles wrapping text so that overflowing text is automatically output on the next line instead of overflowing on the PDF page.

Inline HTML elements should be collected in an 'inline collection' until a block element is encountered. Each inline element captured should then be output using a single 
Text::Formatted::Box. Then the 'inline collection' should be cleared. 

### Block elements ###  
A block level element displays its child elements and then forces a newline effect. The break (BR) element can be seen as a block element with no child elements. 

### Images ###  
Images are displayed simply by calling image on the pdf with the uri the defines the image resource. Images are inline elements?

### Lists ###  
There will be support for ordered (OL) and unordered (UL) lists, including nested lists in any variation. 

* There will only be support for textual elements inside the lists. 
* We plan to create graphics for the various bullet styles. 
* We will support various numbering styles (number, roman, alphabet)
* We will ensure appropriate indentation at each nested list level.

### Tables ###  

There will be support for THEAD, TBODY, TFOOT and CAPTION. No support for 'colspan' (until supported natively by Prawn).

Create Table of Table::Cell::Text elements. Use 'new' Prawn striping styles such as :even and :odd to stripe rows in table. 
Note: There is also a new Image cell available.

## Changelog ##

May 22, 2010:
Joining forces with Anuj :)

May 21, 2010:
First version ready

May 20, 2010:
Abandoned old *prawn-html* project to instead focus on this project, which is a complete redesign.

## Note on Patches/Pull Requests ##
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
