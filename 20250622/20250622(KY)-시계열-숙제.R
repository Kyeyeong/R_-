# 1. 데이터 수집
# 1-1. 수집한 데이터 불러오기

weather = read.csv('날씨데이터2.csv',
                   na.strings = c(""),
                   fileEncoding = 'CP949', # 한글 데이터 파일은 인코딩이 맞지 않으면 깨질 수 있음.
                   encoding = 'UTF-8', 
                   check.names = FALSE)

# 2. 데이터 구조와 변수 확인
# int:정수, num:실수, chr:문자
str(weather) # 각 컬럼(벡터)들의 데이터 타입 꼭 확인

# head로 상위 데이터 확인
print(head(weather))  # 기본값 - 상위 6개 행 데이터 확인

print(nrow(weather)) # 수집한 데이터 전체 개수

print(summary(weather)) # 전체 컬럼 요약(사분위수, 평균)

print(table(weather$지점명)) #각 기점명 개수 확인

# 컬럼이 한글... 실무에서는 한글쓰면 않됨
# 컬럼명을 한글에서 영어로 변경

colnames(weather) = c('station_id', 'station_name', 'datetime', 'temp', 'precip', 'windspeed', 'winddir', 'humidity', 'CA')

# 한글은 2바이트, 영어는 1바이트
# 한글 변수명은 일부 함수(기능)에서 오류로 인식, 즉 오류 발생 가능성 증가가
print(head(weather))  #확인


# 일시 : 문자->date로 형 변환
# as.Date(연, 월, 일) -> 시간정보 무시
# as.POSIXct(포직스) -> 날짜와 시간을 모두 형 변환

weather$datetime = as.POSIXct(weather$datetime, format = '%Y-%m-%d %H:%M')

str(weather) # 확인

# 누락된 데이터(결측치 Missing Value) 처리
print(colSums(is.na(weather)))  # 전체 컬럼 NA개수 통계

# 결측값을 0으로 대체하거나 해당 컬럼의 평균으로 대체

# 1. 결측값 0으로 대체
weather$precip[is.na(weather$precip)] = 0
# ifelse
ifelse(is.na(weather$precip), 0, weather$precip)
print(colSums(is.na(weather)))

weather$temp[is.na(weather$temp)] = 0
# ifelse
ifelse(is.na(weather$temp), 0, weather$temp)
print(colSums(is.na(weather)))

weather$windspeed[is.na(weather$windspeed)] = 0
# ifelse
ifelse(is.na(weather$windspeed), 0, weather$windspeed)
print(colSums(is.na(weather)))

weather$winddir[is.na(weather$winddir )] = 0
# ifelse
ifelse(is.na(weather$winddir ), 0, weather$winddir )
print(colSums(is.na(weather)))

weather$humidity[is.na(weather$humidity)] = 0
# ifelse
ifelse(is.na(weather$humidity), 0, weather$humidity)
print(colSums(is.na(weather))) 

weather$CA[is.na(weather$CA)] = 0
# ifelse
ifelse(is.na(weather$CA), 0, weather$CA)
print(colSums(is.na(weather)))

# 누락된 컬럼이 있는지?
# 체감온도는 없네? 만들어보자

weather$feels_like = weather$temp - ((100 - weather$humidity) / 5)

print(head(weather))

# 3. 기토 통계량 확인 및 시각적 탐색(EDA)
# 3-1. 분석할 컬럼 통계량 산출
print(summary(weather$temp))   # 온도 통계량 요약
print(summary(weather$humidity))    # 습도 통계량 요약
print(summary(weather$precip))     # 강수량 통계량 요약
print(summary(weather$windspeed))     # 풍속 통계량 요약

# summary에 표준편차는 없어서
temp_sd = sd(weather$temp, na.rm = TRUE)
humisity_sd = sd(weather$humidity, na.rm = TRUE)
precip_sd = sd(weather$precip, na.rm = TRUE)
windspeed_sd = sd(weather$windspeed, na.rm = TRUE)

print(round(temp_sd, 2))  # 무슨의미인지 알수 없어...

# 변동계수
temp_avg = mean(weather$temp, na.rm = TRUE)
CV = (temp_sd / temp_avg) * 100
cat('온도 변동 계수 : ', CV, '\n')
# 보통 CV가 10~20 이하면 고르게 분포
# 50 이상이면, 데이터가 평균에 비해 상당히 넓게 분포되어 있음

# 상관계수(-1~1 사이로 0에 가까울수록 상관관계 약함) 행렬
# mat(행렬)
# $ : 컬럼 접근, [] : 데이터 접근
cor_mat = cor(weather[, c('temp', 'precip', 'windspeed', 'humidity')], use = 'complete.obs')
print(cor_mat)

# 그래프로 해당 상관관계 표현
# 시각적 탐색(EDA)
# 단일변수 시각화
# 두 변수간의 관계 시각화

library(corrgram)  # 상관관계 그래프

# 시각화
corrgram(cor_mat, main = '온도, 강수량, 풍속, 습도 상관계수',
         lower.panel = panel.shade,
         upper.panel = panel.cor
)

# 기본 plot으로 시각화하기
## ggplot2은 복잡한 시각화에 적합
# 히스토그램(단일변수 시각화)

par(mfrow = c(3, 3))  # 2행, 3열로 그래프 배치, 단 기본 그래프만 가능

hist(weather$temp, main = '온도 데이터 분포', xlab='온도(c)')

hist(weather$humidity, main = '습도 데이터 분포', xlab='습도(c)')

