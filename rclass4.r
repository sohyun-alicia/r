x <- c(1, 2, 3, 4)
y <- c(2, 2, 2, 2)

z <- x + y          # 순서에 맞춰서 더한 결과 출력됨
z

z <- x * y
z

x <- c(1, 2, 3, 4)  
y <- c(1, 2)

z <- x + y          # 길이가 다르면 한바퀴 돎
z

z <- x * y
z

y <- c(1, 2)
10-y

c(TRUE, TRUE) & c(TRUE, FALSE)
c(TRUE, TRUE) && c(TRUE, FALSE)


x <- c("a", "b")
"a"%in%x

x <- read.csv("reservation_r_csv.csv")
head(x)