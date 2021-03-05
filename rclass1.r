x <- c(1, 2, 3, 4, 5)
x

class(x)

x <- c(0.1, 0.2, 0.3, 0.4, 0.5)
x

class(x)

x <- c(1L, 2L, 3L, 4L, 5L)
x

class(x)

x <- 1+0i
x
class(x)

x  <- c("A", "B", "C", "가", "나", "다")
x
class(x)

x <- c("1", "2", "3")
x
class(x)

x <- "2018-01-18"
x
class(x)

x <- as.Date("2020-01-18")
x
class(x)

y <- as.Date("2019-01-18")
y

class(x); class(y)

x-y

x <- TRUE
y <- FALSE
class(x); class(y)

# 벡터데이터 값과 데이터 위치
x <- c(1, 2, "a", 4)
x

x[2]    # R은 자리값이 1부터 시작

x[3]

x[c(2, 3)]  # 두 번째와 세번째 데이터 함께 선택

x[2:3]

x[-1]   # 첫 번째 데이터만 빼고 선택

x[x=="a"]   # x가 a인 값을 선택, '==는 같다면'이라는 의미

# 팩터(factor)

x <- factor(c("M", "F", "F", "M"))  # 팩터 구조의 데이터를 변수에 할당
x
class(x)    # 팩터형으로 출력됨

levels(x)   # 범주를 확인

levels(x) <- c("A", "B")    # F, M을 A, B로 대체
x

# 행렬(matrix)

 x <- matrix(1:20, 5, 4)    # matrix(데이터, 행개수, 열개수)
 x
 class(x)