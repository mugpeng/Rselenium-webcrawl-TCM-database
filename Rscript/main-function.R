##################################################
## Project: Rselenium-crawler-tcm-database
## File name: main-function.R
## Date: Tue Aug 24 11:11:28 2021
## Author: Peng
## R_Version: R version 4.0.5 (2021-03-31)
## R_Studio_Version: 1.4.1106
## Platform Version: macOS Mojave 10.14.6
##################################################

my_scrapy <- function(my_start, my_end, 
                      my_ID, my_url,
                      my_catagory, my_type) {
  for (i in my_start:my_end){
    ## get and access url
    my_list[[i]]$my_type <<- my_type
    ID <- paste0(my_catagory, my_ID[i])
    my_list[[i]]$my_ID <<- ID
    my_Url <- my_url[i]
    my_list[[i]]$my_url <<- my_Url
    remDr$navigate(my_Url)
    Sys.sleep(2)
    ## get page html
    webpage <- read_html(remDr$getPageSource()[[1]][1])
    ## get Page&&number count 
    child_page_counts <- gotPageNumber(remDr, child_xpath_number)[[1]]
    child_number_counts <- gotPageNumber(remDr, child_xpath_number)[[2]]
    ## if child_page_counts is null, the page may have problem, kill loop
    if (is.na(child_page_counts)) {
      print(paste0("No data for ", i))
      my_list[[i]]$my_status <<- "no-page-counts"; next
    }
    ## get parent id(like herbs id)
    parent_nodes <- html_nodes(webpage, xpath = parent_xpath)
    parent_ID <- html_text(parent_nodes)
    my_list[[i]]$my_page_ID <<- parent_ID
    ## test table xpath
    test_result <- testTableXpath(xpath_table, webpage)[[1]]
    table_xpath <- testTableXpath(xpath_table, webpage)[[2]]
    test_result2 <- testPageXpath(childNextBin_xpath, remDr)[[1]]
    page_xpath <- testPageXpath(childNextBin_xpath, remDr)[[2]]
    ## scrapy page info if test result is ok
    if (test_result) {
      child_tables <- getTable(table_xpath, page_xpath, child_page_counts, 
                               webpage, remDr)
      my_list[[i]]$my_child_table <<- child_tables
      my_status <- nrow(child_tables) 
    } else {
      print(paste0("No data for ", i))
      my_list[[i]]$my_status <<- "no-data-tables"; next
    }
    ## check scrapy status
    my_list[[i]]$my_status <<- if(my_status == child_number_counts) "OK" else "no-OK" 
    print(paste0("Finished ", i))
  }
}
