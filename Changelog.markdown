June 25,
Howrah split into multiple sub-components (gems), including Processor and Renderer. Howrah will be a thin controller to initiate Processor which does the main processing
and handles rendering (through use of Renderer) as part of the process. Splitting up in submodules makes responsibilities much clearer, makes it easier to mock and stub dependencies and makes the development process less complex and more flexible in general!
--
Kristian

June 2, 2010:
Major refactorings done. 

* Element handlers split into Processors and Renderers
  - Most tags only need a Processor to modify the shared state.
  - A few tags need a Processor to take current shared state and render, then clean state.
* State Manager handlers all state
* Generator renamed to Bridge, maybe should have method 'cross' ?

Major TODO:
Cleanup howrah/element folder using spec driven dev.

May 25, 2010:
Added Bundler support.

May 22, 2010:
Joining forces with Anuj to create a better extensible library, distributed as a rubygem :)

May 21, 2010:
First version ready, without any specs. Still very experimental at this stage.

May 20, 2010:
Abandoned old *prawn-html* project to instead focus on this project, which is a complete redesign.