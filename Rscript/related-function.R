##################################################
## Project: Rselenium-crawler-tcm-database
## File name: related-function.R
## Date: Tue Aug 24 11:11:19 2021
## Author: Peng
## R_Version: R version 4.0.5 (2021-03-31)
## R_Studio_Version: 1.4.1106
## Platform Version: macOS Mojave 10.14.6
##################################################

# 1. gotPageNumber ----
## We need get total number of table in each page,
## so it will be easy for us to turn page
gotPageNumber <- function(remDr, my_xpath) {
  ## get parent ID and page count
  webpage <- read_html(remDr$getPageSource()[[1]][1])
  for (i1 in my_xpath) {
    child_nodes <- html_nodes(webpage, xpath = i1)
    child_number_counts <- html_text(child_nodes)
    ## if child_number_counts has an element, break loop
    if (!is.na(child_number_counts[1])) break
  }
  ## if child_number_counts has an element
  if (!is.na(child_number_counts[1])) {
    child_number_counts <- as.numeric(gsub(" items", "", child_number_counts))
    child_page_counts <- ceiling(child_number_counts/5)
  } else child_page_counts <- NA
  return(list(child_page_counts, child_number_counts))
}

# 2. testTableXpath ----
## We find the target element by xpath
## But the Xpath is uncertain and changeable, it's better to test it before catch it
testTableXpath <- function(my_xpath, webpage){
  for (a1 in my_xpath) {
    table_nodes <- html_nodes(webpage, xpath = a1)
    ## test if table_nodes collect by html_table
    result <- tryCatch({html_table(table_nodes)}, error = function(e){0})
    if (!is.numeric(result)){
      tables <- html_table(table_nodes)
      ## then test if data in tables
      result <- tryCatch({tables[[1]]}, error = function(e){0})
      if (is.data.frame(result)) result = 1
      if (result) {break} ## break if xpath is ok
    }
  }
  return(list(result, a1)) ## return status code
}

# 3. testPageXpath ----
## same reason like testTableXpath
testPageXpath <- function(my_xpath, remDr){
  for (a2 in my_xpath) {
    ## test if next page button exist
    result <- remDr$findElements(using ='xpath',
                                 value = a2)
    result <- tryCatch({result[[1]]}, error = function(e){0})
    if (isS4(result)){
      result <- 1; break ## break if xpath is ok
    }
  }
  return(list(result, a2)) ## return status code
}

# 4. makePageUp ----
## If you can turn page, you got nothing but a silence
makePageUp <- function(remDr, my_xpath){
  childNextBin <- remDr$findElement(using ='xpath',
                                    value = my_xpath)
  childNextBin$clickElement()
  ## because taking next page, read again
  webpage <- read_html(remDr$getPageSource()[[1]][1])
  return(webpage)
}

# 5. getTable ----
## get each table, and return combined one
getTable <- function(my_xpath, nextBin_path, my_count, my_page, remDr){
  my_list <- list()
  for (a in seq(my_count)){
    table_nodes <- html_nodes(my_page, xpath = my_xpath)
    tables <- html_table(table_nodes)
    tables <- tables[[1]]
    my_list[[a]] <- tables
    if(my_count > 1 & a < my_count){
      my_page <- makePageUp(remDr, nextBin_path)
      Sys.sleep(3)
    }
  }
  my_table <- do.call("rbind", my_list)
  return(my_table)
}