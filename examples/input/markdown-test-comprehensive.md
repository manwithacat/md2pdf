# Comprehensive Markdown Test Document

This document exercises all standard Markdown features plus common extensions to test PDF rendering quality.

## Table of Contents

- [Headers](#headers)
- [Paragraphs and Line Breaks](#paragraphs-and-line-breaks)
- [Emphasis](#emphasis)
- [Lists](#lists)
- [Links](#links)
- [Images](#images)
- [Code](#code)
- [Tables](#tables)
- [Blockquotes](#blockquotes)
- [Horizontal Rules](#horizontal-rules)
- [Special Characters](#special-characters)

---

## Headers

# H1 Header
## H2 Header
### H3 Header
#### H4 Header
##### H5 Header
###### H6 Header

Alternative H1
==============

Alternative H2
--------------

## Paragraphs and Line Breaks

This is a paragraph with standard text. It contains multiple sentences to demonstrate proper paragraph formatting. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

This is a second paragraph. Paragraphs are separated by blank lines. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

This paragraph has a hard line break.
It continues on the next line after two trailing spaces.

## Emphasis

*This text is italicized with asterisks*

_This text is italicized with underscores_

**This text is bold with asterisks**

__This text is bold with underscores__

***This text is bold and italic***

~~This text has strikethrough~~ (if supported)

## Lists

### Unordered Lists

* Item 1
* Item 2
* Item 3
  * Nested item 3.1
  * Nested item 3.2
    * Double nested item 3.2.1

- Alternative dash syntax
- Item 2
- Item 3

+ Alternative plus syntax
+ Item 2
+ Item 3

### Ordered Lists

1. First item
2. Second item
3. Third item
   1. Nested item 3.1
   2. Nested item 3.2
      1. Double nested item 3.2.1

### Mixed Lists

1. First ordered item
2. Second ordered item
   * Unordered sub-item
   * Another sub-item
3. Third ordered item

### Task Lists (if supported)

- [x] Completed task
- [ ] Incomplete task
- [ ] Another incomplete task

## Links

### Inline Links

This is [an inline link](https://www.example.com).

This is [a link with title](https://www.example.com "Example Title").

### Reference Links

This is [a reference link][ref1].

This is [another reference][ref2].

This is a [shortcut reference link].

[ref1]: https://www.example.com "Example Reference 1"
[ref2]: https://www.example.com "Example Reference 2"
[shortcut reference link]: https://www.example.com

### Automatic Links

<https://www.example.com>

<email@example.com>

## Images

![Alt text for image](https://via.placeholder.com/150 "Image Title")

![Alt text with reference][image-ref]

[image-ref]: https://via.placeholder.com/150 "Referenced Image"

## Code

### Inline Code

Use `backticks` for inline code. Here's a function call: `print("Hello World")`.

The `printf()` function outputs formatted text.

### Code Blocks

Indented code block (4 spaces or 1 tab):

    def hello_world():
        print("Hello, World!")
        return True

Fenced code block with syntax highlighting:

```python
def fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Test the function
result = fibonacci(10)
print(f"Fibonacci(10) = {result}")
```

```javascript
function calculateTotal(items) {
  return items.reduce((sum, item) => {
    return sum + item.price * item.quantity;
  }, 0);
}

const cart = [
  { name: "Apple", price: 1.50, quantity: 3 },
  { name: "Banana", price: 0.75, quantity: 5 }
];

console.log("Total:", calculateTotal(cart));
```

```bash
#!/bin/bash
# Example bash script
for file in *.md; do
  echo "Processing: $file"
  pandoc "$file" -o "${file%.md}.pdf"
done
```

## Tables

### Simple Table

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
| Cell 7   | Cell 8   | Cell 9   |

### Table with Alignment

| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Left         | Center         | Right         |
| Text         | Text           | Text          |
| 123          | 456            | 789           |

### Complex Table with Unicode

| Feature | Chrome Backend | Typst Backend | LaTeX Backend |
|---------|----------------|---------------|---------------|
| Color Emoji 🎨 | ✅ Native | ⚠️ Limited | ❌ Mapped |
| Speed | ⚡ Fast (2-5s) | ⚡ Fast (2-4s) | 🐢 Slower (5-10s) |
| Setup | ✅ Zero | 📦 `brew install` | 📦 Large (~1-7GB) |
| Math | ❌ Limited | ✅ Good | ✅ Excellent |
| Cost (£) | Free | Free | Free |
| Cost (₹) | मुफ्त | मुफ्त | मुफ्त |

## Blockquotes

### Simple Blockquote

> This is a blockquote. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

### Multi-paragraph Blockquote

> This is the first paragraph of a blockquote.
>
> This is the second paragraph. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

### Nested Blockquotes

> This is the first level of quoting.
>
> > This is nested blockquote.
> >
> > > This is a third level nested blockquote.
>
> Back to first level.

### Blockquote with Other Elements

> ## Header in Blockquote
>
> This blockquote contains other markdown elements:
>
> * List item 1
> * List item 2
>
> With `inline code` and **bold text**.

## Horizontal Rules

Three or more hyphens:

---

Three or more asterisks:

***

Three or more underscores:

___

## Special Characters

### Typography

- Em dash: —
- En dash: –
- Ellipsis: …
- "Smart quotes"
- 'Single smart quotes'

### Escaping Characters

\*Not italic\*

\[Not a link\]

\`Not code\`

### HTML Entities

&copy; Copyright 2024

&trade; Trademark

&reg; Registered

### Mathematical Symbols

x² + y² = z²

∑ ∫ ∞ ≈ ≠ ≤ ≥

### Currency Symbols

Dollar: $100.00

Pound: £99.99

Euro: €50.00

Yen: ¥1000

Rupee: ₹500

### Emoji Support

Happy: 😊 Sad: 😢 Rocket: 🚀

Checkmark: ✅ Cross: ❌ Warning: ⚠️

Star: ⭐ Heart: ❤️ Trophy: 🏆

Code: 💻 Document: 📄 Chart: 📊

### International Characters

**Latin:** café, naïve, résumé

**German:** Straße, Äpfel, Über

**French:** œuvre, ça, Français

**Spanish:** niño, señor, años

**Scandinavian:** København, Göteborg, Ålesund

**Greek:** α β γ δ ε

**Cyrillic:** Привет мир

**Chinese:** 你好世界

**Japanese:** こんにちは世界

**Korean:** 안녕하세요 세계

**Arabic:** مرحبا بالعالم

**Hebrew:** שלום עולם

## Definition Lists (if supported)

Term 1
:   Definition for term 1

Term 2
:   First definition for term 2
:   Second definition for term 2

## Footnotes (if supported)

This is a sentence with a footnote.[^1]

This is another sentence with a footnote.[^2]

[^1]: This is the first footnote.
[^2]: This is the second footnote with more text.

## Subscript and Superscript (if supported)

Water formula: H~2~O

Exponential: x^2^ + y^2^ = r^2^

## Abbreviations (if supported)

The HTML specification is maintained by the W3C.

*[HTML]: Hyper Text Markup Language
*[W3C]: World Wide Web Consortium

---

## Document Metadata Test

**Author:** Markdown Test Suite
**Date:** 2024-11-07
**Version:** 1.0
**License:** MIT

---

## Testing Long Content

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

---

**End of Comprehensive Markdown Test Document** ✅
