setwd("/Users/saulgarcia/Desktop/Github/DMKM/Text Mining/")


#loading the document
library(XML)
document <- htmlParse(file="brel-vesoul.html")
print(document)


#getting the document root
root <- xmlRoot(document)

#getting the name of the structure
#this is a HTML document, tagged by <html>...</html>
type <- xmlName(root)

# > type
# [1] "html"

#number of "branches"
nb <- xmlSize(root)
print(nb)
# > print(nb)
# [1] 2

b1 <- root[[1]]
print(b1)
# Returns the head

# Children of b1
childs.b1 <- xmlChildren(b1)
print(xmlSize(childs.b1))
# > print(xmlSize(childs.b1))
# [1] 2

# Get elements of title
print(childs.b1[["title"]])

# Get elements of meta
print(childs.b1[["meta"]])

# gets attributes within the meta tag
atts.meta <- xmlAttrs(childs.b1[["meta"]])
print(atts.meta)
# http-equiv                    content 
# "Content-Type" "text/html; charset=UTF-8" 

# get data within body tag
b2 <- root[["body"]]
print(b2)
# Data around body

# Get attributes
childs.b2 <- xmlChildren(b2)
# [1] "XMLInternalNodeList" "XMLNodeList"         

# size of child in body
print(xmlSize(childs.b2))
# [1] 17

# Names of sub- nodes
print(names(childs.b2))

# prints value between h3
h3 < - xpathApply(b2,path="h3",xmlValue)
print(h3)
# <h3>Vesoul</h3>&#13;

vec.h3 <- unlist(h3)
print(vec.h3)
# [1] "Vesoul"

# decompose to paragraphes
# list and with data in paragraph
textes <- xpathApply(b2,path="p",xmlValue)
print(textes)

# transform list into vector
vec.textes <- unlist(textes)
print(vec.textes)

# Get a list of lines
lines <- strsplit(vec.textes,"\n")
print(length(lines))

# Transform to a vector
vec.lines <- unlist(lines)
# vector or 123 elements

#vector to lowercase
vec.lines <- tolower(vec.lines)

#decomposer the lines to words
words <- strsplit(vec.lines," ")
print(length(words))

#Put them into a vector of single words
vec.words <- unlist(words)
print(vec.words)

#Get unique list of words
dictionary <- unique(vec.words)
dictionary <- sort(dictionary)
print(dictionary)

#Compute the occurrence of each word
table.words <- table(vec.words)
print(table.words)

#Sort in decreasing order
table.words <- sort(table.words,decreasing=T)
print(table.words)

# library(RCurl)
# fileURL <- "https://en.wikipedia.org/wiki/Text_mining"
# xData <- getURL(fileURL)
wiki <- htmlParse("Text_mining")
#wiki <- htmlParse("http://en.wikipedia.org/wiki/Text_mining")
wiki.text = xpathApply(xmlRoot(wiki), path="body", xmlValue)
wiki.text <- gsub("\\.|\\,|\\t|\\[|\\]|[0-9]|\\(|\\)|\\{|\\}|\\'|\\n|\"|-|/*|\\*|\\@|\\^|\\;|\\:|\\||\\=","",wiki.text)
wiki.lines <- tolower(wiki.text)

#Decompose lines into words
wiki.words <- strsplit(wiki.lines," ")
print(length(wiki.words))

#Put words into a single vector
wiki.words <- unlist(wiki.words)
print(wiki.words)

#Get unique words
wiki.dictionary <- unique(wiki.words)
wiki.dictionary <- sort(wiki.dictionary)
print(wiki.dictionary)

#Compute occurrence of each word
wiki.table.words <- table(wiki.words)
print(wiki.table.words)

#Sort by decreasing order
wiki.table.words <- sort(wiki.table.words,decreasing=T)
print(wiki.table.words)


sparsify <- function(x)
{
  if (length(x) > 0){
    if (x[1] > 1){
      return(c(0, sparsify(x - 1)))
    }
    else{
      l <- length(x[x == 1])
      y <- x[-(1:l)]
      return(c(l, sparsify(y - 1)))
    }
  }
  else
    return(numeric())
}

vectorize_2 <- function(docs, i, vocab)
{
  d <- sort(unlist(strsplit(tolower(docs[i]), " ")))
  # we look for indexes on the word vocabulary
  d_liste <- sapply(d, function(x) { match(x, vocab) }, USE.NAMES=FALSE)
  # We stop onthe first version of vectorize and return the list
  spar <- sparsify(d_liste)
  zeros <- rep(0,length(vocab)-length(spar))
  return(c(spar, zeros))
}

# Test on the song Brel
nbwords <- length(dictionary)
nbdocs <- length(vec.lines)
data <-matrix(0, nbdocs, nbwords)

