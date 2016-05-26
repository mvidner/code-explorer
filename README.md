# Call Graph

This makes a call graph among methods of a single Ruby file.

I made it to help me orient myself in unfamiliar legacy code and to help
identify cohesive parts that could be split out.

Yes, it is quick and dirty.

## Requirements

- [parser gem](https://github.com/whitequark/parser)
- [Graphviz](http://www.graphviz.org/)

## License

MIT

## Example

[One file in YaST][p-rb] has around 2700 lines and 73 methods. The call graph
below was made with
```console
$ ./call-graph ../yast/packager/src/modules/Packages.rb
$ dot -Tpng -oPackages.png ../yast/packager/src/modules/Packages.dot
```

If the resulting size is too big, use ImageMagick:
```console
$ convert Packages.png -resize 1200 Packages-small.png
```

[p-rb]: https://github.com/yast/yast-packager/blob/a0b38c046e6e4086a986047d0d7cd5d155af5024/src/modules/Packages.rb

![Packages.png, an example output](example.png)
