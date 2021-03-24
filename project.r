# 데이터 준비
library(readxl)
library(ggplot2)
library(dplyr)

customer_r <- read_excel("customer_r.xlsx")
reservation_r <- read_excel("reservation_r.xlsx")
order_info_r <- read_excel("order_info_r.xlsx")
item_r <- read_excel("item_r.xlsx")

colnames(customer_r) <- tolower(colnames(customer_r))
colnames(reservation_r) <- tolower(colnames(reservation_r))
colnames(order_info_r) <- tolower(colnames(order_info_r))
colnames(item_r) <- tolower(colnames(item_r))

# 지점별 예약 건수 빈도표
table(reservation_r$branch)


# 가설 : 전체 예약 건과 예약 완료 건 비율이 유사할 것이다.
# 주문 취소되지 않은 경우만 선택
no_cancel_data <- reservation_r %>% filter(cancel=="N")

# 주문 취소되지 않은 예약 건의 부서별 빈도표
table(no_cancel_data$branch)


# 가설 : 주요 지점들의 메뉴 아이템 매출 구성은 비슷할 것이다.
# 전처리
# reserv_no를 키로 예약, 주문 테이블 연결
df_f_join_1 <- inner_join(reservation_r, order_info_r, by="reserv_no")

# item_id를 키로 df_f_join_1과 메뉴 정보 테이블 연결
df_f_join_2 <- inner_join(df_f_join_1, item_r, by="item_id")

head(df_f_join_2)           # 테이블 세 개가 이너 조인된 것을 확인

# 강남, 마포, 서초 지점만 선택
df_branch_sales <- df_f_join_2 %>% filter(branch=="강남"|branch=="마포"|branch=="서초") %>% group_by(branch, product_name) %>% summarise(sales_amt=sum(sales)/1000)

df_branch_sales


# 교차 빈도 분석: 지점별 메뉴 아이템 주문 비율은?
# reserv_no를 키로 예약, 주문 테이블 연결
df_f_join_1 <- inner_join(reservation_r, order_info_r, by="reserv_no")

# item_id를 키로 df_f_join_1, 메뉴 정보 테이블 연결
df_f_join_2 <- inner_join(df_f_join_1, item_r, by="item_id")

# 주요 지점만 선택
df_branch_items <- df_f_join_2 %>% filter(branch=="강남"|branch=="마포"|branch=="서초")

# 교차 빈도표 생성
table(df_branch_items$branch, df_branch_items$product_name)

# 데이터 프레임 형태로 구조형 변환
df_branch_items_table <- as.data.frame(table(df_branch_items$branch, df_branch_items$product_name))

df_branch_items_table

# 데이터 분석을 위해 데이터 가공
df_branch_items_percent <- df_branch_items_table %>% group_by(df_branch_items_table$ Var1 ) %>% mutate(percent_items=Freq/sum(Freq)*100)        # 주문 비율을 계산해서 열 생성

head(df_branch_items_percent)           # percentage 열이 생성된 것 확인

# 데이터 그리기
# 누적 막대 그래프를 그려 gg변수에 담음
gg <- ggplot(df_branch_items_percent, aes(x=Var1, y=percent_items, group=Var1, fill=Var2))+geom_bar(stat="identity")    # branch=Var1, product_name=Var2, 빈도=Freq

gg

# 제목과 범례 이름 지정
gg <- gg + labs(title="지점별 주문 건수 그래프", x="지점", y="메뉴 아이템 판매비율", fill="판매아이템")

gg


#------------------------고객 현황 파악하기----------------------#
# 가설 : 우리 레스토랑은 여러번 방문하는 고객이 다수이며, 이들이 많은 매출을 일으킬 것이다.
# 테이블조인
# reserv_no를 키로 예약, 주문 테이블 연결
df_rfm_join_1 <- inner_join(reservation_r, order_info_r, by="reserv_no")

head(df_rfm_join_1)

# 고객 번호별 방문 횟수(F)와 매출(M) 정리
df_rfm_data <- df_rfm_join_1 %>% group_by(customer_id) %>% summarise(visit_sum=n_distinct(reserv_no), sales_sum=sum(sales)/1000) %>% arrange(customer_id)

df_rfm_data

summary(df_rfm_data)

# 상자 그림 그리기
ggplot(df_rfm_data, aes(x="", y=visit_sum))+geom_boxplot(width=0.8, outlier.size=2, outlier.colour="red")+labs(title="방문 횟수 상자그림", x="빈도", y="방문횟수")


# 방문 횟수 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$visit_sum, probs=c(0.6, 0.9))

# 매출 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$sales_sum, probs=c(0.6, 0.9))

# 총 방문 횟수와 총 매출 합
total_sum_data <- df_rfm_data %>% summarise(t_visit_sum=sum(visit_sum), t_sales_sum=sum(sales_sum))

# 우수 고객 이상의 방문 횟수와 매출 합
loyalty_sum_data <- df_rfm_data %>% summarise(l_visit_sum=sum(ifelse(visit_sum>2, visit_sum,0)), l_sales_sum=sum(ifelse(sales_sum>135, sales_sum, 0)))

# 차지하는 비율 확인
loyalty_sum_data/total_sum_data


# ----------------상관 분석 : 스테이크와 와인은 관계가 있을까?----------------------#
# 귀무 가설 : 스테이크와 와인의 매출은 상관관계가 없다.
# 대립 가설 : 스테이크와 와인의 매출은 상관관계가 있다.

# 1-1. 데이터 처리 : 동시 주문 건 찾기
# reserv_no를 키로, 예약, 주문 테이블 연결
df_f_join_1 <- inner_join(reservation_r, order_info_r, by="reserv_no")

# item_id를 키로, df_f_join_1과 메뉴 정보 테이블 연결
df_f_join_2 <- inner_join(df_f_join_1, item_r, by="item_id")

target_item <- c("M0005", "M0009")          # 스테이크와 와인

# 스테이크와 메뉴 아이템 동시 주문 여부 확인
df_stime_order <- df_f_join_2 %>% filter((item_id %in% target_item)) %>% group_by(reserv_no) %>% mutate(order_cnt=n()) %>% distinct(branch, reserv_no, order_cnt) %>% filter(order_cnt==2) %>% arrange(branch)

# 동시 주문한 경우의 예약번호 데이터셋
df_stime_order

# 1-2. 데이터 처리 : 메뉴 아이템별 매출 계산
# 동시 주문한 예약 번호만 담는 stime_order 변수 생성
stime_order_rsv_no <- df_stime_order$reserv_no

# 동시 주문 예약 번호이면서 스테이크와 와인일 경우만 선택
df_stime_sales <- df_f_join_2 %>% filter((reserv_no %in% stime_order_rsv_no) & (item_id %in% target_item)) %>% group_by(reserv_no, product_name) %>% summarise(sales_amt=sum(sales)/1000) %>% arrange(product_name, reserv_no)

# 동시 주문 12건이므로 매출 합계 24개 생성(스테이크+와인)
df_stime_sales


steak <- df_stime_sales %>% filter(product_name=="STEAK")   # 스테이크 정보만 담음
wine <- df_stime_sales %>% filter(product_name=="WINE")     # 와인 정보만 담음

# 데이터 그리기
plot(steak$sales_amt, wine$sales_amt)

# 상관 분석하기
cor.test(steak$sales_amt, wine$sales_amt)