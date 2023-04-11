# This example demos how to use Documenter's @eval blocks to include
# arbitrary, generated HTML in a Documenter build.
#
# Note: this only works with Documenter#master currently (i.e. 0.28/1.0).
# More specifically, it requires the mp/at-eval-html branch:
#
# https://github.com/JuliaDocs/Documenter.jl/compare/mp/at-eval-html
#
# Demo is deployed at:
#
# https://github.com/JuliaDocs/Documenter.jl/compare/mp/at-eval-html
#
using Documenter

# This is an example function that generates a collapsed code block, by
# wrapping a `<pre>` tag in `<details>`. This function can be called in
# an @eval block in the document (see `src/index.md`).
function collapsed_codeblock(; title, code)
    # The HTML here is just a simple demo. This could potentially be complex
    # generated HTML.
    #
    # Note: if there is some scaffolding needed (e.g. JS or CSS shared by many
    # @eval block instances), it could be generated in "setup" @eval block.
    #
    # ```@eval
    # Main.my_element_scaffolding() # generates JS/CSS
    # ```
    # ```@eval
    # Main.my_element(1) # generates the actual page element
    # ```
    # ```@eval
    # Main.my_element() # generates a different version of the page element
    # ```
    html = """
    <details style="padding: 1rem; border: 1px solid black;">
        <summary>$(title)</summary>
        <pre>$(code)</pre>
    </details>
    """
    # This is the magic part that allows this to integrate with Documenter.
    # Documenter.MultiOutputElement is the MarkdownAST element that Documenter
    # uses internally to store and later display showable() objects in @example
    # block outputs.
    #
    # Note: this could also be made to work with the PDF/LaTeX generator, by adding
    # a MIME"text/latex" => ... pair.
    return Documenter.MultiOutputElement(
        Dict{MIME,Any}(
            MIME"text/html"() => html
        )
    )
end

# Example #2: collapsed example block with code evalulation
using Documenter: MarkdownAST, DOM
using Documenter.HTMLWriter: DCtx
using Documenter.MarkdownAST: Node
# This digs deeper into Documenter internals, by defining a new at-block that gets evaluated
# during the Documenter "expansion" step. The expansion of CollapsedExample re-uses the
# standard runner for @example blocks, but creates a custom MarkdownAST block, which then
# is dispatched on in the HTMLWriter (domify).
abstract type CollapsedExample <: Documenter.Expanders.ExpanderPipeline end
Documenter.Selectors.matcher(::Type{CollapsedExample}, node, page, doc) = Documenter.Expanders.iscode(node, "@collapsed-example")
Documenter.Selectors.order(::Type{CollapsedExample}) = 7.9
function Documenter.Selectors.runner(::Type{CollapsedExample}, node, page, doc)
    # The ExampleBlocks runner will fail, unless the code block language is `@example *`,
    # so we override it here.
    node.element.info = "@example"
    Documenter.Selectors.runner(Documenter.Expanders.ExampleBlocks, node, page, doc)
    # Runner will set node.elements to be Documenter.MultiOutput, which we will replace
    # with CollapsedOutput.
    node.element = CollapsedOutput(node.element.codeblock)
    return
end
# This is the MarkdownAST element that replaces Documenter.MultiOutput so that we could
# dispatch on it in the writer.
struct CollapsedOutput <: Documenter.AbstractDocumenterBlock
    codeblock :: MarkdownAST.CodeBlock
end
function Documenter.HTMLWriter.domify(dctx::DCtx, node::Node, ::CollapsedOutput)
    DOM.@tags details summary
    # Documenter.MultiOutput has two types of children nodes: MarkdownAST.CodeBlock
    # is assumed to be the input code block (which gets surrounded by `<details>`),
    # and others should be Documenter.MultiOutputElement, which are the ouputs.
    # We'll use the standard domify() methods for the latter.
    map(node.children) do node
        if node.element isa MarkdownAST.CodeBlock
            details[:style=>"padding: 1rem; border: 1px solid black;"](
                summary("Click here to see code."),
                Documenter.HTMLWriter.domify(dctx, node)
            )
        else
            Documenter.HTMLWriter.domify(dctx, node)
        end
    end
end


# Standard makedocs invocation, no magic necessary here.
makedocs(
    sitename = "Extension example",
)

# This is just to automatically deploy the example to gh-pages of this repo:
deploydocs(
    repo = "github.com/mortenpi/documenter-extension-example.git",
    versions = nothing,
)