# 박스플롯

boxplot(weather$temp, main = '온도 박스플롯', ylab = '온도')

# 두 변수 간의 관계를 시각적으로 표현
# 1. 시간별 기온 변화
# type = 1 : line
plot(weather$datetime, weather$temp, type='l',
     main = '시간에 따른 온도변화', xlab='time', ylab = 'temperature')

# 2. 기온과 습도 관계
# 산점도로 회귀선까지 추가
# 기온과 습도는 음의 관계
#plot(weather$temp, weather$humidity, main = 'temperature vs humidity')
plot = ggplot(weather,
              aes(x = temp, y = humidity)) +
  geom_point() + # 산점도의 점
  labs(title = 'temperature vs humidity', x = 'temperature', y = 'humidity') +
  geom_smooth(method = 'lm', se = TRUE) + # 회귀선 추가
  theme_minimal() # 깔끔하게 처리 
# print(plot)


plot(weather$temp, weather$humidity, main = 'temperature vs humidity',
     xlab = 'temperature', ylab = 'humidity')
# 회귀선
# lm = linear model
model = lm(weather$humidity ~ weather$temp) # 선형회귀 모델 생성
# abline : add line
abline(model, col='red', lwd = 2)
# -> 습도가 높을수록 기온이 낮아지는 경향이 있습니다.

# 풍속과 기온 관계를 산점도로 표현
plot(weather$windspeed, weather$temp, main = 'windspeed vs temperature',
     xlab = 'windspeed', ylab = 'temperature')
model = lm(weather$windspeed ~ weather$temp)
abline(model, col='red', lwd = 2)

# 4. 데이터 전처리
# 이상치 제거 - 디플리알

library(dplyr)
# 기온 이상치 판단
# 1. z-score(평균, 표준편차) : 키, 몸무게, 성적적 등 정규분포에 많이 사용


# 2. IQR(사분위수) : 근로소득, 강수량, 기온 등 비대칭 데이터에 사용
# IQR 이용해서 이상치 판단
# 데이터를 크기 순서대로 줄 세웠을때 가운데 50%가 얼마나 퍼져있는지를 알려줌

Q1 = quantile(weather$temp, 0.25, na.rm= TRUE)
Q3 = quantile(weather$temp, 0.75, na.rm= TRUE)
IQR = Q3 - Q1

# 1.5 : 통계학자 존 튜키가 제안한 것으로 너무 좁지도 너무 넓지도 않은
# 적절한 범위를 설정하기 위해 표준으로 사용

lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR

# mutate : 컬럼 수정, 추가
weather = weather %>% 
  mutate(temp = ifelse(temp < lower_bound | temp > upper_bound, NA, temp))

# 이상치 데이터 개수 확인, 기온데이터가 NA라는 건 이상치 라는 뜻
# print(sum(is.na(weather$temp))) # 이상치 데이터 = 0
cat('이상치 데이터 개수 : ', sum(is.na(weather$temp)), '\n')

# 5.1.부터 5.31. 동두천천 지점 데이터 필터링

str(weather)

weather_filter = weather %>% 
  filter(station_id=='98' & format(datetime, '%m')=='05')

print(head(weather_filter))

# 시간별 데이터 수집 -> 날짜별 평균을 내어 하루에 하나의 값만 남기는 전처리
# 디플리알 as.Date() : 시간정보 무시
# date라는 컬럼 만들기

weather_daily = weather_filter %>% 
  mutate(date = as.Date(datetime)) %>%
  group_by(date) %>% 
  summarize(mean_temp = mean(temp, na.rm = TRUE))


print(head(weather_daily))

# 5. 실용적 분석
# 시간마다 기록된 숫자 : 시계열 데이터
# 시계열 분석을 숫자들이 어떻게 바뀌는지 어떤 규칙이 있는지를

# 시계열데이터 (time series)
temp_ts = ts(weather_daily$mean_temp, frequency = 30)

print(temp_ts)

# install.packages('forecast')

library(forecast)  # 시계열 데이터를 바탕으로 미래를 예측하는 통계 모델

auto_model = auto.arima(temp_ts)

# 향후 30일 예측
# forecast : 미래 패턴을 예측하고 신뢰구간까지 산출함

forecasted = forecast(auto_model, h=30)

# 예측 결과 데이터프레임 생성
predict_data = data.frame(
  time = as.numeric(time(forecasted$mean)),
  forecast = as.numeric(forecasted$mean),
  lower = as.numeric(forecasted$lower[,2]),  # 95% 신뢰구간 하한
  upper = as.numeric(forecasted$upper[,2])   # 95% 신뢰구간 상한한
)

# 실제값
actual_data = data.frame(
  time = as.numeric(time(temp_ts)),
  temp = as.numeric(temp_ts)
)

library(ggplot2)  # 고급시화화

line_plot = ggplot() +
  # 실제값 선그래프
  geom_line(data = actual_data, aes(x = time, y = temp), color = "steelblue", size = 1) +
  # 예측 신뢰구간 리본
  geom_ribbon(data = predict_data, aes(x = time, ymin = lower, ymax = upper), fill = "orange", alpha = 0.3) +
  # 예측값 선그래프
  geom_line(data = predict_data, aes(x = time, y = forecast), color = "red", size = 1.2, linetype = "dashed") +
  labs(
    title = "Temperature Forecast",
    x = "Time",
    y = "Temperature"
  ) +
  theme_minimal()

print(line_plot)



