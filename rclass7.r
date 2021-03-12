x <- c(1, 2, 3, 4, 5)/4
x

round(x, 0)     # 소수점 첫째 자리에서 반올림

floor(x)        # 소수점 이하를 내림

ceiling(x)      # 소수점 이하를 올림

trunc(x)        # 소수점 아래 값 버림

abs(-10)        # 절댓값

log(10, base = 2)   # 밑이 2인 로그

sqrt(10)        # 제곱근

exp(10)         # 지수로 변환

x <- c(1, 2, 3, 4, 5)   
sum(x)          # 합계

mean(x)         # 평균

median(x)       # 중앙값

max(x)          # 최댓값

min(x)          # 최솟값

range(x)        # 범위

sd(x)           # 표준편차

var(x)          # 분산



# 데이터 그리기

# x, y 축 기준으로 산점도 그리기
plot(iris$Petal.Length, iris$Petal.Width)

# x, y축에 이름 붙이고 품종별로 색상 입히기
plot(iris$Petal.Length, iris$Petal.Width, main="iris data", xlab="Petal Length", ylab="Petal Width", col=iris$Species)

# 행렬 산점도 그리기(그래프를 여러 개로 조합하여 나타내는 행렬 형태 그래프)
pairs(~ Sepal.Width + Sepal.Length + Petal.Width + Petal.Length, data=iris, col=iris$Species)

# 값의 범위마다 빈도를 표현 > 데이터가 모여 있는 정도(분포)를 확인하기 좋음
hist(iris$Sepal.Width)

hist(iris$Sepal.Width, freq=FALSE)      # 확률 밀도 확인. 각 구간의 총합은 1

# 막대 그래프 : 품종별 꽃잎 길이의 평균
x <- aggregate(Petal.Length ~ Species, iris, mean)
barplot(x$Petal.Length, names=x$Species)        # 막대 그래프 이름으로 품종 지정

# 파이 차트(품종별 꽃잎 길이의 합이 전체 꽃입 길이에서 차지하는 정도)
x <- aggregate(Petal.Length ~ Species, iris, sum)       # 품종별로 꽃잎 길이 합산
pie(x$Petal.Length, labels=x$Species)                   # 품종 이름을 붙여 파이 그래프를 그림

# 선그래프 그리기

x <- tapply(iris$Petal.Length, iris$Petal.Width, mean)     # Petal.Width를 그룹으로 Petal.Length 평균을 구함
x

plot(x, type='o')

