x <- read.csv("reservation_r_csv.csv")
head(x)

library(readxl)

y <- read_excel("reservation_r_excel.xlsx")
head(y)

tail(y)     # 끝에서 여섯줄

str(y)      # 데이터 구조

dim(y)      # 행, 열

ncol(y)     # 열

nrow(y)     # 행

length(y)   # 열

ls(y)       # 변수 목록

object.size(y)      # 파일 사이즈

View(y)     # 데이터셋창 띄워서 확인

head(x,3)

tail(y,10)

str(x)

dim(x)

ncol(x)

nrow(x)

length(x)

ls(x)

object.size(x)

View(x)


# Sleep 자료 데이터 확인해보기

dim(sleep)

head(sleep)

tail(sleep)

summary(sleep)

ls(sleep)

object.size(sleep)

is.na(sleep)        # 결측지?(NA)

x <- c(1, 2, 3, 4, 5, 6, 7, 8, NA, 10)
x

is.na(x)

is.null(x)

is.numeric(x)       # NA는 숫자형

is.character(x)

is.logical(x)

is.factor(x)

is.data.frame(x)

x <- c(1, 2, 3, 4, 5)
y <- c(6, 7, 8, 9, 10)

x

y

rbind(x,y)      # x와 y를 행으로 엮음
cbind(x,y)      # x와 y를 열로 엮음

df <- data.frame(name=c("a", "b"), score=c(80, 60))     # name과 score라는 열에 각각의 자료를 넣음
df

cbind(df, rank=c(1, 2))     # 열 추가

split(iris, iris$Species)   # Species로 iris 자료를 분리

View(iris)

subset(iris, Sepal.Length>=7)   # 조건에 맞는 데이터 선택하기

# 조건에 맞는 데이터를 특정 열만 선택해서 보기
subset(iris, Sepal.Length>=7, select=c("Sepal.Length", "Species"))

substr(iris$Species, 1, 3)      # iris의 Species 열 데이터에 대해 1~3자리까지의 문자열 선택


# 두 데이터 프레임의 공통 열 이름 또는 행 이름으로 데이터 프레임 합치기
# merage(dataframe1, dataframe2)
x <- data.frame(name=c("a", "b", "c"), height = c(170, 180, 160))
y <- data.frame(name=c("c", "b", "a"), weight=c(50, 70, 60))
merge(x,y)

cbind(x,y)      # 공통 기준 열 없이 데이터값 순서대로 합침

x <- c(20, 10, 30, 50, 40)
sort(x)                         # 오름차순이 기본

sort(x, decreasing=TRUE)        # 내림차순 정렬 : decreasing=TRUE

x       # x에는 영향 X

order(x, decreasing = FALSE)    # 인덱스를 오름차순으로 반환

order(x, decreasing = TRUE)     # 인덱스를 내림차순으로 반환

iris[order(iris$Sepal.Length), ]    # iris[행, 열] : 행을 오름차순으로 정렬

x <- c(1, 1, 2, 2, 3, 3)

unique(x)       # 유일한 값 반환

x <- 1
y <- 2
rm(x,y)
x
y

aggregate(Petal.Length ~ Species, iris, mean)   # 품종별 Petal.Length 평균 길이

aggregate(cbind(Petal.Length, Sepal.Length) ~ Species, iris, mean)