

install.packages("readxl")
library(readxl)
y <- read_excel("reservation_r_excel.xlsx")     # Excel 파일 불러오기
head(y)

x <- read.csv("reservation_r_csv.csv")  # CSV 파일 불러오기
head(x)

write.csv(x, "csv_output.csv")          # CSV 파일로로 내보내기

install.packages("writexl")            
library(writexl)

write_xlsx(y,"excel_output.xslx")        # Excel 파일로 내보내기

sink("output.txt")
x <- 1
y <- 2
x
y
x + y
sink()


x <- c(1, 2, 3)
y <- c(4, 5, 6)

save(x,y, file="save.Rdata")

rm(list = ls())             # R메모리에 있는 변수 모두 삭제

x
y

load("save.Rdata")          # load 함수 사용해서 x변수 불러옴
x

x <- c(1, 2, 3)
y <- c(4, 5, 6)
z <- c(7, 8, 9)
save(list=ls(), file="save2.Rdata")     # 모든 변수들을 파일에 저장

rm(list=ls())
x
y
z

load("save2.Rdata")
x
y
z

connect <- file("result.txt", "w")      # 파일 설정
x <- iris$Sepal.Length
cat(summary(x), file=connect)           # summary함수의 결과를 파일에 기록
close(connect)                          # 파일 종료

x <- read.csv("reservation_r_csv.csv")
head(x,10)          # 데이터셋 앞부분 출력
tail(x)             # 데이터셋 뒷부분 출력
str(x)              # 데이터셋 구조 출력
View(x)             # 소스 창으로 데이터와 구조 확인
ncol(x)             # 열 개수
nrow(x)             # 행 개수
length(x)           # 벡터 길이 반환
object.size(x)      # 메모리 상에서 변수(객체) 데이터 크기 확인
dim(x)              # 열과 행, 차원의 개수
summary(x)           # 요약 통계량 출력

# iris 활용해서 데이터 확인하기

head(iris, 10)

tail(iris, 10)

summary(iris)           # iris 모든 열의 요약 통계량 출력

summary(iris$Sepal.Length)      # 한개 열에 대한 요약 통계량

str(iris)               # 데이터셋 구조 출력

View(iris)          # 데이터셋 창을 띄워 확인

dim(iris)           # 차원(행, 열)

nrow(iris)          # 행

ncol(iris)          # 열

length(iris)        # 열의 개수, 데이터 프레임에서는 열의 길이 출력

ls(iris)            # 변수 목록 확인

ls()

rm(list = ls())
x


x <- c(1, 2, 3, 4, 5)
x

object.size(x)      # 변수 크기 확인

x <- c(1, 2, 3, 4, 5, 6, 7, 8, NA, 10)

is.na(x)            # 개별 데이터가 NA인지 확인

is.null(x)          # 데이터셋이 null?

is.numeric(x)       # 숫자형?

is.character(x)     # 문자형?

is.logical(x)       # 논리형?

is.factor(x)        # 팩터 구조?

is.data.frame(iris) # 데이터 프레임?

head(AirPassengers)

# Orange

head(Orange, 10)

tail(Orange, 10)

summary(Orange)

str(Orange)
# Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':     35 obs. of  3 variables: 

View(Orange)

dim(Orange)

nrow(Orange)

ncol(Orange)

length(Orange)

ls(Orange)

object.size(Orange)

a = Orange[,2]

is.na(a)

is.null(a)

is.numeric(a)

is.character(a)

is.logical(a)

is.factor(a)

is.data.frame(a)

is.infinite(a)