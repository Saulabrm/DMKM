install.packages('neuralnet')
library("neuralnet")
library("dplyr")
library("caret")
set.seed(1234)
setwd("/Users/saulgarcia/Dropbox/Maestría/DMKM/Courses/SEM1/Optimization/Laboratory/NeuralNetworkR")


#Import the Data
data_x<-read.csv("data_x.txt",sep = " ")[ ,2:5]
#rawdata= read.csv("krishna.dat",sep=" ")

head(data_x)
#names(rawdata)= c("X1","X2","X3","X4","X5","X6","Y")
#dataset<-select(rawdata, X1,X2,X3,X4,Y)
data_y<-read.csv("data_y.txt",sep = " ")[,2]

head(data_y)

data<-cbind(data_x,data_y)
names(data)<-c("X1","X2","X3","X4","Y")
head(data)
#Train the neural network
#Going to have 2 hidden layers
#Threshold is a numeric value specifying the threshold for the partial
#derivatives of the error function as stopping criteria.
  net.sqrt <- neuralnet(Y~X1+X2+X3+X4,data, hidden=2, threshold=0.05)
  #net.sqrt <- neuralnet(Y~X1+X2+X3+X4,dataset, hidden=2, threshold=0.05)
  net.sqrt$result.matrix
  
  print(net.sqrt)
  
#Plot the neural network
plot(net.sqrt)

#Test the neural network on some training data
rawtest<- read.csv("krishna.dat",sep=" ",nrows=30)
names(rawtest)<- c("X1","X2","X3","X4","X5","X6","Y")
testingX<-select(rawtest, X1,X2,X3,X4)
testingY<-select(rawtest, Y)
results<- compute(net.sqrt, data)

#rawtestdata <- as.data.frame((1:10)^2) #Generate some squared numbers
#net.results <- compute(net.sqrt, testdata) #Run them through the neural network

#Lets see what properties net.sqrt has
ls(net.results)

#Lets see the results
print(net.results$net.result)

#Lets display a better version of the results
cleanoutput <- cbind(testdata,sqrt(testdata),
                     as.data.frame(net.results$net.result))
colnames(cleanoutput) <- c("Input","Expected Output","Neural Net Output")
print(cleanoutput)