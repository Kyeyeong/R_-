# 한꺼번에 주석 처리 : ctrl + shift + c


# 문제: dplyr 패키지를 불러오고 현재 작업 폴더 경로 출력하기
library(dplyr)
 
# 문제: 국민건강보험공단_건강검진정보.csv 파일 불러와 View로 출력하기.
health = read.csv('국민건강보험공단_건강검진정보.csv', 
                  fileEncoding = 'CP949', 
                  encoding = 'UTF-8', 
                  check.names = FALSE)
#View(health)

# 문제: 데이터프레임의 앞부분 출력 단, 10행 까지
print(head(health, 10))

# 문제: 데이터프레임의 뒷부분 출력 단, 5행 까지
print(tail(health, 5))

# 문제: 데이터프레임의 데이터 타입 확인
str(health)

# 문제: 성별, 연령대, 그리고 지역 열만 조회
result = health %>% select(`성별`, `연령대코드(5세단위)`, `시도코드`)
print(result)

# 문제: 2022년에 건강검진을 받은 사람 중 음주여부가 1인 사람의 가입자일련번호, 성별 조회
result = health %>% filter(`기준년도`==2022 & `음주여부`==1) %>% select(`가입자일련번호`, `성별`)
print(result)


# 문제: 키(height)와 몸무게(weight) 열을 사용하여 새로운 열 BMI를 추가하세요.
health = health %>% mutate(BMI = `신장(5cm단위)` / (`체중(5kg단위)` / 100)**2 )
print(health)

# 문제: 음주여부와 흡연상태가 1인 사람의 수축기혈압 , 성별 조회. 단, 혈압 내림차순으로 정렬하세요.
result = health %>% filter(`음주여부`==1 & `흡연상태`==1) %>% select(`수축기혈압`, `성별`) %>% arrange(`수축기혈압`)
print(result)

# 문제: 성별(성별)로 데이터를 그룹화하고, 각 그룹별 평균 BMI를 계산하세요. 결과는 성별과 평균_BMI 열로 구성되어야 합니다.
result = health %>% group_by(`성별`) %>% summarise(AVG_BMI = mean(BMI, na.rm=TRUE)) %>% select(`성별`, AVG_BMI)
print(result)

# 문제: 식전혈당 126 이상인 사람 중 수축기혈압 상위 5명 출력
result = health %>% filter(`식전혈당(공복혈당)`>=126) %>% arrange(`수축기혈압`) %>% slice(1:5)
print(result)
  
# 문제: 허리둘레 중앙값 조회
result = health %>% summarise(`허리둘레 중앙값` = median(`허리둘레`, na.ra=TRUE))
print(result)

# 성별로 음주여부가 1인 평균 체중을 막대 그래프로 표현

result = health %>% filter(`음주여부` == 1) %>% group_by(`성별`) %>% summarise(AVG_weight = mean(`체중(5kg단위)`, na.rm=TRUE))
                                                                         
                                                                         
barplot(result$AVG_weight, names.arg = result$`성별`, col= c('blue', 'red'), main ='음주 성별 평균체중', ylab = '평균체중')






