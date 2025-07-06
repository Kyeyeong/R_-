# 정규분포
# 확률밀도 그래프의 한 종류로 키, 점수처럼 연속적인 값 분포를 정규분포라고 함
# 동전 앞뒤 = 이항 분포

students = data.frame(
  name = c("Alice", "Bob", "Charlie", "David", "Eve", "Jose"),
  score = c(85, 92, 78, 95, 88, 200)
)

# 1. 평균과 표준편차를 조회
# mean = 평균
mu = mean(students$score)
# sd = 표준편차
sigma = sd(students$score)
# length = 50 곡선을 부드럽게 그려주는 옵션션
# 2. 정규분포 곡선용  x, y값 생성
x = seq(min(students$score), max(students$score), length = 50)
# dnorm : density of the normal distribution(정규분포)dml norm 이 결합된
# dnorm은 주어진 평균과 표준편차를 갖는 정규분포에서 특정 x에 대한 확률 밀도를 계산
# 데이터가 특정 구간에 있을 확률
y= dnorm(x, mu, sigma)
# 정규분포 시각화
# plot(x, y, type = 'l', lwd = 2, col = 'blue', main = '학생 점수 정규분포', xlab= '점수', ylab = '확률')

# Jose 200점 때문에 정규분포 그래프가 이상하게 나옴
# 이상치 제거(데이터 전처리 과정 중 하나)
# 데이터의 분포에서 극단적으로 벗어난 값을 탐지하고 처리하는 방법

# Z-score Z스코어가 0이면 데이터값이 평균과 동일
# 양수 데이터값이 평균보다 크며, 양수값이 클수록 평균에서 멀리 떨어져 있음을 의미
print(students)

# 평균과 표준편가를 구해야 함
mu = mean(students$score)
sigma = sd(students$score)

print(mu)
print(sigma)

students$z_score = abs((students$score - mu) / sigma)  # 공식
print(students)

# 실무에서 2~3은 평균에서 멀리 있다고 암묵적으로 임계값 : 상황에 따라 조절하면 됨

library(dplyr)

이상치제거_데이터 = students %>% filter(z_score < 2)
print(이상치제거_데이터)

# 이상치 제거 후 정규분포 그래프 시각화

mu = mean(이상치제거_데이터$score)
sigma = sd(이상치제거_데이터$score)
# -10, +10 을 추가해 데이터 범위를 넘어선 부드러운 곡선 생성성
x = seq(min(이상치제거_데이터$score)-10, max(이상치제거_데이터$score)+10, length = 50)
y = dnorm(x, mu, sigma)
plot(x, y, type = 'l', lwd = 2, col = 'blue', main = '학생 점수 정규분포', xlab= '점수', ylab = '확률')


# 중앙값, 상위 20%, 하위 20% 선 추가

med = median(이상치제거_데이터$score)
print(quantile(이상치제거_데이터$score))  # 4분위수 출력
q20 = quantile(이상치제거_데이터$score, 0.2)
q80 = quantile(이상치제거_데이터$score, 0.8)

# add line
abline(v=med, col='purple', lwd=2, lty=2)
abline(v=q20, col='orange', lwd=2, lty=2)
abline(v=q80, col='red', lwd=2, lty=2)

# 신뢰구간 추가하기
# 신뢰구간은 진짜 답이 있을 것 같은 범위
# 데이터 행의 수 조회
n = nrow(이상치제거_데이터)
print(sqrt(n))

# 표준오차 : 내가 구한 평균값이 얼마나 믿을 만한지를 알려주는 숫자
# 표준오차 작다 : 내가 구한 평균이 진짜 평균에 가까울 확률이 높다
# 표준오차 크다 : 내가 구한 평균이 진짜 평균과 많이 다를 수 있다
# sqrt 제곱근 square root
# 예 : sqrt(4) = 2, sdqrt(9) = 3
se = sigma /sqrt(n)
# 1.96 통계 분석에서 일반적으로 사용되는 신뢰수준 값 = 95% 신뢰
ci_low = mu - 1.96 * se
ci_high = mu + 1.96 * se

# 신뢰구간 그래프 표현
abline(v=ci_low, col='black', lwd=2)
abline(v=ci_high, col='black', lwd=2)







