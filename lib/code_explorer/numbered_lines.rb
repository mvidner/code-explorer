require "coderay"

# Convert plain text to HTML where lines are hyperlinkable.
# Emulate RFC 5147 fragment identifier: #line=42
def numbered_lines(text)
  # but CodeRay wants to remove the equal sign;
  tag = "lI" + "-Ne" # avoid the literal tag if we process our own source
  html = CodeRay.scan(text, :ruby).page(line_number_anchors: tag)
  html.gsub(tag, "line=")
end
