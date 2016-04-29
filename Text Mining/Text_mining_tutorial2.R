setwd("/Users/saulgarcia/Desktop/Github/DMKM/Text Mining")

##### Comparing Text ######

norm = function(x){
  res = sqrt(sum(x^2))
  return(res)
}

cosine = function(x, y){
  num = x %*% y
  den = norm(x) * norm(y)
  if (den > 0)
  {z = num/den}
  else
  {z = matrix(0,1,1)}
  return(z[1,1])
}

a <-  c(1.4, 0.8, 0, 1.1)
b <-  c(0.9, 0.1, 0.5, 1)
cosine(a,b)

#Exercise 2
#Load Data
library(XML)
document <- htmlParse(file="brel-vesoul.html")
print(document)
#Root of document
root <- xmlRoot(document)

#>>> Decompose into paragraphs
text <- xpathApply(root[["body"]],path="p",xmlValue)
print(text)

#Into vector
vec.text <- unlist(text)
print(vec.text)

#Replace the line breaks for spaces
paragraphes <- c()

for (i in 1:length(vec.text)){
  paragraphes[i] <- gsub("\r\n"," ",vec.text[i])
}

paragraphes <- tolower(paragraphes)
print(paragraphes)

#>>> Create a Dictionary
lines <- strsplit(vec.text,"\r\n")
print(length(lines))

#Transform into vector
vec.lines <- unlist(lines)

#lower cases
vec.lines <- tolower(vec.lines)

#Decompose lines into words.
words <-  strsplit(vec.lines," ")
length(words)

#Vectorize
vec.words <- unlist(words)
vec.words

#Unique words
unique.words <- unique(vec.words)
unique.words

#Order alphabetically
mondico <- sort(unique.words)
print(mondico)

#>>> Test with the song

nbwords <- length(mondico)
nbdocs <- length(paragraphes)
data <-matrix(0, nbdocs, nbwords)

sparsify <- function(x)
{
  if (length(x) > 0)
  {
    if (x[1] > 1)
    {
      return(c(0, sparsify(x - 1)))
    }
    else
    {
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
  d_liste <- sapply(d, function(x) { match(x, vocab) }, USE.NAMES=FALSE)
  spar <- sparsify(d_liste)
  zeros <- rep(0,length(vocab)-length(spar))
  return(c(spar, zeros))
}

for(i in 1:nbdocs)
{
  data[i,] <- vectorize_2(paragraphes, i, mondico)
}
data

#Calculate dissimilarity of matrix using cosine

matrix_cos <- function(m){
  nbdocs <- nrow(m)
  diss <-matrix(0, nbdocs, nbdocs)
  for(i in 1:nbdocs){
    for(j in 1:nbdocs){
      d1 <- data[i,]
      d2 <- data[j,]
      diss[i,j] <- 1 - cosine(d1, d2)
    }
  }
  return(diss)
}
diss <- matrix_cos(data)

#Exercise 3
#Euclidean distance
euclid <- dist(data, method="euclidean")

# Basic Statistics
mean(c(diss))
var(c(diss))
sd(c(diss))
mean(c(euclid))
var(c(euclid))
sd(c(euclid))

Correction : Exercise 4

mds.euclid <- cmdscale(euclid,eig=T,k=2)
prop.var <- cumsum(mds.euclid$eig)/sum(mds.euclid$eig) * 100
prop.var

#Graphic Representation
plot(mds.euclid$points[,1],mds.euclid$points[,2],type="n")
text(mds.euclid$points[,1],mds.euclid$points[,2],labels=1:7)

#multidimensional scaling
mds.diss <- cmdscale(diss,eig=T,k=2)

#Variance proportion
prop.var.diss <- cumsum(mds.diss$eig)/sum(mds.euclid$eig) * 100
prop.var.diss

plot(mds.diss$points[,1],mds.diss$points[,2],type="n")
text(mds.diss$points[,1],mds.diss$points[,2],labels=1:7)

#Clustering of documents "Ward Method"
cah.euclid <- hclust(euclid,method="ward")
plot(cah.euclid)

#Clustering of documents - Method complete
cah.euclid <- hclust(euclid,method="complete")
plot(cah.euclid)

