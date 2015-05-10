---
title       : Developing Data Products
subtitle    : Pitch
author      : Allen Hammock
job         : devdataprod-014
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Read-And-Delete

1. Edit YAML front matter
2. Write using R Markdown
3. Use an empty line followed by three dashes to separate slides!

--- .class #id 

## Slide 2

Test to make sure R code executes.  Note, `slidify()` version 0.4.5 is not
working with the `stringr` package version 0.9.0.9000.  See 
[discussion on github](https://github.com/ramnathv/slidify/issues/407) for
details.  

Downgrading `stringr` to version 0.6.2 solves the problem for now.


```r
sessionInfo()$R.version$version.string
```

```
## [1] "R version 3.1.3 (2015-03-09)"
```
