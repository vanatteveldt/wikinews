[![License: CC BY 2.5](https://img.shields.io/badge/License-CC%20BY%202.5-green.svg)](https://creativecommons.org/licenses/by/2.5/)
# Wikinews sample articles

This repository contains articles from wikinews that can be useful if you need example news articles. 

To my best knowledge, the wikinews articles are licensed [CC-BY](https://creativecommons.org/licenses/by/2.5/), so can easily be used in examples. 

It also contains a simple R script used to scrape the wikinews articles (since I'm too stupid to understand wiki exporting):

```
$ Rscript scrape_wikinews.R 2019
Will scrape from https://en.wikinews.org/wiki/Category:2019
Scraping 365 categories
Scraping 171 pages
Writing 171 to wikinews_2019.csv
```
