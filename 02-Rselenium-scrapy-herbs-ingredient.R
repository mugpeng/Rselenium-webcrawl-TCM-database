##################################################
## Project: Rselenium-crawler-tcm-database
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
                "RSelenium", "rvest", "tidyverse")
tmp <- sapply(my_packages, function(x) library(x, character.only = T)); rm(tmp)

# 1. create Rselenium ----
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "chrome")

remDr$open() ## open your chrome browser

# 2. source related function ----
source('./Rscript/related-function.R')

# 3. Preparation input data ----
## ID
raw_ID <- 1:7263
digits_ID <- nchar("000003")
herbs_ID <- case_when(
  nchar(raw_ID) %in% 1 ~ paste0(paste(rep(0, digits_ID - 1), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 2 ~ paste0(paste(rep(0, digits_ID - 2), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 3 ~ paste0(paste(rep(0, digits_ID - 3), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 4 ~ paste0(paste(rep(0, digits_ID - 4), collapse = ""), raw_ID)
)

Herbs_Url <- sprintf('http://herb.ac.cn/Detail/?v=HERB%s&label=Herb', herbs_ID)

## empty list with pre-defined length
my_list <- vector("list", length = length(herbs_ID))
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

# 4. start crawling ----
source("./Rscript/main-function.R")
## for start to end 
my_scrapy(173,length(Targets_ID), herbs_ID, 
          Herbs_Url, "HERB", "Herb-Ingredient")

# 5. save temporary file----
# save(herbs_list, file = "./backup/targets_list_4001-4279.Rda")


