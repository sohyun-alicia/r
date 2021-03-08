x <- c(1, 2, 3, 4)
x

min(x)          # 최솟값 구하기

max(x)          # 최댓값 구하기

a  <- mean(x)   # 평균, 계산 결과를 다른 변수에 담아서 많이 사용함
a

class(a)


user_f  <- function(x){     # 사용자 함수 만들기
    return (x*2)
}

user_f(c(1:3))


install.packages("dplyr")
library(dplyr)

summarise(iris, avg=mean(Sepal.Length))

install.packages("tidyr")
library(tidyr)
