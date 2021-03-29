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


# 어떤 고객들이 스테이크를 구입하는지 알아보기
# 1-1. 데이터 처리하기 : 고객별 스테이크 주문 여부 확인

# (A) 모든 고객의 예약 번호 데이터셋 생성
df_rsv_customer <- reservation_r %>% select(customer_id, reserv_no) %>% arrange(customer_id, reserv_no)

head(df_rsv_customer)       # 고객별 예약번호 확인

# (B) 스테이크 주문 예약 번호 데이터셋 생성
df_steak_order_rsv_no <- order_info_r %>% filter(item_id=="M0005") %>% mutate(steak_order="Y") %>% arrange(reserv_no)

head(df_steak_order_rsv_no)     # 데이터셋 확인

# 고객의 모든 예약 번호(A)에 대해 스테이크 주문한 예약 번호(B)를 레프트 조인
df_steak_order_1 <- left_join(df_rsv_customer, df_steak_order_rsv_no, by="reserv_no") %>% group_by(customer_id) %>% mutate(steak_order=ifelse(is.na(steak_order), "N", "Y")) %>% summarise(steak_order=max(steak_order)) %>% arrange(customer_id)

# ifelse(조건식, TRUE일 때 값, FALSE일 때 값)
# is.na(steak_order) : steak_order가 NA인지 여부. NA이면 TRUE, 아니면 FALSE 반환
# max(): 최댓값 구하는 함수

df_dpd_var <- df_steak_order_1      # 최종 정리된 고객별 스테이크 주문 여부

df_dpd_var      # 종속 변수, 최종 고객 182명의 스테이크 주문 여부 결과 확인


# 1-2 : 고객 성별, 방문 횟수, 방문객 수, 매출 요약(독립 변수 생성)

# 결측치 제거
df_customer <- customer_r %>% filter(!is.na(sex_code))      # 성별이 없으면(NA) 고객 번호 제거

# 고객 테이블과 예약 테이블 customer_id를 키로 이너 조인
df_table_join_1 <- inner_join(df_customer, reservation_r, by="customer_id")

# df_table_join_1과 주문 테이블의 reserv_no를 키로 이너 조인
df_table_join_2 <- inner_join(df_table_join_1, order_info_r, by="reserv_no")
str(df_table_join_2)        # df_table_join_2 테이블 구조 확인

head(df_table_join_2)

# 고객 정보, 성별 정보와 방문 횟수, 방문객 수, 매출 합 요약
df_table_join_3 <- df_table_join_2 %>% group_by(customer_id, sex_code, reserv_no, visitor_cnt) %>% summarise(sales_sum=sum(sales)) %>% group_by(customer_id, sex_code) %>% summarise(visit_sum=n_distinct(reserv_no), visitor_sum=sum(visitor_cnt), sales_sum=sum(sales_sum)/1000) %>% arrange(customer_id)

# n_distinct(): 중복이 아닌 값을 세는 함수, 여기서는 중복이 아닌 예약 번호 카운팅(=방문 횟수)

df_idp_var <- df_table_join_3

df_idp_var


# 1-3. 최종 정리
# 독립 변수 데이터셋(1-2)에 종속변수 데이터셋(1-1) 이너 조인
df_final_data <- inner_join(df_idp_var, df_dpd_var, by="customer_id")

# 의사 결정 나무 함수를 사용하려고 열 구조를 팩터형으로 바꿈
df_final_data$sex_code <- as.factor(df_final_data$sex_code)
df_final_data$steak_order <- as.factor(df_final_data$steak_order)

df_final_data <- df_final_data[, c(2:6)]        # 의사 결정 나무에 필요한 열만 선택
df_final_data               # 최종 분석용 데이터셋 확인



# 아래 패키지 설치후 의사 결정 나무 분석 진행
install.packages("rpart")
library(rpart)

install.packages("caret")
library(caret)

install.packages("e1071")
library(e1071)

# 난수를 생성할 때 무작위수를 생성하지 않고 1만 번대 값을 고정으로 가져옴
set.seed(10000)

# 80% 데이터는 train을 위해 준비하고, 20% 데이터는 test를 위해 준비함
train_data <- createDataPartition(y=df_final_data$steak_order, p=0.8, list=FALSE)
train <- df_final_data[train_data,]
test <- df_final_data[-train_data,]
# createDataPartition : 데이터 나누기 함수. df_final_data의 steak_order열을 기준응로 80%의 행 데이터를 나눔. list=False는 리스트 구조로 출력하지 않겠다는 의미
# -train_data : 훈련 데이터셋을 제외한 데이터. 즉, 80%외 20% 의미

# rpart를 사용해서 의사 결정 나무 생성
decision_tree <- rpart(steak_order~., data=train)

# decision_tree 내용 확인
decision_tree

# 모델의 정확도 확인
predicted <- predict(decision_tree, test, type='class')
confusionMatrix(predicted, test$steak_order)
# predict : 모델 예측 함수
# confusionMatrix : 모델 교차표와 정확도를 확인하는 함수


# decision_tree 내용 그려보기
plot(decision_tree, margin = 0.1)   # 의사 결정 나무 그리기
text(decision_tree)                 # 의사 결정 나무 텍스트 쓰기


# rattle 패키지 사용해서 좀 더 직관적으로 그려보기
install.packages("rattle")
library(rattle)

fancyRpartPlot(decision_tree)