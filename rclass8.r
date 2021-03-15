# ifelse문

x <- c(1, 2, 3, 4, 5)
ifelse(x == 2, TRUE, FALSE)

# 반복문
for (i in 1:5){
    print(i)
}

sum <- 0
for (i in seq(1, 5, by = 1)){       # seq는 순차값을 생성하는 함수
    sum <- sum + 1
}
sum


# 1~5까지 출력하는 while문
i <- 1
while(i <= 5){
    print(i)
    i <- i + 1
}

i <- 1
while(i <= 5){
    i <- i + 1
    if(i == 2){
        next    # i가 2이면 while문 처음으로 돌아감
    }
    print(i)   
}               

i <- 1
repeat{
    print(i)
    if (i >= 5){
        break
    }
    i <- i+1
}