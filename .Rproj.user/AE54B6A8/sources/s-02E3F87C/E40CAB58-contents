##################################################
## Project: Rescue the Princess
## File name: 01-test.R
## Date: Sat Aug 21 20:15:26 2021
## Author: Peng
## R_Version: R version 4.0.5 (2021-03-31)
## R_Studio_Version: 1.4.1106
## Platform Version: macOS Mojave 10.14.6
##################################################
rm(list = ls())

# 1. install related packages ----
install_github("crubba/Rwebdriver")
install.packages("RSelenium")
install.packages("rvest")

# 2. test RSelenium is ok or not ----
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "chrome")

remDr$open() ## open your chrome browser

# 3. A very beginning test ----
remDr$navigate("https://cn.bing.com/") # first step
webElem <- remDr$findElement(using = "xpath", '//*[@id="sb_form_q"]')
webElem$getElementAttribute("name")
webElem$sendKeysToElement(list("mugpeng yuque")) 
# enter string into your searching box