#Getting started with R
getwd()
setwd("/Users/saulgarcia/Desktop/Github/DMKM/Text Mining")

#Exercise 2: Tutorial

vec1 <- scan(text = "1 2 4")
vec2 <- c(1,2,4)

vec1[3]
vec2[length(vec2)] =length(vec2)
t(t(vec2))
vec1 %*% vec2
zeros = rep(0,10)
nat = seq(1:20)
nat[5:20]

#Exercise 3.
#Read an HTML
install.packages("XML")
library(XML)
doc = htmlParse("brel-vesoul.html")
print(doc)

root<- xmlRoot(doc)
name = xmlName(root)

nb = xmlSize(root)

b1 = root[[1]] #title

childs.b1 = xmlChildren(b1)
childs.b1
xmlSize(childs.b1)

b1[[1]] #title
b1[[2]] #metadata

atts.meta = xmlAttrs(childs.b1$meta)
atts.meta

b2 = root[[2]]
childs.b2 = xmlChildren(b2)
xmlSize(childs.b2)
names(childs.b2)

#Excercise 6: Get the texts of the song
h3 = xpathApply(b2, path="h3", xmlValue)
vec.h3 = unlist(h3)

texts = xpathApply(b2, path="p", xmlValue)
texts

vec.texts =xpathSApply(b2, path="p", xmlValue)
vec.texts

lines = strsplit(vec.texts, "\r\n")
vec.lines = unlist(lines)

###First operations on the texts
#Pretreatment
lowercases = tolower(vec.lines)
words = strsplit(lowercases, " ")
uniquewords = unique(unlist(words))
mydictio = sort(uniquewords)
mydictio

table.words = sort(table(unlist(words)), decreasing = TRUE)
plot(table.words)

#Excercise 8
library(RCurl)
fileURL <- "https://en.wikipedia.org/wiki/Text_mining"
xData <- getURL(fileURL)
wiki <- htmlParse("Text_mining")
wiki.text = xpathApply(xmlRoot(wiki), path="body", xmlValue)
wiki.text.clean = gsub("\\.|\\,|\\t|\\[|\\]|[0-9]|\\(|\\)|\\{|\\}|\\'|\\n|\"|-|/*|\\*|\\@|\\^|\\;|\\:|\\||\\=","",wiki.text)

wikilower= tolower(wiki.text.clean)
wiki.words = unlist(strsplit(wikilower," "))
table.wiki = sort(table(wiki.words), decreasing=TRUE)

#Excercise 9
vectorize = function(list, index, dictionary) {
  d = unlist(strsplit(list[index], " "))
  sapply(d, function(x) match(x,dictionary), USE.NAMES = FALSE)
}




