# 건강한 시리얼 찾기(저칼로리, 저설탕)

# 1. 데이터 수집
# DB로 저장(RDB, NoSQL) -> csv로 변환 -> 파이썬이라 R로 시작
# RDB : 관계형DB(MySQL, Oracle, MSSQK...)
# NoSQL(= 서버, 데이터 쌓고 조회하는 용도) : DynamoDB(AWS, 유료), MongoDB(무료) -> 2top 이중 MongoDB가 유명명
# IoT 데이터를 일단 NoSQL에 쌓아  

scereal = read.csv('UScereal.csv')  # 수집했다고 가정정

# 2. 데이터 구조와 변수 확인
str(scereal)
# num = 실수, int = 정수, chr = 문자
# 데이터 확인
print(head(scereal, 3))
print(colnames((scereal)))
print(colSums(is.na(scereal)))

# 결측값이 너무 많으면 다시 처음부터 수집(수집 소스 디버깅(파악))
# 결측값이 수용 수준이면 특정 값으로 대체 또는 해당 행을 삭제

# 3. 데이터 탐색 및 시각화 (EDA:Exploratory Data Analysis)
# 칼로리와 설탕에 대한 기본적인 통계 출력(평균, 중앙값, 최댓값...)

칼로리_평균 = mean(scereal$calories, na.rm = TRUE)
칼로리_중앙값 = median(scereal$calories, na.rm = TRUE)
칼로리_최솟값 = min(scereal$calories, na.rm = TRUE)
칼로리_최댓값 = max(scereal$calories, na.rm = TRUE)

cat('칼로리 평균 : ', 칼로리_평균, '\n')
cat('칼로리 평균 : ', 칼로리_중앙값, '\n')
cat('칼로리 평균 : ', 칼로리_최솟값, '\n')
cat('칼로리 평균 : ', 칼로리_최댓값, '\n')

설탕_평균 = mean(scereal$sugars, na.rm = TRUE)
설탕_중앙값 = median(scereal$sugars, na.rm = TRUE)
설탕_최솟값 = min(scereal$sugars, na.rm = TRUE)
설탕_최댓값 = max(scereal$sugars, na.rm = TRUE)
설탕_표준편차 = sd(scereal$sugars, na.rm = TRUE)

cat('설탕 평균 : ', 설탕_평균, '\n')
cat('설탕 평균 : ', 설탕_중앙값, '\n')
cat('설탕 평균 : ', 설탕_최솟값, '\n')
cat('설탕 평균 : ', 설탕_최댓값, '\n')
cat('설탕 표준편차 : ', 설탕_표준편차, '\n')
# 표준편차 : 데이터가 평균으로부터 얼마나 퍼져있는지를 나타내는 통계적 지표
# 즉, 표준편차가 작으면 대부분의 값이 평균 근처에 있음
# 이게 작은 수치인가?
# 변동 계수로 데이터가 평균에 비해 넓게 분포되어 있는지 아닌지 확인하자
# 변동계수 = (표준편차 / 평균) * 100

CV = (설탕_표준편차/설탕_평균) * 100
cat('설탕 변동계수 : ', CV, '\n')
# CV가 50% 이상이면 데이터가 평균에 비해 상당히 넓게 분포되어 있음
# 10~20%면 고르게 분포라고 해석
if( CV >= 50){
  print('설탕의 데이터는 상당히 넓게 분포되어 있습니다.')
  
}


# 더 쉽게 요약
print(summary(scereal$calories))   # 특정 컬럼 사분위수 포함 평균 확인
print(summary(scereal$sugars))

# 상관관계 파악
설탕_칼로리_상관관계 = cor(scereal$sugars, scereal$calories, use = 'complete.obs')
cat('설탕과 칼로기 상관계수 : ', 설탕_칼로리_상관관계, '\n' ) # 0.4952942 = 보통관계

# 전체적인 패턴을 시각화로 표현
library(ggplot2)
# install.packages('patchwork')
library(patchwork)

# 칼로리 평균, 설탕 평균 시각화

p1 = ggplot(scereal, aes(x = calories)) +
  geom_histogram(binwidth = 10, fill = 'skyblue', color = 'white') + # 막대 설정
  geom_vline(xintercept = 칼로리_평균, color = 'red', linetype = 'dashed', size = 1) + # 평균선
  labs(title = '시리얼 칼로리 분포', x = '칼로리', y = '제품 수')

# print(p1)

p2 = ggplot(scereal, aes(x = sugars)) +
  geom_histogram(binwidth = 10, fill = 'orange', color = 'white') + # 막대 설정
  geom_vline(xintercept = 설탕_평균, color = 'red', linetype = 'dashed', size = 1) + # 평균선
  labs(title = '시리얼 설탕 분포', x = '설탕', y = '제품 수')

# print(p2)

# 제조사별 칼로리 박스 플롯

p3 = ggplot(scereal, aes(x= mfr, y = calories, fill = mfr)) +
  geom_boxplot() +
  labs(title = '제조사별 칼로리 분포', x= '제조사', y = '칼로리')
  
# print(p3)

# p1, p2, p3를 한꺼번에 출력하기
# | : 가로 배치, / : 세로 배치
print( (p1 | p2) / p3  )
  
ggsave('myplot3.png', width = 10, height = 6, dpi = 300, bg = 'white')  


# 4. 데이터 전처리 (min-max, 이상치 제거, 결측값 처리)

# 저칼로리와 저설탕 기준 설정(전체 25% 이하를 LOW로 간주)

저칼로리 = quantile(scereal$calories, 0.25, na.rm = TRUE) # 하위 25%
저설탕 = quantile(scereal$sugars, 0.25, na.rm = TRUE) # 하위 25%

scereal$low_cal = ifelse(scereal$calories <= 저칼로리, TRUE, FALSE)
scereal$low_sugar = ifelse(scereal$sugars <= 저설탕, TRUE, FALSE)
# 이상치 제거는 생략
# View(scereal)

# 5. 실용적 분석

library(dplyr)

# 저칼로리, 저설탕 추출
건강한시리얼 = scereal %>% filter(low_cal & low_sugar)  #반대는 !low_cal & !low_sugar
print(head(건강한시리얼, 3))


# 제조사별 건강한 시리얼 개수 집계
제조사별_건강시리얼 = 건강한시리얼 %>% 
  group_by(mfr) %>% 
  summarise(cnt = n()) %>%
  arrange(desc(cnt))
print(제조사별_건강시리얼)



# 최종 시각화

최종건강한시리얼 = ggplot(제조사별_건강시리얼, aes(x = mfr, y = cnt, fill = mfr)) +
  geom_bar(stat = "identity") +  # 데이터의 y축 값을 그래프에 반영하겠다
  labs(title = '제조사별 건강한 시리얼', x = '제조사', y = '개수') +
  theme_minimal()

print(최종건강한시리얼)
