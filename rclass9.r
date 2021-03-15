# install.packages("dplyr")
install.packages("dplyr")
library(dplyr)

# 파이프 연산자 ctrl + shift + m => %>%
install.packages('readxl')
library(readxl)
customer_r <- read_excel("customer_r.xlsx")
customer_r %>%count()


# 행 요약과 그룹화
# summarise() 함수
library(readxl)
order_info_r <- read_excel("order_info_r.xlsx", 1)
summarise(order_info_r, avg = mean(SALES))

summarise(order_info_r, min_value=min(SALES), max_value=max(SALES))

order_info_r %>% summarise(min_value=min(SALES), max_value=max(SALES))

reservation_r <- read_excel("reservation_r.xlsx")
head(reservation_r)
reservation_r %>% group_by(CUSTOMER_ID) %>% summarise(avg=mean(VISITOR_CNT))


head(order_info_r)
order_info_r %>% filter(ITEM_ID=="M0001")

order_info_r %>% filter(ITEM_ID == "M0001" & SALES>=150000)




# 열조작
# select() 함수 : 열선택하기
order_info_r %>% select(RESERV_NO, SALES)

# mutate() 함수: 열조작해서 새로운 열 생성
order_info_r %>% group_by(RESERV_NO) %>% mutate(AVG=mean(SALES))

# transmute() : mutate()과 동일하지만, 기존 테이블의 열 반환X
order_info_r %>% group_by(RESERV_NO) %>% transmute(AVG = mean(SALES))

# mutate_all() : 모든 열 조작해서 새로운 열 생성
order_info_r %>% mutate_all(funs(max))

# mutate_if() : 특정 '조건' 열만 조작해서 새로운 열 생성
# 아래는 열이 숫자형일 경우, 로그로 바꾸는 예시
order_info_r %>% mutate_if(is.numeric, funs(log(.)))

# mutate_at() : 특정 열만 조작해서 새로운 열 생성
order_info_r %>% mutate_at(vars(SALES), funs(max))

# rename() : 열 이름 바꾸기
# SALES를 AMT로 바꾸는 예시
order_info_r %>% rename(AMT = SALES)