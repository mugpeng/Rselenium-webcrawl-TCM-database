##################################################
## Project: Rselenium-scrapy-herbs-database
## File name: 02-Rselenium-scrapy-herbs-ingredient.R
## Date: Sun Aug 22 09:33:15 2021
## Author: Peng
## R_Version: R version 4.0.5 (2021-03-31)
## R_Studio_Version: 1.4.1106
## Platform Version: macOS Mojave 10.14.6
##################################################
rm(list = ls())

# 0.  packages loaded && data preparation ----
my_packages<- c("devtools", "Rwebdriver",
                "RSelenium", "rvest", "tidtverse")
tmp <- sapply(my_packages, function(x) library(x, character.only = T)); rm(tmp)

# 1. create Rselenium ----
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "chrome")

remDr$open() ## open your chrome browser

# 2. define related function ----
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
makePageUp <- function(remDr, my_xpath){
  childNextBin <- remDr$findElement(using ='xpath',
                                    value = my_xpath)
  childNextBin$clickElement()
  ## because taking next page, read again
  webpage <- read_html(remDr$getPageSource()[[1]][1])
  return(webpage)
}
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

# 3. scrapy each herbs data and their parents ID ----
## herbs ID
raw_ID <- 1:7263
digits_ID <- nchar("000003")
herbs_ID <- case_when(
  nchar(raw_ID) %in% 1 ~ paste0(paste(rep(0, digits_ID - 1), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 2 ~ paste0(paste(rep(0, digits_ID - 2), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 3 ~ paste0(paste(rep(0, digits_ID - 3), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 4 ~ paste0(paste(rep(0, digits_ID - 4), collapse = ""), raw_ID)
)

Herbs_Url <- sprintf('http://herb.ac.cn/Detail/?v=HERB%s&label=Herb', herbs_ID)

herbs_list <- vector("list", length = length(herbs_ID))
# i <- 3

## define each xpaths
child_xpath_number <- c('//LI[@class="ant-pagination-total-text"]',
                        '//MAIN[@class="ant-layout-content"]/DIV[1]/DIV[1]/DIV[4]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/UL[1]/LI[1]',
                        '//*[@id="root"]/section/main/div/div[1]/div[4]/div/div/div/div[1]/div/div/ul/li[1]',
                        '//*[@id="root"]/section/main/div/div[1]/div[3]/div/div/div/div[1]/div/div/ul/li[1]')
parent_xpath <- '//*[@id="root"]/section/main/div/div[1]/div[2]/div/div/ul/li[1]/span[1]/span'
xpath_table <- c('//*[@id="root"]/section/main/div/div[1]/div[4]/div/div/div/div[1]/div/div/div/div',
                 '//*[@id="root"]/section/main/div/div[1]/div[3]/div/div/div/div[1]/div/div/div/div')
childNextBin_xpath <- '//LI[@class=" ant-pagination-next"]/A[1]'

my_scrapy <- function(my_start, my_end) {
  for (i in my_start:my_end){
    ## get and access url
    my_Herb_ID <- paste0("HERB", herbs_ID[i])
    herbs_list[[i]]$my_Herb_ID <<- my_Herb_ID
    my_Url <- Herbs_Url[i]
    herbs_list[[i]]$my_Herb_url <<- my_Url
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
      herbs_list[[i]]$my_status <<- "no-page-counts"; next
    }
    ## get parent id(like herbs id)
    parent_nodes <- html_nodes(webpage, xpath = parent_xpath)
    parent_ID <- html_text(parent_nodes)
    herbs_list[[i]]$my_parent_ID <<- parent_ID
    ## test table xpath
    test_result <- testTableXpath(xpath_table, webpage)[[1]]
    table_xpath <- testTableXpath(xpath_table, webpage)[[2]]
    ## scrapy page info if test result is ok
    if (test_result) {
      child_tables <- getTable(table_xpath, childNextBin_xpath, child_page_counts, 
                               webpage, remDr)
      herbs_list[[i]]$my_child_table <<- child_tables
      my_status <- nrow(child_tables) 
    } else {
      print(paste0("No data for ", i))
      herbs_list[[i]]$my_status <<- "no-data-tables"; next
    }
    ## check scrapy status
    herbs_list[[i]]$my_status <<- if(my_status == child_number_counts) "OK" else "no-OK" 
    print(paste0("Finished ", i))
  }
}
my_scrapy(1, length(herbs_ID))

# 4. save temporary file----
save(Targets_list, file = "./backup/targets_list_4001-4279.Rda")

