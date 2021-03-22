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

# mutate() : 열 조작해서 새로운 열 생성
# substr() : 지정한 자리만큼 문자열 선택

my_first_cook <- order_info_r %>% mutate(reserv_month=substr(reserv_no,1,6)) %>% group_by(item_id, reserv_month) %>% summarise(avg_sales=mean(sales)) %>% arrange(item_id, reserv_month)

my_first_cook           # 메뉴 아이템별 월 평균 매출을 담은 데이터

# 선그래프로 그려보기
# 각 선 그래프는 자동 채움 Paired 팔레트 색상으로 표현
# x축에는 '월', y는 '매출', 타이틀은 '메뉴 아이템별 월 평균 매출 추이'
ggplot(my_first_cook, aes(x=reserv_month, y=avg_sales, group=item_id, color=item_id)) + geom_line(size=1) + geom_point(color= "darkorange", size=1.5) + scale_color_brewer(palette = "Paired") + labs(title="메뉴 아이템별 월 평균 매출 추이", x="월", y="매출")