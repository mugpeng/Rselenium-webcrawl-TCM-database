##################################################
## Project: Rselenium-crawler-tcm-database
## File name: 03-Rselenium-scrapy-ingredient-targets.R
## Date: Mon Aug 23 21:22:19 2021
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

# install_github("crubba/Rwebdriver")

# 1. create Rselenium ----
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "chrome")

remDr$open() ## open your chrome browser

# 2. source related function ----
source('./Rscript/related-function.R')

# 3. Preparation input data ----
## ID
raw_ID <- 1:12933
digits_ID <- nchar("000003")
Targets_ID <- case_when(
  nchar(raw_ID) %in% 1 ~ paste0(paste(rep(0, digits_ID - 1), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 2 ~ paste0(paste(rep(0, digits_ID - 2), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 3 ~ paste0(paste(rep(0, digits_ID - 3), collapse = ""), raw_ID),
  nchar(raw_ID) %in% 4 ~ paste0(paste(rep(0, digits_ID - 4), collapse = ""), raw_ID)
)

Targets_Url <- sprintf('http://herb.ac.cn/Detail/?v=HBTAR%s&label=Target', Targets_ID)

## empty list with pre-defined length
my_list <- vector("list", length = length(Targets_ID))

## define each xpaths
child_xpath_number <- c('//*[@id="root"]/section/main/div/div[1]/div[4]/div/div[3]/div/div[2]/div/div[1]/div/div/ul/li[1]')
parent_xpath <- '//*[@id="root"]/section/main/div/div[1]/div[2]/div/div/ul/li[1]/span[1]/span'
xpath_table <- c('//*[@id="root"]/section/main/div/div[1]/div[4]/div/div[3]/div/div[2]/div/div[1]/div/div/div/div')
childNextBin_xpath <- c('//MAIN[@class="ant-layout-content"]/DIV[1]/DIV[1]/DIV[4]/DIV[1]/DIV[3]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/UL[1]/LI[10]/A[1]',
                        '//MAIN[@class="ant-layout-content"]/DIV[1]/DIV[1]/DIV[4]/DIV[1]/DIV[3]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/UL[1]/LI[7]/A[1]',
                        '//MAIN[@class="ant-layout-content"]/DIV[1]/DIV[1]/DIV[4]/DIV[1]/DIV[3]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/UL[1]/LI[5]/A[1]',
                        '//MAIN[@class="ant-layout-content"]/DIV[1]/DIV[1]/DIV[4]/DIV[1]/DIV[3]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/UL[1]/LI[5]/A[1]')


# 4. start crawling ----
source("./Rscript/main-function.R")
## for start to end 
my_scrapy(173,length(Targets_ID), Targets_ID, 
          Targets_Url, "HBTAR", "Ingredient-Target")

# 5. save temporary file----
save(Targets_list, file = "./backup/targets/targets_list_4001-4279.Rda")


