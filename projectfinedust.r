# 서울시의 구 중에서 성북구와 중구의 미세먼지 비교 및 차이 검정
library(readxl)
library(dplyr)

dst <- read_excel("dustdata.xlsx")

head(dst)

# 성북구와 중구만 데이터 추출
dst_edit <- dst %>% filter(area %in% c("성북구", "중구")) 


# 데이터 현황 구체적인 파악
# 데이터 날짜 별 개수 확인

count(dst_edit, yyyymmdd) %>% arrange(desc(n))  # 날짜별로 내림차순 정렬
count(dst_edit, area)               # area 열 기준으로 숫자 세기

# 실행 결과를 보면 빠진 데이터 없이 동일한 날짜는 2개씩
# 구에 따른 미세먼지 수치는 122개씩 포함되어 있음

# 성북구와 중구에 데이터를 각각 분리
# subset(): 조건으로 데이터 선택 subset(데이터, 선택조건)
dust_sb <- subset(dst_edit, area=="성북구")
dust_jg <- subset(dst_edit, area=="중구")

dust_sb
dust_jg

# 분리한 두 개 구의 데이터를 이용해서 기초 통계량을 도출 >>> describe()
install.packages("psych")
library(psych)
describe(dust_sb$finedust)

describe(dust_jg$finedust)

# 성북구와 중구의 미세먼지 분포 확인

boxplot(dust_sb$finedust, dust_jg$finedust, main="finedust_compare", xlab="area",  ylab="finedust",names=c("성북구", "중구"), col=c("blue", "green"))

# t검정
t.test(data=dst_edit, finedust ~ area, var.equal=T)
# p=value = 0.004957로 0.05보다 작다.
# 따라서 귀무가설을 기각(성북구와 중구의 미세먼지 평균은 차이나지 않는다)
# 차이가 있다는 대립가설을 채택한다.