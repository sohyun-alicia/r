# install.packages("dplyr")
install.packages("dplyr")
library(dplyr)

# 파이프 연산자 ctrl + shift + m => %>%
install.packages('readxl')
library(readxl)
customer_r <- read_excel("customer_r.xlsx")
customer_r %>%count()


#--------------------------행 요약과 그룹화--------------------------#

# summarise() 함수 : 행 요약하기
order_info_r <- read_excel("order_info_r.xlsx", 1)

# 주문 테이블에서 매출 SALES 평균값 구하기
summarise(order_info_r, avg = mean(SALES))

# SALES 열의 최솟값과 최댓값 구하기
summarise(order_info_r, min_value=min(SALES), max_value=max(SALES))

# 파이프 연산자 사용해서 위와 동일한 값 출력
order_info_r %>% summarise(min_value=min(SALES), max_value=max(SALES))

# summarise_all() : 모든 열에 대한 요약값 출력

# summarise_at()
summarise(order_info_r, SALES )


# group_by() 함수 : 지정한 열을 기준으로 행을 그룹화

reservation_r <- read_excel("reservation_r.xlsx")
head(reservation_r)

# 예약테이블(reservation_r)에서 고객 번호(customer_id)로 그룹화(gorup_by)하여 평균값(mean) 구하기
reservation_r %>% group_by(CUSTOMER_ID) %>% summarise(avg=mean(VISITOR_CNT))


#--------------------------행조작--------------------------#
head(order_info_r)

# filter()함수 : 조건으로 행 선택하기
order_info_r %>% filter(ITEM_ID=="M0001")

# 조건 추가
order_info_r %>% filter(ITEM_ID == "M0001" & SALES>=150000)

# distinct()함수 : 유일 값 행 선택하기
# ITEM_ID를 종류별로 하나만 알고싶을 때
order_info_r %>% distinct(ITEM_ID)

# slice()함수 : 선택 행 자르기
order_info_r %>% slice(2:4)         # 2~4행 잘라서 출력

order_info_r %>% slice(c(1, 3))     # 1, 3행만 잘라서 출력

# arrange()함수 : 행 정렬하기(오름/내림차순)
order_info_r %>% arrange(SALES)

# 내림차순으로 정렬(desc옵션 추가)
order_info_r %>% arrange(desc(SALES))

# 열 순서대로 정렬 : 열 이름 계속 나열
order_info_r %>% arrange(RESERV_NO, ITEM_ID)

# add_row()함수 : 행 추가하기
table_added_row <- order_info_r %>% add_row (ORDER_NO="1", ITEM_ID="1", RESERV_NO="1")
table_added_row %>% arrange(ORDER_NO)

# sample_frac(), sample_n() : 무작위로 샘플 행 뽑기
# sample_frac() : 추출샘플 개수를 비율로 지정
order_info_r %>% sample_frac(0.1, replace=TRUE)

order_info_r %>% sample_n(1, replace=TRUE)
#----------------------열조작----------------------#

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


#----------------------테이블 조작----------------------#

# bind_cols() 테이블 열 붙이기
tmp_order_info_r <- order_info_r
bind_cols(order_info_r, tmp_order_info_r)

bind_cols(order_info_r, reservation_r)

# bind_rows() 테이블 행 붙이기
tmp_order_info_r <- order_info_r
bind_rows(order_info_r, tmp_order_info_r)


# Quiz iris 가져와서 iris + iris 옆으로 붙이기
temp_iris <- iris
a <- bind_cols(iris, temp_iris)
head(a)
head(iris)


# inner_join()함수 : 일치하는 데이터 연결하기
inner_join(reservation_r, order_info_r, by="RESERV_NO") %>% arrange(RESERV_NO, ITEM_ID)

# select()함수 사용해서 특정 열만 출력
inner_join(reservation_r, order_info_r, by="RESERV_NO") %>% arrange(RESERV_NO, ITEM_ID)  %>% select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)

# left_join()함수 : 왼쪽 기준 모든 데이터 연결하기
left_join(reservation_r, order_info_r, by="RESERV_NO") %>% arrange(RESERV_NO, ITEM_ID) %>% select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)


# full_join()함수 : 양쪽 모든 데이터 연결하기

table_added_row <- order_info_r %>% add_row(ORDER_NO="1", ITEM_ID="1", RESERV_NO="1", SALES=1)

full_join(reservation_r, table_added_row, by="RESERV_NO") %>%   arrange(RESERV_NO, ITEM_ID) %>% select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)

# intersect()함수 : 데이터 교집합 구하기
# reservation_r의 reserv_no 추출
reservation_r_rsv_no <- select(reservation_r, RESERV_NO)

# order_info_r의 reserv_no 추출
order_info_r_rsv_no <- select(order_info_r, RESERV_NO)

# 양쪽 데이터셋에 존재하는 reserv_no
intersect(reservation_r_rsv_no, order_info_r_rsv_no)

# setdiff()함수 : 데이터 빼기
# 예약한 인원 중 주문 안한 인원 제거
setdiff(reservation_r_rsv_no, order_info_r_rsv_no)

# ---------------------dplyr 패키지 활용 ---------------------#

# 평균 방문 고객 수(visitor_cnt)가 세 명 이상인 고객을 구하되, 
# 평균 방국 고객수가 높은 고객부터 출력
reservation_r %>% group_by(CUSTOMER_ID) %>% summarise(avg=mean(VISITOR_CNT)) %>% filter(avg>=3) %>% arrange(desc(avg))


# order_info_r 테이블의 메뉴(item_id)별, 월별 평균 매출을 계산한 후, 메뉴별, 월별로 오름차순 정렬해서 출력하는 메뉴 아이템별 월 평균 매출
my_first_cook <- order_info_r %>% mutate(reserv_month=substr(RESERV_NO, 1, 6)) %>% group_by(ITEM_ID, reserv_month) %>% summarise(avg_sales=mean(SALES)) %>% arrange(ITEM_ID,reserv_month)

my_first_cook

# quiz
install.packages("ggplot2")

mpg <- as.data.frame(ggplot2::mpg)

mpg_a <- mpg %>% filter(displ <= 4)
mpg_b <- mpg %>% filter(displ >= 5)

mean(mpg_a$hwy)
mean(mpg_b$hwy)

mpg_audi <- mpg %>% filter(manufacturer == "audi")
