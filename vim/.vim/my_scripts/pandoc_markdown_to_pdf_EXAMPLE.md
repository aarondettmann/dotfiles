% Title
% Name of author
% Date

# H1 heading

## H2 heading

### H3 heading

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

## Styling text

- **This is bold text**
- *This text is italicized*
- ~~This was mistaken text~~
- **This text is _extremely_ important**

## Lists

- Mont Blanc
- Monte Rosa
- Dom

1. Charles Lindbergh
2. Steve Fossett
3. Mike Horn

**Nested lists**

1. First list item
   - First nested list item
     - Second nested list item

**Task lists**

- [x] Todo item 1
- [ ] Todo item 2
- [ ] Todo item 3

## Tables

First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column

## Other stuff

- Latex math mode: $\alpha \cdot \lambda \rightarrow 0$

- Pictures:

![This is a caption](example_img/file.jpg){ width=50% }

\newpage

- Source code

```C
/* fork bomb in C */

#include <stdio.h>
#include <sys/types.h>

int main()
{
    while(1) {
        fork();
    }
    return 0;
}
```

- Inline code: `cowsay "hello"`

- Links: [Wikipedia](wikipedia.org)

- Quotes:

> 123, abc

- Ignoring Markdown formatting: *Special characters* like \* have to be \*escaped\*

