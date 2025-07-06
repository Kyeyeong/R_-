weather = read.csv('대전부산등날씨.csv', 
                   na.strings = c(""), 
                   fileEncoding = 'CP949', 
                   encoding = 'UTF-8', 
                   check.names = FALSE)

c
str(weather)

colnames(weather) =  c("station_id", "station_name", "datetime", "temp", "precip", "windspeed", "winddir", "humidity","CA")
str(weather)

# 문자로 입력된 날짜를 문자형으로 변환합니다.
weather$datetime = as.POSIXct(weather$datetime, format="%Y-%m-%d %H:%M")
str(weather)

### 풍속 IQR 이상치 제거
Q1 = quantile(weather$windspeed, 0.25)
Q3 = quantile(weather$windspeed, 0.75)
IQR_VALUE = Q3 - Q1

lower_bound = Q1- 1.5 *IQR_VALUE
upper_bound = Q3+ 1.5 *IQR_VALUE

library(dplyr)
outliers = weather %>% filter(windspeed < lower_bound | windspeed >upper_bound) %>% nrow()
cat('풍속 이상치 개수 : ', outliers, '\n')


### 각 지점별로 평균 기온을 구하시오. (dplyr)

location_temp = weather %>%
  group_by(station_name) %>%
  summarise(mean_temp = mean(temp, na.rm = TRUE))

print(location_temp)


### 풍속이 3 m/s 이상인 데이터만 골라서, 해당 데이터의 평균 습도를 구하시오. (dplyr)

windspeed_3 = weather %>%
  filter(windspeed>=3) %>%
  summarise(mean_humidity = mean(humidity, na.rm = TRUE))

print(windspeed_3)


### 3월부터 5월까지 서울의 평균 강수량, 최대 강수량, 최소 강수량 구하시오. (dplyr)

perci_3_to_5 = weather %>%
  filter(station_name=="서울" & 
           datetime >= as.POSIXct("2025-03-01") &
           datetime <  as.POSIXct("2025-06-01")) %>%
  summarise(mean_precip = mean(precip, na.rm = TRUE),
            max_precip = max(precip, na.rm = TRUE),
            min_precip = min(precip, na.rm = TRUE))

print(perci_3_to_5)

seoul_data2 = weather %>% mutate(month = format(datetime, '%m')) %>%
  filter(month %in% c('03', '04', '05') & station_name == '서울') %>%
  summarise(mean_precip = mean(precip, na.rm = TRUE),
            max_precip = max(precip, na.rm = TRUE),
            min_precip = min(precip, na.rm = TRUE))



### 각 지점별로 기온이 가장 높았던 시간대와 그 값을 구하시오. (dplyr) 단, 값을 기준으로 내림차순 할 것

high_temp = weather %>%
  group_by(station_name) %>%
  filter(temp == max(temp, na.rm = TRUE)) %>%   # 그룹 내 최고값 필터링
  select(station_id, station_name, datetime, temp) %>%
  arrange(desc(temp))                           # 기온 기준 내림차순 정렬

print(high_temp)

high_temp2 = weather %>%
  group_by(station_name) %>%
  select(station_id, station_name, datetime, temp) %>%
  slice_max(temp, n=1) %>%
  arrange(desc(temp))
  
print(high_temp2)

### 날짜별 습도 평균 구하기 (dplyr)
# hint: mutate()와 group_by(), summarise()


daily_humidity = weather %>%
  mutate(date = as.Date(datetime)) %>%        # datetime에서 날짜만 추출
  group_by(date) %>%                          # 날짜별 그룹화
  summarise(mean_humidity = mean(humidity, na.rm = TRUE))  # 평균 계산

print(daily_humidity)

### 일별 평균 습도데이터를 한달 주기의 시계열 데이터로 반환
# hint: ts, frequency = 30
# ts() 칸에 알맞는 코드 입력하시오.
humidity_ts = ts(daily_humidity$mean_humidity, frequency = 30)

print(humidity_ts)



### 향후 10일 습도 예측
library(forecast)
auto_model = auto.arima(humidity_ts)
#  h = 에 올바른 값 넣기
forecasted = forecast(auto_model, h = 10)
print(forecasted)

### 예측 결과,실제 결과를 데이터프레임으로 생성

predict_data = data.frame(
  time = as.numeric(time(forecasted$mean)),
  forecast = as.numeric(forecasted$mean),
  lower = as.numeric(forecasted$lower[,2]),  # 95% 신뢰구간 하한
  upper = as.numeric(forecasted$upper[,2])   # 95% 신뢰구간 상한
)
actual_data = data.frame(
  time = as.numeric(time(humidity_ts)),
  temp = as.numeric(humidity_ts)
)



library(ggplot2) #고급 시각화

line_plot = ggplot() +
  # 실제값 선그래프
  geom_line(data = actual_data, aes(x = time, y = temp), color = "steelblue", size = 1) +
  # 예측 신뢰구간 리본
  geom_ribbon(data = predict_data, aes(x = time, ymin = lower, ymax = upper), fill = "orange", alpha = 0.3) +
  # 예측값 선그래프
  geom_line(data = predict_data, aes(x = time, y = forecast), color = "red", size = 1.2, linetype = "dashed") +
  labs(
    title = "습도 예측",
    x = "Time",
    y = "습도"
  ) +
  theme_minimal()

print(line_plot)