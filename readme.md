Still Under developing..

# 1. Introduction about project
It's quite attractive to use amount of data including TCM(中医药, Tradition Chinese Medicine), formulas（药方）, ingredients, targets, and related disease to find active natural compounds or new drugs from our mother land.
However, as a beginner of bioinfomatic, I found most of Tradition Medicine databases (such as **herbs**, **TCMSP**, **ETCM**) are not very friendly to us. They don't service a interface for us to download all of their data. Or only give a single dataframe without same columns to combine each other.
![You can't get information about the ingredients are from which herbs ](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823214415.png)

So, I am going to use ==**R**== as my sword for taking this big challenge. Also, I can practice my web crawler skills.

# 2. Aims of This Project
In this project, I just want to crawl some main TCM database. 
Correct some mistakes, clean wrong data, reformat them into concise and elegant tibble/data.frame format.

# 3. Preparation
You can see the **01-preparation.R** file in the main directory. 
Besides, you need do more.
Here, we use Selenium Server in java environment.

The software we need are:
**_java_**, **_Selenium Server_**, **_chromedriver_**, **Google Chrome**, **R and R Studio**

## 3.1 Setting Java Environment
### How to check if I installed java or not?
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823220204.png)
Just searching **java** in your computer.

You can install the latest and free one in https://www.java.com/

### How to make sure Java is in my path environment variable, if not, how can I do?
- For Windows:
open your cmd, enter "java -version"

- For Mac os:
open your terminal, enter "java -version"
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823220956.png)

IF you don't have java in your path, you should add them.
(in case of you don't have java, please install it)

- For Windows:
answer in: https://explainjava.com/set-java-path-and-java-home-windows/

- For Mac os:
https://explainjava.com/set-java-home-mac-os

## 3.2 Selenium Server and Chromedriver

### Selenium Server
Here I quote a passage from RSelenium cran docs:
> Selenium Server is a standalone java program which allows you to run HTML test suites in a range of different browsers, plus extra options like reporting.

Our R packages run basically by this server.

You can get it from: http://www.seleniumhq.org/download/
Or http://selenium-release.storage.googleapis.com/index.html
### Chromedriver 
It's a driver we need for Chrome in order to run Selenium server.
http://chromedriver.storage.googleapis.com/
for mainland user, here is mirror (https://npm.taobao.org/mirrors/chromedriver)

Notably, we should download correct version of driver. 
You can check it in:
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823222711.png)

## 3.3 Run RSelenium
After downloading, you should run both Selenium Server and Chromedriver in your terminal or cmd:
```
java -Dwebdriver.chrome.driver="/Path/to/your/chromedriver" -jar /Path/to/your/selenium-server-standalone-3.141.59.jar
```
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823223443.png)


At the start, I mentioned **01-preparation.R**.

If you successfully run RSelenium in R, you will see a browser opened.
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823223601.png)

Have a try and enjoy it!
It's finished by RSelenium remote control!
![](https://cdn.jsdelivr.net/gh/mugpeng/my-gallery-01/picgo_image/20210823224228.png)

# 4. Script Introduction
Each step has its own R script.

# 5. Prospection
I will develop a R package for storing, sharing, achieving, visualizing TCM database data.

