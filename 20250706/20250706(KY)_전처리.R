library(dplyr)

서울시_상권분석_데이터 = read.csv('서울시_상권분석서비스.csv', na.strings = c(""), fileEncoding = 'CP949', encoding = 'UTF-8', check.names = FALSE)

서울시_상권분석_데이터$행정동_코드 = as.character(서울시_상권분석_데이터$행정동_코드) #타입 변환


# 24년도 서울시 행정동 코드명별 평균 월 소득 금액과 평균 지출총금액, 평균 교육지출금액 조회

head(서울시_상권분석_데이터)

result_data = inner_join(seoul_map, 서울시_상권분석_데이터, 
                         by = c('SIG_CD' = '행정동_코드')) %>%
  filter(substr(기준_년분기_코드, 1, 4) =='2024') %>%
  group_by(SIG_CD, 행정동_코드_명) %>%
  summarise(평균월소득 = mean(월_평균_소득_금액, na.rm = TRUE), 
            평균지출총금액 = mean(지출_총금액, na.rm=TRUE),
            평균교육지출 = mean(교육_지출_총금액, na.rm=TRUE)) %>%
  select(SIG_CD, 행정동_코드_명, 평균월소득, 평균지출총금액, 평균교육지출, geometry)

print(result_data)

# 서울시 25년도 행정동 코드별 월평균소득금액 히스토르갬으로 시각화화
result_data2 = inner_join(seoul_map, 서울시_상권분석_데이터, 
                         by = c('SIG_CD' = '행정동_코드')) %>%
  filter(substr(기준_년분기_코드, 1, 4) =='2025') %>%
  group_by(SIG_CD, 행정동_코드_명) %>%
  summarise(평균월소득 = mean(월_평균_소득_금액, na.rm = TRUE)) %>%
  select(SIG_CD, 행정동_코드_명, 평균월소득, geometry)

par(mfrow = c(1, 2))  # 1행 2열 표현 단, 기본그래픽만

hist(result_data2$평균월소득, col='skyblue', main='25년 행정동별 평균 소득',
     xlab ='평균소득', ylab = '수')

barplot(result_data2$평균월소득, names.arg=result_data2$행정동_코드_명,
        col='orange', xlab ='행정동명', ylab='소득금액', main='25년 행정동별 평균소득')

# 24년도 4분기 지출 총금액 조회

result_data3 = 서울시_상권분석_데이터 %>%
  filter(기준_년분기_코드=='20244') %>%
  group_by(행정동_코드_명) %>%
  summarise(평균지출총금액 = mean(지출_총금액, na.rm=TRUE)) %>%
  select(행정동_코드_명, 평균지출총금액)
  
print(result_data3)

par(mfrow = c(1, 1)) 

total_sending = result_data3$평균지출총금액 / 1e8 # 억원 단위로 변환환

barplot(total_sending, 
        names.arg=result_data3$행정동_코드_명,
        col='orange', xlab ='행정동명', ylab='지출금액(억원)', main='24년 4분기 행정동별 평균지출')

# 24년도 교통지출과 문화지출 간의 상관계수 조회
#

result_data5 = 서울시_상권분석_데이터 %>%
  filter(substr(기준_년분기_코드, 1, 4) =='2024')

cor_mat = cor(result_data5[, c('교통_지출_총금액', '여가_문화_지출_총금액')])
# 0.3~0.7 중간, 0.7 이상은 강한 관계
print(cor_mat)

# 행정동별 식료품 지출 총 금액 박스플롯
boxplot(식료품_지출_총금액~행정동_코드_명, data = result_data5,
        main ='행정동별 식료품 지출 분포',
        xlab = '행정동',
        ylab = '식료품 지출 총금액',
        col = 'lightgreen')

# 행정동별 유흥_지출_총금액
boxplot(유흥_지출_총금액~행정동_코드_명, data = result_data5,
        main ='행정동별 유흥 지출 분포',
        xlab = '행정동',
        ylab = '유흥 지출 총금액',
        col = 'lightyellow')


# 교통지출 많은곳, 문화지출 많은곳 지도 시각화
library(sf)
library(ggplot2)
library(ggiraph)

shp = 'sig.shp'
korea_map = st_read(shp, quiet = TRUE)

library(dplyr)
seoul_map = korea_map %>% filter(substr(SIG_CD,1,2) == '11')
str(seoul_map)

서울시_상권분석_데이터$행정동_코드 = as.character(서울시_상권분석_데이터$행정동_코드) #타입 변환

print(colSums(is.na(서울시_상권분석_데이터)))

result_data6 = 서울시_상권분석_데이터 %>%
  filter(substr(기준_년분기_코드, 1, 4) =='2024')


merged_data = inner_join(seoul_map, result_data6, 
                         by = c('SIG_CD' = '행정동_코드')) %>%
  group_by(SIG_CD, 행정동_코드_명) %>%
  summarise(평균교통지출 = mean(교통_지출_총금액, na.rm = TRUE)) %>%
  select(SIG_CD, 행정동_코드_명, 평균교통지출, geometry) %>%
  arrange(desc(평균교통지출)) %>%
  head(5)

plot1 = ggplot(merged_data) +
  scale_fill_gradient(low='#ececec', high ='blue', name='교통지출금액') +
  labs(x='경도', y='위도', title= '서울시 24년 교통지출금액') +
  geom_sf_interactive(aes(fill=평균교통지출, tooltip=행정동_코드_명, data_id=SIG_CD)) +
  theme_minimal()  # 회색배경 제거 
  
giraph = girafe(ggobj= plot1)  # 지도 이벤트 추가(마우스 호버) =>geom_sf_interactive 있어야 함 

print(giraph)



# 2024년 문화지출 많은곳 지도 시각화

merged_data = inner_join(seoul_map, result_data6, 
                         by = c('SIG_CD' = '행정동_코드')) %>%
  group_by(SIG_CD, 행정동_코드_명) %>%
  summarise(평균문화지출 = mean(여가_문화_지출_총금액, na.rm = TRUE)) %>%
  select(SIG_CD, 행정동_코드_명, 평균문화지출, geometry) %>%
  arrange(desc(평균문화지출)) %>%
  head(5)

plot1 = ggplot(merged_data) +
  scale_fill_gradient(low='#ececec', high ='red', name='교통문화금액') +
  labs(x='경도', y='위도', title= '서울시 24년 교통문화금액') +
  geom_sf_interactive(aes(fill=평균문화지출, tooltip=행정동_코드_명, data_id=SIG_CD)) +
  theme_minimal()  # 회색배경 제거 

giraph = girafe(ggobj= plot1)  # 지도 이벤트 추가(마우스 호버) =>geom_sf_interactive 있어야 함 

print(giraph)


