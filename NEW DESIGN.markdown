# Overview

The Pdf to Html conversion process consists of two main parts. Processing and collecting state/style info from the HTML model 
followed by Rendering this collected state/style info. All of the HTML elements can be divided into either inline or block elements. 
Most HTML elements are purely textual in nature, with a few exceptions that require special care:

* Lists
* Tables
* Images
* Anchors
* Form elements

Note: Form elements will NOT be handled in the first release but are planned to be supported in a later release using a special Prawn addon for forms.

## Element

Each element is self-contained, in that it is only dependent on itself and child elements and not any other elements in the model for determining how it is to be displayed.
Thus the state collected should be contained in the scope of itself and child elements.

+I propose the following design to accommodate these facts:+
Each type of HTML element has a corresponding Processor and Renderer class. These classes/instances can often just be auto-generated from a configuration, but the class can always be overridden by a class implementation if needed.

<pre>
def block_tags   
  styles :prawn do 
    h1 :size  => 32, :styles => [:bold]
    h2 :size  => 26, :styles => [:bold, :italic]
    h3 :size  => 18, :styles => [:bold, :italic] 
  end
end

def inline_tags        
  styles :prawn do 
    b :styles => [:bold, :italic]
  end
  styles :css do   
    i {:font_style => 'italic' }  
  end
end
</pre>

The config hash would be used fx to define a method 'default_style' on a blank ElementProcessor class instance.

## Complex elements

Elements such as a Table are complex elements and require traversal of all its child elements in order to collect all the state and style info it needs to display itself. Therefore this subtree of related items needs a common state to access. But is element is only relevant for its ancestor nodes, the subtree is again self-contained. 
Each element should therefore have access to its parent element, using the proxy pattern. This way a state setter can be bubbled up the ancestor path using parent the proxy way.

### Table

The Table has the following structure:

* Caption
* Header
* Body
* Footer

Header, Body and Footer can all contain one or more rows. Caption is simply a text.

Appending a cell state found inside a table data (td) element to the table, could fx result in the following chain of calls. 
The current cell of the TableCellProcessor is added to a row array of the containing TableRowProcessor processor, and when the row is finished, this row is added to a rows 
array of the containing TableProcessor. There is also a distinct CaptionProcessor to process the caption for the table.
Style configurations can either be done using prawn or css style blocks.

<pre>
TableCellProcessor.add_cell current_cell

class TableRowProcessor
  attr_accessor :row_type

  ROW_TYPE_MAP = {'th' => :header, 'tr' => :body, 'tf' => :footer}

  def init
    row_type = ROW_TYPE_MAP[name]
  end

  def add_cell cell
    cells << cell
  end
  
  def done
    append_row row, row_type
  end
end


class TableProcessor
  attr_accessor :caption

  # have row containers for header, body and footer
  rows :header, :body, :footer 

  # append row to specific row container as indicated by position which is name of RowProcessor calling this method
  def append_row row, row_type
    send(row_type) << row
  end
end

class CaptionProcessor
  def done
    caption = text
  end
end

</pre>

### List
  
Lists follow the same model as table, but only with one sub level (items) instead of two (rows and cells). 
The current_item of the ListItemProcessor is added to items which is a proxy for the items array of the parent ListItemProcessor . 

<pre>
ListItem.add_item current_item
List.add_item item
</pre>

## Bridge processor

The Bridge (root) processor maintains the "global control". 

### Factory

The Bridge controls creation of Processors and Renderers by using a Factory (leveraging the FoxyFactory gem). This allows it to find classes/modules registered in the kernel without those constants having to be explicitly registered. When such a constant is found it is added to a constant cache for quicker retrieval in the future.

### Prawn Commander

Bridge also has a Prawn Commander which is used to log and then render commands to Prawn. The prawn command logging can be used for convenient testing and other purposes.
All processors and renders have direct access to the Bridge main processor through an instance variable :bridge, using the proxy pattern (by way of the ProxyParty gem).

## Processor

All processors are to inherit from an abstract ElementProcessor. From a processing perspective it makes no difference if an element is a block or an inline element.
There will be a special TextProcessor class for processing text elements. 

* TextProcessor
* ElementProcessor 

The ElementProcessor must collect and maintain style information in a style hash and merge the currently 'encountered style' with the 'previous style' to get the 'current style' to be used to render this element.

## Styles

Styles are handled by the css_prawn_styles gem, which handles conversion between css and prawn styles.

