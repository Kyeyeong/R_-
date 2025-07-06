# 폴더 경로 확인

print(getwd())   # 폴더 조회
print(list.files())  # 폴더에 저장된 파일 조회
list.files(all.files = TRUE)

setwd("C:/Users/kcs/Desktop/r_workspace/data")
print(list.files()) 
list.files(all.files = TRUE)

weather = read.csv('대전날씨데이터.csv', 
                   na.strings = c(""), 
                   fileEncoding = 'CP949', 
                   encoding = 'UTF-8', 
                   check.names = FALSE)

str(weather)

# 컬럼명(벡터명)을 영어로 수정

colnames(weather) =  c("station_id", "station_name", "datetime", "temp", "precip", "windspeed", "winddir", "humidity","CA")
str(weather)

# 각 컬럼들 결측값 조회
print(colSums(is.na(weather)))
weather$precip = ifelse(is.na(weather$precip), 0, weather$precip)
print(colSums(is.na(weather)))

# 수집한 날짜 데이터에 시간, 분, 초가 있으면 as.Date로 변환시 생략됨
# 그래서 as.POSIXct()

weather$datetime = as.POSIXct(weather$datetime, format='%Y-%m-%d %H:%M')
# weather$datetime = as.POSIXct(format(weather$datetime, "%Y-%m-%d %H:%M"), format="%Y-%m-%d %H:%M")

# 산점도
plot(weather$temp, weather$humidity, col= c('red', 'blue'),
     xlab= '온도', ylab = 'humidity', main = 'temperature vs humidity')

# 범례추가
legend('topright', 
       legend = unique(weather$station_name), 
       col = c('black'), 
       pch = 19)

# 클러스터링(군집, 덩어리, 무리) 시각화
# 예 : 비슷한 날씨 패턴 가진 지점 그룹화화

# Kmeans(K 평균 군집화)
# 기온하고 습도 열만 선택 []
weather_var = weather[, c('temp', 'humidity')]

# 항상 똑같은 결과가 나오게 해줘
set.seed(123)

# 데이터를 3개의 그룹으로 나눠줘
clusters = kmeans(weather_var, centers=6)

# 군집결과 시각과
plot(weather$temp, weather$humidity, col=clusters$cluster,
     xlab='temp', ylab='humidity', main='cluster of temp vs humidity')

# 풍향과 풍속 시각화
library(openair)   # 바람데이터를 시각화화

windRose(weather, ws='windspeed', wd = 'winddir')

# 풍속와 습도의 상관관계
print(cor(weather$windspeed, weather$humidity))   #음의 관계

# 온도 변화 시계열 그래프
plot(weather$datetime, weather$temp, type='l', col='blue',
     xlab='date', ylab='temp', main='Time series of temperature changes by date')









