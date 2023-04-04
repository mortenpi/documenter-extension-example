# This example demos how to use Documenter's @eval blocks to include
# arbitrary, generated HTML in a Documenter build.
#
# Note: this only works with Documenter#master currently (i.e. 0.28/1.0).
# More specifically, it requires the mp/at-eval-html branch:
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

# Standard makedocs invocation, no magic necessary here.
makedocs(
    sitename = "Extension example",
)

# This is just to automatically deploy the example to gh-pages of this repo:
deploydocs(
    repo = "github.com/mortenpi/documenter-extension-example.git",
    branch = "master",
    versions = nothing,
)
