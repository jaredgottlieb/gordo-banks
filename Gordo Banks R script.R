#install.packages(c("rvest", "qdap","dplyr","stringr"))

library(rvest)
library(qdap)
require(dplyr)
require(stringr)

scrape_gordo1 <- function(url){
  gb_scrape <- read_html(url)
  # variables that we're interested in
  write_date <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[1]/header/div/a/time') %>% html_text()
  content <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[1]/div') %>% html_text()
  content<-gsub("\n","",content)
  content <-sub(".*fleets *(.*?) *Good.*", "\\1", content)
  # putting together into a data frame
  df <- data.frame(
    content = content,
    write_date = write_date,
    stringsAsFactors=F)
  return(df)
}

scrape_gordo2 <- function(url){
  gb_scrape <- read_html(url)
  # variables that we're interested in
  write_date <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[2]/header/div/a/time') %>% html_text()
  content <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[2]/div') %>% html_text()
  content<-gsub("\n","",content)
  content <-sub(".*fleets *(.*?) *Good.*", "\\1", content)
  # putting together into a data frame
  df <- data.frame(
    content = content,
    write_date = write_date,
    stringsAsFactors=F)
  return(df)
}

scrape_gordo3 <- function(url){
  gb_scrape <- read_html(url)
  # variables that we're interested in
  write_date <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[3]/header/div/a/time') %>% html_text()
  content <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[3]/div') %>% html_text()
  content<-gsub("\n","",content)
  content <-sub(".*fleets *(.*?) *Good.*", "\\1", content)
  # putting together into a data frame
  df <- data.frame(
    content = content,
    write_date = write_date,
    stringsAsFactors=F)
  return(df)
}

scrape_gordo4 <- function(url){
  gb_scrape <- read_html(url)
  # variables that we're interested in
  write_date <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[4]/header/div/a/time') %>% html_text()
  content <- html_nodes(gb_scrape, xpath = '/html/body/div/div/section/div/article[4]/div') %>% html_text()
  content<-gsub("\n","",content)
  content <-sub(".*fleets *(.*?) *Good.*", "\\1", content)
  # putting together into a data frame
  df <- data.frame(
    content = content,
    write_date = write_date,
    stringsAsFactors=F)
  return(df)
}



gordo_post1 <- list()
gordo_post2 <- list()
gordo_post3<- list()
gordo_post4<- list()


base_url <- "http://gordobanks.com/"
year_gb <- seq(2010, 2019, by=1)
month_gb<-c('01','02','03','04','05','06','07','08','09','10','11','12')
expand_dates<-expand.grid(x=year_gb,r="/",y=month_gb)
pages<-paste0(expand_dates$x,expand_dates$r,expand_dates$y)

for (i in 1:length(pages)){
  # informative message about progress of loop
  message(i, '/', length(pages))
  tryCatch({
  # prepare URL
  url <- paste(base_url, pages[i], sep="")
  # scrape website
  gordo_post1[[i]] <- scrape_gordo1(url)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})  
  # wait a couple of seconds between URL calls
  Sys.sleep(2)
}



for (i in 1:length(pages)){
  # informative message about progress of loop
  message(i, '/', length(pages))
  tryCatch({
  # prepare URL
  url <- paste(base_url, pages[i], sep="")
  # scrape website
  gordo_post2[[i]] <- scrape_gordo2(url)
  # wait a couple of seconds between URL calls
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) 
  Sys.sleep(2)
}

for (i in 1:length(pages)){
  # informative message about progress of loop
  message(i, '/', length(pages))
  tryCatch({
  # prepare URL
  url <- paste(base_url, pages[i], sep="")
  # scrape website
  gordo_post3[[i]] <- scrape_gordo3(url)
  # wait a couple of seconds between URL calls
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) 
  Sys.sleep(2)
}

for (i in 1:length(pages)){
  # informative message about progress of loop
  message(i, '/', length(pages))
  tryCatch({
  # prepare URL
  url <- paste(base_url, pages[i], sep="")
  # scrape website
  gordo_post4[[i]] <- scrape_gordo4(url)
  # wait a couple of seconds between URL calls
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) 
  Sys.sleep(2)
}

gordo_posts<-rbind(do.call(rbind,gordo_post1),do.call(rbind,gordo_post2),do.call(rbind,gordo_post3),do.call(rbind,gordo_post4))

gordo_posts$content<-gsub("launching out of La Playita, Puerto Los Cabos Marina sent out approximately","",gordo_posts$content)
write.csv(gordo_posts, "gordo_banks_raw_data.csv")
