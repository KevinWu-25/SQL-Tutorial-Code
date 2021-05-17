install.packages("ISLR")
install.packages("tree") 

library(ISLR)
data(package="ISLR")
carseats<-Carseats 

library(tree) 

High = ifelse(carseats$Sales<=8, "No", "Yes")
carseats = data.frame(carseats, High)

tree.carseats = tree(High~.-Sales, data=carseats) 

summary(tree.carseats) 

plot(tree.carseats)
text(tree.carseats, pretty = 0) 

tree.carseats 

set.seed(101)
train=sample(1:nrow(carseats), 250) 

tree.carseats = tree(High~.-Sales, carseats, subset=train)
plot(tree.carseats) 

text(tree.carseats, pretty=0) 

tree.pred = predict(tree.carseats, carseats[-train,], type="class") 

with(carseats[-train,], table(tree.pred, High)) 

cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass) 
cv.carseats 

plot(cv.carseats) 