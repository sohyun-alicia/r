x <- TRUE       #  <- : Alt + '-'
y <- FALSE      # 실행 : Alt + Enter
class(x); class(y)

# %>% : 파이프 연산자 ctrl + shift + m
 
# 행렬(matrix)

x <- matrix(1:20, 5, 4)
x

x[1, 2]     # x에서 데이터 선택x[행, 열]

x[2:4,]     # 2~4행의 데이터 선택

x[-2,]      # 2행만 빼고 선택

matrix(1:20, 5, 4, byrow = TRUE)    # 왼쪽 > 오른쪽행 먼저 채우려면 byrow 사용

# 배열(array)

x <- array(1:2, c(5, 4, 2))
x

# 리스트(list)
x <- list(c(1:5), c(1:50))
x

x <- list(flower = "rose", color=c("red","white"))
x