for(i in 1:nbdocs)
{
  data[i,] <- vectorize_2(vec.lines, i, dictionary)
}




##################### PART 2 ###################

#Correction : Exercise 1
norm <- function(x){
  # Calculate The norm euclidean of x
  res <- sqrt(sum(x^2))
  return(res)
}

cosinus <- function(x, y){
  # Calculate cosine
  num <- x %*% y
  den <- norm(x) * norm(y)
  if (den > 0){ 
    z <- num / den }
  else{ 
    z <- matrix(0, 1, 1) }
  return(z[1,1])
}

a=c(1.4, 0.8, 0, 1.1)
b=c(0.9, 0.1, 0.5, 1)

cosinus(a,b)



#Correction : Exercise 2
#load data "chanson-brel"
library(XML)
document <- htmlParse(file="brel-vesoul.html")
print(document)

#Document root
root <- xmlRoot(document)
print(root)

#Paragraph decomposition
#Looking for tag <p>

text <- xpathApply(root[["body"]],path="p",xmlValue)
print(text)

#Transform to vector
vec.text <- unlist(text)
print(vec.text)

#Reeplace line breaks with space
paragraphes <- c()
for (i in 1:length(vec.text)){
  paragraphes[i] <- gsub("\r\n"," ",vec.text[i])
  # note : It can also only be "\n"
}

#lowercase
paragraphes <- tolower(paragraphes)
print(paragraphes)

# Create a dictionary
#Get the list of lines
lines <- strsplit(vec.text,"\r\n")
# note : c’est peut-^etre juste "\n"
print(length(lines))


#Transform to vector
vec.lines <- unlist(lines)

#to lower case
vec.lines <- tolower(vec.lines)

#Separate the lines into words
words <- strsplit(vec.lines," ")
print(length(words))

#Put the words in a single vector
vec.words <- unlist(words)
print(vec.words)

#Get only unique words
unique.words <- unique(vec.words)

#Get dictionary
dictionary <- sort(unique.words)
print(dictionary)

#>>> Test on the song chanson de Brel
#on utilise les fonctions  ́elabor ́ees dans TD1
#calcul de la matrix documents x termes

nbwords <- length(dictionary)
nbdocs <- length(paragraphes)
data <-matrix(0, nbdocs, nbwords)

for(i in 1:nbdocs){
  data[i,] <- vectorize_2(paragraphes, i, dictionary)
}
print(data)

#Calculate the similarity matrix with cosine

matrix_cos <- function(m){
  nbdocs <- nrow(m)
  diss <-matrix(0, nbdocs, nbdocs)
  for(i in 1:nbdocs){
    for(j in 1:nbdocs){
      d1 <- data[i,]
      d2 <- data[j,]
      diss[i,j] <- 1 - cosinus(d1, d2)
    }
  }
  return(diss)
}

diss <- matrix_cos(data)
print(diss)



#Correction : Exercise 3
# on peut  ́echapper `a la r ́e- ́ecriture de la fonction en utilisant directement dist :

euclid <- dist(data, method="euclidean")

# calcul de statistiques de base
mean(c(diss))
# 0.811124

var(c(diss))
# 0.0166827

sd(c(diss))
# 0.1291615

mean(c(euclid))
# 13.39947

var(c(euclid))
# 19.07691

sd(c(euclid))
# 4.367712

# If we calculate the ratio between the standard deviation and the average score, it gives an id ee the "contrast" between the data ees.
# Is obtained (about) 0.68 for the dissimilarity e ee low on the cosine and 0.33 for the Euclidean distance. This
# thus corroborates what has and e being seen on the "wrong ediction dimension".

###Correction : Exercise 4

#multidimensional scaling
mds.euclid <- cmdscale(euclid,eig=T,k=2)

#proportion de variance explained by the axis
prop.var <- cumsum(mds.euclid$eig)/sum(mds.euclid$eig) * 100
print(prop.var)

#repr ́esentation graphique - nuage de points dans le plan
plot(mds.euclid$points[,1],mds.euclid$points[,2],type="n")
text(mds.euclid$points[,1],mds.euclid$points[,2],labels=1:7)

#multidimensional scaling
mds.diss <- cmdscale(diss,eig=T,k=2)

#proportion de variance expliqu ́ee
prop.var.diss <- cumsum(mds.diss$eig)/sum(mds.euclid$eig) * 100
print(prop.var.diss)

plot(mds.diss$points[,1],mds.diss$points[,2],type="n")
text(mds.diss$points[,1],mds.diss$points[,2],labels=1:7)

#Correction : Exercise 5

#Hierarchical clustering - Ward Method Clustering
cah.euclid <- hclust(euclid,method="ward")
plot(cah.euclid)

#Hierarchical clustering - Complete Method"
cah.euclid <- hclust(euclid,method="complete")

plot(cah.euclid)