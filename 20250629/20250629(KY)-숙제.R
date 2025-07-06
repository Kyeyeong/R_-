weather = read.csv('대전부산등날씨.csv', 
                   na.strings = c(""), 잇잇
                   fileEncoding = 'CP949', 
                   encoding = 'UTF-8', 
                   check.names = FALSE)


str(weather)




colnames(weather) =  c("station_id", "station_name", "datetime", "temp", "precip", "windspeed", "winddir", "humidity","CA")
str(weather)

print(summary(weather$humidity))
print(table(weather$station_name))
print(nrow(weather))


# 문자로 입력된 날짜를 문자형으로 변환합니다.
weather$datetime = as.POSIXct(weather$datetime, format="%Y-%m-%d %H:%M")
str(weather)



# 결측값 조회 및 0으로 대체
print(colSums(is.na(weather)))
weather$precip = ifelse(is.na(weather$precip), 0, weather$precip)
weather$CA = ifelse(is.na(weather$CA), 0, weather$CA)

print(colSums(is.na(weather)))

### 온도와 습도의 상관관계
colors = rainbow(6)   # 지점 총 6개
# 시각화
plot(weather$temp, weather$humidity, col=colors, main='온도와 습도의 상관관계')
legend('topright', legend=unique(weather$station_name),
       col=colors, pch=19, cex=0.7)  # pch 점크기, cex 크기를 줄이다다

# 풍속, 풍향, 습도의 통계량을 확인

# 풍속 통계량
summary(weather$windspeed)

# 풍향 통계량
summary(weather$winddir)

# 습도 통계량
summary(weather$humidity)

# 습도의 표준편차와 변동계수 구하기

humidity_sd = sd(weather$humidity, na.rm = TRUE)
humidity_avg = mean(weather$humidity, na.rm = TRUE)
CV = (humidity_sd / humidity_avg) * 100
cat('습도 변동 계수 : ', CV, '\n')

#풍속과 습도의 상관관계 조회
# 상관계수(-1~1 사이로 0에 가까울수록 상관관계 약함) 행렬
# mat(행렬)
# $ : 컬럼 접근, [] : 데이터 접근
cor_mat = cor(weather[, c('windspeed', 'humidity')], use = 'complete.obs')
print(cor_mat)

### 기온, 풍속, 풍향, 습도, 전운량 상관관계 확인 및 시각화
cor_mat = cor(weather[, c('temp', 'winddir', 'windspeed', 'humidity', 'CA')], use = 'complete.obs')
print(cor_mat)
# 그래프로 해당 상관관계 표현
# 시각적 탐색(EDA)
# 단일변수 시각화
# 두 변수간의 관계 시각화

library(corrgram)  # 상관관계 그래프

# 시각화
corrgram(cor_mat, main = '기온, 풍속, 풍향, 습도, 전운량 상관계수',
         lower.panel = panel.shade,
         upper.panel = panel.cor
)


### 온도와 습도 데이터 분포를 히스토그램으로 표현
par(mfrow = c(1, 1))
hist(weather$temp, main = '온도 데이터 분포', xlab='온도(c)')
hist(weather$humidity, main = '습도 데이터 분포', xlab='습도(c)')

### 풍속의 이상치를 탐색하기 위해 박스플롯 표현
boxplot(weather$windspeed, main = '풍속 박스플롯', ylab = '풍속')


### 온도와 습도의 상관관계 표현, 도시 별 색깔 다르게 지정. 단, 범례도 추가할 것

# 산점도
plot(weather$temp, weather$humidity, col= c('red', 'blue'),
     xlab= 'temp', ylab = 'humidity', main = 'temperature vs humidity')

# 범례추가
legend('topright', 
       legend = unique(weather$station_name), 
       col = c('black'), 
       pch = 19)


### 풍속과 풍향 시각화
library(openair)   # 바람데이터를 시각화
windRose(weather, ws='windspeed', wd = 'winddir')


### 풍속과 습도 K 평균 군집화 시각화
weather_var = weather[, c('windspeed', 'humidity')]

# 항상 똑같은 결과가 나오게 해줘
set.seed(123)

# 데이터를 3개의 그룹으로 나눠줘
clusters = kmeans(weather_var, centers=3)

# 군집결과 시각화

plot(weather$windspeed, weather$humidity, col=clusters$cluster,
     xlab='windspeed', ylab='humidity', main='cluster of temp vs humidity')


### 온도 변화 시계열 그래프 그리기
weather$date = as.Date(weather$datetime)
plot(weather$date, weather$temp, type='l', col='blue',
     xlab='date', ylab='temp', main='Time series of temperature changes by date')


# 월별로 x축 레이블 표기
month = seq(as.Date('2025-01-01'), as.Date('2025-07-01'), by="month")
axis.Date(1, at=month[month<= max(weather$date)],format='%Y-%m', las=1, cex.axis = 0.7)







