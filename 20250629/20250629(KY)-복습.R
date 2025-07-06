data = data.frame(
  name = c('a','b','c','d','e','f'),
  heights  = c(120, 130, 140, 150, 160, 200)
)
print(data$heights)    # $ 열접근
print(data[3, c('name', 'heights')])

# $ : 새로운 컬럼을 생성할 수 있음  
# $ = 조회, 수정, 추가
# [] = 조회(행, 열열)
data$birth = c('1999-01-01', '1999-01-01', '1999-01-01', '1999-01-01', '1999-01-01', '1999-01-01')


# 데이터 구조 확인
str(data)


# 날짜형으로 변경
data$birth = as.Date(data$birth)
str(data)


# 이상치 제거 IQR : 수집한 데이터가 소득, 센서데이터 등(비대칭 데이터) 이런 데이터를 탐지할때 사용

# 1. Q1과 Q3을 구하기
Q1 = quantile(data$heights, 0.25) # 하위 25%
cat('Q1 : ', Q1, '\n')
Q3 = quantile(data$heights, 0.75) # 하위 75%
cat('Q3 : ', Q3, '\n')

# 2. IQR(사분위 범위) 구하기
# 프로그래밍에서 변수가 대문자 => (암묵적으로) 수정 금지, 소문자 => 수정 가능

IQR_VALUE = Q3 - Q1
cat('IQR_VALUE : ', IQR_VALUE, '\n')

# 3. 이상치 기준선 만들기
# 1.5 존 튜키, 통계학자가 제안한 것으로 표준 기준으로 널리 사용

lower_bound = Q1 - 1.5 * IQR_VALUE
upper_bound = Q3 + 1.5 * IQR_VALUE

cat('lower_bound : ', lower_bound, '\n')
cat('upper_bound : ', upper_bound, '\n')

# 4. 이상치 확인
library(dplyr)
outliers = data %>% filter(heights < lower_bound | heights > upper_bound)
print(outliers)

# 키 데이터 변환
data$heights = c('120cm', '130', '140', '150', '160', '200')
str(data)

# 1. 문자열 처리 'cm' 제거
data$heights = gsub('cm', '', data$heights)
str(data)

data$heights = as.numeric(data$heights)
str(data)

print(sum(data$heights))








