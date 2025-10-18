---
description: Generate Documentation Comments
model: haiku
allowed-tools:
  - Read
  - Write
---

## Purpose

Generate comprehensive documentation comments for code files using language-specific documentation standards. This command helps maintain code quality and readability by ensuring all public APIs and complex logic have clear, consistent documentation.

## Details and Instructions

Your goal is to add documentation comments to the provided code selection or all undocumented code blocks in the selection(s) or file(s).
Review attached file(s) and add docummentation comments to all logical parts of the code. Use the appropriate documentation style for the programming language of selection. For example:

- For Python, use triple quotes for docstrings: `""" """`
- For JavaScript/TypeScript, use JSDoc style comments: `/** */` with `@param`, `@returns`, `@example`, and other appropiate tags with example usages wrapped in corresponding language code blocks, e.g.:
  ```javascript
  /**
   * Adds two numbers together.
   *
   * @param {number} a - The first number.
   * @param {number} b - The second number.
   * @returns {number} The sum of the two numbers.
   *
   * @example
   * // returns 5
   * add(2, 3);
   */
  function add(a, b) {
    return a + b;
  }
  ```
- For Java, use JavaDoc comments: `/** */` with `@param`, `@return`, `@throws`, etc.
- For Go, use comment style: `// FunctionName does X` (starting with function name)
- Etc.

Apply comments directly above the relevant code elements (functions, classes, methods, etc.).

## What to Document

- **Public Functions/Methods**: All public-facing functions should have complete documentation
- **Classes/Interfaces**: Document the purpose and usage of custom types
- **Complex Logic**: Explain non-obvious algorithms, business logic, or edge cases
- **Parameters**: Document all parameters with type information and constraints
- **Return Values**: Clearly describe what is returned and when
- **Exceptions/Errors**: Document exceptions that can be thrown or error conditions
- **Important Constants**: Explain why constants exist and their significance

## What NOT to Document

- Simple getters/setters (unless they have special behavior)
- Loop counters and temporary variables
- Self-documenting code with clear variable names
- Inline implementation details that are obvious from reading the code

## Output Format

- Apply edits directly to the file(s)
- Maintain consistent formatting and indentation
- Preserve all existing code functionality
- Only modify comments, do not alter logic

## Rules

1. ALWAYS use the appropriate documentation style for the programming language of the selection.
2. ALWAYS ensure comments are clear, concise, and informative.
3. NEVER add comments to trivial code that is self-explanatory.
4. NEVER use emojis in comments.
5. NEVER add Claude, Claude Code, Openai, Codex, Opencode, or any other AI tool or
   agent as an author or a co-author of the comments or code.
6. Provide examples of usage in the comments where applicable.
7. If the programming language of the selection is not recognized, use plain English comments.
