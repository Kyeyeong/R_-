### 시각화

# emp.csv 파일 불러오기
print(getwd())
print(list.files())
emp = read.csv('emp.csv')
# View(emp)

library(dplyr)

# 1. 박스플롯
# 여러 그룹의 데이터 분포를 비교하여 중앙값과 퍼짐 정도의 차이를 분석
# 예) 남여 영어점수 비교, 팁별 영업성과 비교

# 해당 그래프를 PDF로 변화
pdf('부서별급여_박스플롯.pdf', family = 'Korea1deb')

boxplot(emp$SAL ~ emp$DEPTNO, main = '부서별 급여 현황', xlab = '부서', ylab = '급여', col = c('orange', 'green', 'blue'))

dev.off() # pdf 다운로드 종료

# 2. 막대그래프
# 범주형 데이터 빈도나 크기를 비교할 때 사용용
# 예) 제품별 판매량 비교, 직업에 따른 평균 소득

# 부서별 평균급여를 막대그래프로 표현
# 전처리로 평균 급여 조회
result = emp %>% group_by(DEPTNO) %>% summarise(AVG_SAL = mean(SAL))
#names.arg : X축 데이터 표시, 
barplot(result$AVG_SAL, names.arg = result$DEPTNO, main ='부서별 평균 급여', ylab = '급여')

# 3. 히스토그램
# 데이터를 일정한 구간으로 나누고, 각 구간에 속하는 데이터의 빈도를 막대 높이로 표현
# mutate 기존 열을 수정하거나 추가할때 

# mutate 사용해서 직원 COMM이 NA인 직원만 100 지급
emp = emp %>% mutate(COMM = ifelse(is.na(COMM), 100, COMM)) # 수정

# mutate 사용햇 직원 급여와 직원 커미션을 어한 새로운 컬럼(열) 생성
# SUM_SAL_COMM 만들기
emp = emp %>% mutate(SUM_SAL_COMM = SAL + COMM) # 추가
print(emp)

pdf('급여+커미션_히스토그램.pdf', family = 'Korea1deb')

hist(emp$SUM_SAL_COMM, main = '직원 급여 + 커미션 분포', xlab = '급여+커미션', ylab = '빈도')
# 평균선 추가 add a line : 직선을 
# lwd line width : 선 두께
abline(v = mean(emp$SUM_SAL_COMM), col = 'red', lwd = 3)

dev.off()

# 4. 산점도
# 변수 간 관계 시각화
# 예) 키와 몸무계 관계, 온도와 에너지 소비량 관계
# pch 점 크기
x = c(1, 4, 2, 6, 10, 15)
y = c(2, 3, 6, 5, 10, 20)
plot(x, y, main='산점도 예시', xlab = 'x값', ylab = 'y값', col ='blue', pch = 20)
# 회귀선 추가 
# linear model : 선형 모델
model = lm(y~x)
abline(model, col = 'red', lwd=2)


# 5. 데이터 스케일링
# 전처리 방법 중 하나로, 분석과 머신러닝에서 중요한 과정

# 데이터프레임 생성
data = data.frame(
  height_cm=c(157, 166, 177, 188, 190),
  weight_kg=c(50, 60, 70, 80, 90)
  
)

# 다른 단위의 수치를 통일
# min-max라는 기법을 통해서 분석할 데이터를 0과 1사이로 변환
# 즉, 모든 데이터는 0과1사이에 존재
# 암기 
# 스케일링 = 기존값 - 최솟값/ 최댓값 - 최솟값

height_min = min(data$height_cm)
height_max = max(data$height_cm)

# 스케일링 결과 컬럼 추가
data$height_scaled = (data$height_cm - height_min) / (height_max - height_min)

#View(data)


# 스케일링 = 기존값 - 최솟값/ 최댓값 - 최솟값

weight_min = min(data$weight_kg)
weight_max = max(data$weight_kg)

# 스케일링 결과 컬럼 추가
data$weight_scaled = (data$weight_kg - weight_min) / (weight_max - weight_min)

View(data)







