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
gg <- gg+scale_fill_brewer(palette="Spectral")
gg

# direction=-1 추가하면 색상 순서 반대로 
gg <- gg+scale_fill_brewer(palette="Spectral", direction=-1)
gg