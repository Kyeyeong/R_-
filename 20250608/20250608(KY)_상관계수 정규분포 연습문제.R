library(dplyr)

# csv 파일 불러오기
Sensor_data = read.csv('sensor_data.csv', fileEncoding = 'CP949', encoding = 'UTF-8', check.names=FALSE)
# View(Sensor_data)

str(Sensor_data)  # 데이터 타입확인 : 숫자? 문자?

# 1. 이상치 제거

# 우선, 평균과 표준편차를 구해야 함
mu = mean(Sensor_data$온도)
sigma = sd(Sensor_data$온도)

print(mu)
print(sigma)

Sensor_data$z_score = abs((Sensor_data$온도 - mu) / sigma)  # 공식
print(Sensor_data)

이상치제거_데이터 = Sensor_data %>% filter(z_score < 3)  # 2는 비교적 넒은 범위의 이상치를 탐지할때
print(이상치제거_데이터)


# 2. 정규분포 그리기 시각화

mu = mean(이상치제거_데이터$온도)
sigma = sd(이상치제거_데이터$온도)
# -10, +10 을 추가해 데이터 범위를 넘어선 부드러운 곡선 생성성
x = seq(min(이상치제거_데이터$온도)-10, max(이상치제거_데이터$온도)+10, length = 50)
y = dnorm(x, mu, sigma)

# pdf 저장
pdf('sensor_data.pdf', family = 'Korea1deb') #pdf 선언
# 정규분포 그리기
plot(x, y, type = 'l', lwd = 2, col = 'blue', main = '온도도센서 정규분포', xlab= 'Temperature', ylab = 'Prob')
# 중앙값, 하위 20%, 상위 20% 조회
med = median(Sensor_data$온도)
q20 = median(Sensor_data$온도, 0.2)
q80 = median(Sensor_data$온도, 0.8)

# 선 표시
abline(v=med, col='purple')
abline(v=q20, col ='black')
abline(v=180, col='orange')

# 신뢰구간 표시
n = nrow(Sensor_data)
se = sigma / sqrt(n)
# 신뢰구간(confidence interval) 계산
ci_low = mu - 1.96 * se
ci_high = mu + 1.96 * se
# 신뢰구간 표기
abline(v=ci_low, col ='red', lwd = 2, lty=4)
abline(v=ci_high, col ='red', lwd = 2, lty=4)

dev.off()