# Example

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur rutrum sapien metus, quis porta felis dignissim a. Mauris auctor pretium sodales. Vestibulum efficitur tristique ligula eu mattis. Donec iaculis interdum justo. Etiam at tempor tortor. Cras a malesuada nisi. Praesent at diam purus. Aliquam aliquet felis dictum est pulvinar imperdiet. Sed condimentum elementum urna eu commodo. Maecenas facilisis nibh velit. Proin quis accumsan urna. Aliquam cursus leo eget est faucibus, sit amet mattis elit pulvinar. Nunc eu interdum justo, at imperdiet tellus.

```@eval
# Note: we need to prefix the `collapsed_codeblock` function with Main
# because all at-blocks get evaluated in generated modules.
Main.collapsed_codeblock(
    title = "Title line",
    code = """
    map([A, B, C]) do x
        if x < 0 && iseven(x)
            return 0
        elseif x == 0
            return 1
        else
            return x
        end
    end
    """
)
```

Suspendisse eros dui, facilisis eu consectetur a, pulvinar ac tellus. Phasellus mollis tincidunt leo id sodales. Curabitur aliquam, lectus vel lobortis mattis, mi augue aliquam turpis, et consequat urna erat egestas mauris. Pellentesque aliquet libero ex, eget rhoncus arcu vestibulum eu. Aenean in tellus vitae tortor ultrices interdum vitae sed quam. Integer tristique interdum orci, ac facilisis lorem posuere sit amet. Sed non venenatis quam. Ut vel arcu vitae metus bibendum dictum laoreet vitae quam. Fusce dapibus, ex euismod finibus luctus, est metus interdum ipsum, vel tristique nunc urna vel mauris. Etiam lacus magna, congue eu lorem nec, maximus aliquet felis. Donec congue justo gravida, dapibus ante in, bibendum libero. Vestibulum placerat velit et hendrerit auctor.
