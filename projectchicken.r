# 치킨집이 가장 많은 지역 찾기
# 그림의 크기로 많은 지역 표현

# 치킨집 데이터 구하기
# localdata.kr

# 데이터 읽어오기
library("readxl")

ck <- read_excel("치킨집_가공.xlsx")
head(ck)

str(ck)

View(ck)

object.size(ck)

# 동별로 추출하여 상세 주소는 제거. 
# Substr() 사용하여 동까지만 남기고 나머지 삭제
addr <- substr(ck$소재지전체주소, 11, 16)        # substr(): 지정된 자리만큼 문자열 선택
head(addr)

View(addr)

# 숫자들 모두 삭제 : gsub() 사용

addr_num <- gsub("[0-9]", "", addr)

head(addr_num)

# 여백 삭제
addr_trim <- gsub(" ", "", addr_num)
head(addr_trim)

# 동별 업소 개수 확인하기
# 변수의 개수 확인을 위해 table() 함수 사용
library(dplyr)
addr_count <- addr_trim %>% table() %>% data.frame()

head(addr_count)

# 시각화
install.packages("treemap")
library(treemap)

treemap(addr_count, index=".", vSize="Freq", title="서대문구 동별 치킨집 분포")