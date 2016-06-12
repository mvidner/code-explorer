
# @param graph [Hash{String => Array<String>}] vertex -> reachable vertices
# @param hrefs [Hash{String => String}]        vertex -> href
def dot_from_hash(graph, hrefs = {})
  dot = ""
  dot << "digraph g {\n"
  dot << "rankdir=LR;\n"
  graph.keys.sort.each do |vertex|
    href = hrefs[vertex]
    href = "href=\"#{href}\" " if href

    dot << "\"#{vertex}\"[#{href}];\n"
    destinations = graph[vertex].sort
    destinations.each do |d|
      dot << "\"#{vertex}\" -> \"#{d}\";\n"
    end
  end
  dot << "}\n"
  dot
end
