# ----------------ggplot2--------------------#
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


ggplot(data = pressure, aes(x=temperature, y=pressure)) + geom_line()


df_cfm_order <- inner_join(reservation_r, order_info_r, by = "reserv_no") %>% select(customer_id, reserv_no, visitor_cnt, cancel, order_no, item_id, sales) %>% arrange(customer_id, reserv_no, item_id)

df_sct_graph <- df_cfm_order %>% group_by(customer_id) %>% summarise(vst_cnt=sum(visitor_cnt), cust_amt=sum(sales/1000))
 
head(df_sct_graph)

head(df_cfm_order)

ggplot(data=df_sct_graph, aes(x=vst_cnt, y=cust_amt))

ggplot(data=df_sct_graph, aes(x=vst_cnt,  y=cust_amt)) + geom_point() + xlim(0,50) + ylim(0,500)

head(customer_r)

df_sct_graph2 <- inner_join(df_sct_graph, customer_r, by="customer_id") %>% select(vst_cnt, cust_amt, sex_code)

head(df_sct_graph2)

ggplot(data=df_sct_graph2, aes(x=vst_cnt, y=cust_amt, color=sex_code)) + geom_point() + xlim(0, 50) + ylim(0, 500)


# 막대 그래프 데이터 준비
df_branch_sales_1 <- inner_join(reservation_r, order_info_r, by="reserv_no") %>% select(branch,sales) %>% arrange(branch,sales)

# 지점별로 매출 합산
df_branch_sales_2 <- df_branch_sales_1 %>% group_by(branch) %>% summarise(amt=sum(sales)/1000) %>% arrange(desc(amt))

df_branch_sales_2

# 막대 그래프 그리기
ggplot(df_branch_sales_2, aes(x=branch, y=amt))+geom_bar(stat="identity")

# 막대 그래프 순서 정렬하기(reorder())
ggplot(df_branch_sales_2, aes(x=reorder(branch,-amt), y=amt)) + geom_bar(stat="identity")

# 자동으로 막대 그래프에 색상 채우기(fill=branch)
ggplot(df_branch_sales_2, aes(x=reorder(branch,-amt), y=amt, fill=branch)) + geom_bar(stat="identity")

# 막대 그래프 일부만 선택하기(xlim())
gg <- ggplot(df_branch_sales_2, aes(x=reorder(branch, -amt), y=amt, fill=branch))+geom_bar(stat="identity")+xlim(c("강남", "영등포", "종로", "용산", "서초"))
gg

# 가로 막대 그래프 그리기
gg <- ggplot(df_branch_sales_2, aes(x=reorder(branch, -amt), y=amt, fill=branch))+geom_bar(stat="identity")+xlim(c("서초", "용산", "종로", "영등포", "강남"))
gg <- gg+coord_flip()
gg

# 범례(legend) 조정 : legend.position = "bottom"/"top"/"right"/"left"
gg <- gg + theme(legend.position="bottom")
gg

# 범례 항목 순서 바꾸기
gg <- gg + scale_fill_discrete(breaks=c("강남", "영등포", "종로", "용산", "서초"))
gg


# ----------------------히스토그램: 도수 분포 확인-------------------#
# 지점 예약 건수 히스토그램
gg <- ggplot(data=reservation_r, aes(x=branch)) + geom_bar(stat="count")
gg

# 타이틀과 축 제목 변경하기
gg <- gg + labs(title="지점별 예약 건수", x="지점", y="예약건")
gg

# theme() 함수로 그래프 세부 조정하기
gg <- gg + theme(axis.title.x = element_text(size =15, color = "blue", face = 'bold', angle = 0), axis.title.y = element_text(size = 13, color='red', angle=90))
gg

# geom_histogram() 함수로 연속형 데이터 히스토그램 그리기
ggplot(data=order_info_r, aes(x=sales/1000)) + geom_histogram(binwidth=5)


# 파이차트: 상대적 크기 확인

# 파이 차트 데이터 준비하기
df_pie_graph <- inner_join(order_info_r, item_r, by="item_id") %>% group_by(item_id, product_name) %>% summarise(amt_item=sum(sales/1000)) %>% select(item_id, amt_item, product_name)

df_pie_graph

# 누적 막대 그래프 그리기
ggplot(df_pie_graph, aes(x="", y=amt_item, fill=product_name)) + geom_bar(stat="identity")

# 파이 차트 그리기
gg <- ggplot(df_pie_graph, aes(x="", y=amt_item, fill=product_name)) + geom_bar(stat="identity") + coord_polar("y", start=0)
gg

# 자동으로 파이 차트에 팔레트 색상 채우기(scale_fill_brewer())
gg <- gg+scale_fill_brewer(palette="Oranges")
gg

# direction=-1 추가하면 색상 순서 반대로 
gg <- gg+scale_fill_brewer(palette="Spectral", direction=-1)
gg


# 선 그래프 데이터 준비
# 예약 번호 별로 매출 합계 구하기
total_amt <- order_info_r %>% group_by(reserv_no) %>% summarise(amt_daily=sum(sales/1000)) %>% arrange(reserv_no)
 
 total_amt

#  선 그래프 그리기
# 예약 번호 순서를 x축으로 해서 선 그래프 그리기
ggplot(total_amt, aes(x=reserv_no, y=amt_daily, group=1)) + geom_line()

# 월별 매출 선 그래프 그리기
# 예약번호 1~6번째 자리 선택해서(월로 만듦) 그룹핑
total_amt <- order_info_r %>% mutate(month=substr(reserv_no, 1, 6)) %>% group_by(month) %>% summarise(amt_monthly=sum(sales/1000))

total_amt

ggplot(total_amt, aes(x=month, y=amt_monthly, group=1)) + geom_line()

# 선 그래프 꾸미기

# 점 그리기
ggplot(total_amt, aes(x=month, y=amt_monthly, group=1)) + geom_line() + geom_point()

# 색상 및 레이블(텍스트 데이터) 추가
ggplot(total_amt, aes(x=month, y=amt_monthly, group=1, label=amt_monthly)) + geom_line(color="red", size=1)+ geom_point(color="darkred", size=3) + geom_text(vjust=1.5, hjust=0.5)


# ToothGrowth 자료 분석해보기
tail(ToothGrowth)

help(ToothGrowth)

 #  ToothGrowth 데이터를 투여량별로 그룹화 > 표준편차, 평균
df <- ToothGrowth %>% group_by(dose) %>% summarise(sd=sd(len), len=mean(len))  

df

# 투여량(dose)와 성장길이(len) 상관관계 선 그래프로 표현
ggplot(df, aes(dose,len), group=1) + geom_line()

df2 <- ToothGrowth %>% group_by(dose, supp) %>% summarise(sd=sd(len), len=mean(len))

dfname <- data.frame(a = character(), b = character())

ggplot(df2, aes(dose, len)) + geom_line(aes(group=supp))

ggplot(df2, aes(dose, len)) + geom_line(aes(group=supp, linetype=supp)) + geom_point(size=2)

ggplot(df2, aes(dose, len)) + geom_line(aes(group=supp, linetype=supp)) + geom_point(size=2) + theme_classic()


# -----------------------상자 그림 :데이터 분포 확인---------------------------#

# 아이템 메뉴 이름 연결(조인)
df_boxplot_graph <- inner_join(order_info_r, item_r, by="item_id")

df_boxplot_graph

# 상자 그림 그리기
ggplot(df_boxplot_graph, aes(x=product_name, y=sales/1000)) + geom_boxplot(width=0.8, outlier.size=2, outlier.colour="red") + labs(title="메뉴아이템 상자그림", x="메뉴", y="매출")