### Style processing

Each processor carries its own style information. The processor is given the style (inherits) from its parent processor and then merges its own style on top of this to result in the current_style to be by any renderer this processor directly initiates (to render itself). Each child processor is then passed this current_style in the same fashion.

## Special processors 

All special processors are subclasses of ElementProcessor as they all process elements.

* ListProcessor
* ListItemProcessor

* TableProcessor
* TableRowProcessor
* TableCellProcessor


* ImageProcessor
* AnchorProcessor

## Renderer

All renderers inherit from an abstract ElementRenderer. The first inclination might be to consider having class variants for both inline and block, but the difference is really minimal (positioning of the following element), so a boolean attribute should do until proven otherwise. This leads to the following design.
Processors and Renderers are 'joined at the hip'. The renderer must always be designed to render the state carried by the processor that calls it into action. Hence the renderer must have a reference variable to the initiating processor from creation.
There will be NOT be a special TextRenderer class since rendering text is always the responsibility of a containing element, an ElementRenderer.

* ElementRenderer

## Special renderers

All special processors are subclasses of ElementRenderer as they all render elements.

* ListRenderer
* ListItemRenderer
* TableRenderer
* ImageRenderer
* AnchorRenderer

The reason why list has a special ListItemRenderer is due to the fact that list items must currently be rendered on their own in Prawn. There is no special prawn command to render a list. Tables on the other hand can be rendered in one go in Prawn.

## List

Lists are divided into the following types

* Definition list
* Unordered list
* Ordered list

### Definition list

Definition lists are purely a textual construct with specific default styling and positioning, including indentation for each list item. 

### Ordered list

Ordered list labels each item with a successive number or letter. One such "numbering style" is roman numbers, and here a gem Romans is used.

### Unordered list 

Ordered list labels each item with graphic, fx a circle or a square. The ListItemRenderer must given a specific style render the appropriate graphic using a prawn "draw" command. 

# Processing

All processors, including the Bridge (root) processor follows the following processing algorithm:

<pre>
# Using FoxyFactory by proxy through bridge
processor = create_processor options

processor.bridge = bridge
processor.parent = self
processor.process do  
  ...
end
# only render after all processing has been done
processor.render 
# cleanup and/or transfer relevant state to parent processor
processor.done
             

class ElementProcessor
  proxy :before, :after

  def process(&block)
    before
    execute(block) if block && proces_children?
    after
  end    

  def execute(&block)
    block.arity < 1 ? self.instance_eval(&block) : block.call(self)
  end

  # override by subclass
  def process_children?
    true
  end     
end
</pre>    

<pre>
class TagProcessor

  def tag(tag_name, tag_options = {}, &block) 
    @tag_name = tag_name
    @tag_options = tag_options
   
    process_child_tags(block)
  end

  def process_child_tags(&block)
    tag_processor = create_tag_processor(tag_name, tag_options)
    tag_processor.process(block)
  end

  def render
    tag_renderer = create_tag_renderer(tag_name, tag_options)
    tag_renderer.render
  end
end
</pre>    

This can be used to simulate a HTML document in a DSL like fashion:

<pre>
tag :p do
  tag :div do
    text 'hello'
  end
end
</pre>    

## HTML document processing 

To process and convert a HTML document, it is best to parse and first convert the html text into a Ruby model. This can fx be done through use of the Nokogiri library.
Nokogiri supports decorating each of its classes. A nice and clean solution is to decorate XMLElement and TextElement with a process method to instantiate a TagProcessor for the element and execute it. This means that processing a html text is a wrapper for processing a Nokogiri model which again wraps the TagProcessor model.  

<pre>
class Bridge
  def cross html
    document_model = create_document_model(html)
    document_model.process        
  end
  
  def create_document_model(html)  
    model = model_creator.new html
  end
end
</pre>

The following are the required Nokogiri decorators:

<prw>
Howrah::Decorators::Nokogiri::Document
  def process
    css('html').first.process
  end
end

Howrah::Decorators::Nokogiri::XMLElement
  def process
    tag_processor = create_tag_processor(tag_name, tag_options)  
    tag_processor.process do
      with_children do |child| 
        child.process  
      end
    end
  end

  protected

  def with_children(&block)
    children.each do |child| 
      case child 
      XMLElement, TextElement
        yield child  
      end
    end
  end  
end

class Nokogiri::TextElement
  def process
    create_tag_processor(:text).process
  end
end
</pre>

Sweet :)