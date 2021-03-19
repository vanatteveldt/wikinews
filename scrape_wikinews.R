#! /usr/bin/env Rscript
library(glue)

### Command line invokation
options <- commandArgs(trailingOnly = TRUE)
if (length(options) != 1) stop("Usage: Rscript scrape_wikinews.R YEAR")
year = as.numeric(options[1])
message(glue("Will scrape from https://en.wikinews.org/wiki/Category:{year}"))
###

suppressMessages(library(tidyverse))
suppressMessages(library(rvest))

get_subcats = function(cat) {
  glue("https://en.wikinews.org/{cat}") %>% read_html() %>% html_nodes(css=".mw-category-group a") %>% html_attr("href")
}

get_pages = function(cat) {
  glue("https://en.wikinews.org/{cat}") %>% read_html() %>% html_nodes(css="#mw-pages a") %>% html_attr("href")
}

scrape_page = function(page) {
  url = glue("https://en.wikinews.org/{page}") 
  p = read_html(url)
  date = p %>% html_node(".published span") %>% html_attr("title")
  title = p %>% html_node("#firstHeading") %>% html_text()
  text = p %>% html_nodes(".mw-parser-output p") %>% html_text()
  n = which(str_detect(text, "Have an opinion on this story\\? Share it!"))
  if (length(n) > 0) text = text[1:(n-1)]
  if (str_detect(text[1], "^\\w+day, \\w+ \\d+, 2020\\s*$")) text=text[2:length(text)]
  text = str_c(text, collapse="\n\n")
  tibble(url=url, date=date, title=title, text=text)
}

scrape_year = function(year) {
  all_cats = c()
  for (cat in get_subcats(glue("wiki/Category:{year}"))) 
    for (subcat in get_subcats(cat))
      all_cats = c(all_cats, subcat)
  message(glue("Scraping {length(all_cats)} categories"))
  pages = unlist(purrr::map(all_cats, get_pages))
  message(glue("Scraping {length(pages)} pages"))
  purrr::map_df(pages, scrape_page)
}

articles = scrape_year(year) 
fn = glue("data/wikinews_{year}.csv")
message(glue("Writing {nrow(articles)} to {fn}"))
write_csv(articles, fn)

