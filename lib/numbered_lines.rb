
# relies on escape_html

# convert plain text to HTML where lines are hyperlinkable (emulate RFC 5147)
def numbered_lines(text)
  lines = text.lines
  count_width = lines.count.to_s.size
  lines.each_with_index.map do |line, i|
    i += 1 # lines are counted from 1

    show_line_num = i.to_s.rjust(count_width).gsub(" ", "&nbsp;")
    escaped_line = escape_html(line.chomp).gsub(" ", "&nbsp;")
    id = "line=#{i}" # RFC 5147 fragment identifier

    "<tt><a id='#{id}' href='##{id}'>#{show_line_num}</a></tt> " \
      "<code>#{escaped_line}</code><br>\n"
  end.join("")
end
