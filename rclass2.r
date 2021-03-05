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

# 데이터 프레임(Data Frame)
df <- data.frame(name = c('kim', 'lee', 'choi', 'park'), age = c(32, 25, 18, 39), height = c(170, 175, 168, 180), weight = c(63, 66, 59, 70))
df

class(df)

name <- c("kim", "lee", "choi", "park")
age <- c(32, 25, 18, 39)
weight <- c(63, 66, 59, 70)
height <- c(170, 175, 168, 180)
df <- data.frame(name, age, height, weight)

df
class(df)

df[1,]

df[3,]

df[c(1,3),]     # 1행과 3행의 자료만 보여줌

df[1:3, ]       # 1~3행 자료 보여주기

df[, 2]         # 2열 자료만 보여주기

df[, 2, drop=FALSE]     # 원래의 열모양대로 출력하려면 3번째 인수로 drop=FALSE 추가

df[c(1, 3), c(1, 2)]       # 선택할 행과 선택할 열

rownames(df)  <- c("one", "two", "three", "four")   # 행 이름 바꾸기
df

df[c("one", "three"),]      # 행 이름 사용해서 내용 가져오기

df[,"age", drop=FALSE]      # 열 이름 사용해서 원래의 열모양대로 출력하는 법

df$height           # 데이터프레임$열이름

# 연습문제 1

이름 <- c('민준', '유리', '재희')
나이 <- c(22, 20, 21)
성별 <- c('남', '여', '남')
전공 <- c('수학', '영문', '경영')

df = data.frame(이름, 나이, 성별, 전공)
df
# 2 열 별로 전부 각각 데이터 추출하기
df[,1]
df[,2]
df[,3]
df[,4]

df[, 1:4]

# 3 행 별로 전부 각각 데이터 추출하기($사용)
df$이름
df$나이
df$성별
df$전공


# 4 유리와 재희의 정보만 추출하기
df[c(2, 3),]

# 5 나이와 성별의 정보만 추출하기($사용)
df$나이
df$성별

# 6 나이의 평균
sum(df$나이)/3
mean(나이)

# 7 성별 인원수
df.성별['남']

