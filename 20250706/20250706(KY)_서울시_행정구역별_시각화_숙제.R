#교육_지출_총금액

library(sf)
library(ggplot2)
library(ggiraph)

# 1. 지도파일 불러오기
shp = 'sig.shp'
korea_map = st_read(shp, quiet = TRUE)

str(korea_map)
print(colnames(korea_map))

library(dplyr)
seoul_map = korea_map %>% filter(substr(SIG_CD,1,2) == '11')
str(seoul_map)

#csv
서울시_상권분석_데이터 = read.csv('서울시_상권분석서비스.csv', na.strings = c(""), fileEncoding = 'CP949', encoding = 'UTF-8', check.names = FALSE)

# shp파일에 있는 행정동 코드와 서울시 행정동 코드 데이터타입이 서로 다르다.
서울시_상권분석_데이터$행정동_코드 = as.character(서울시_상권분석_데이터$행정동_코드) #타입 변환

str(서울시_상권분석_데이터) #타입확인
print(head(서울시_상권분석_데이터))

# 각 컬럼별 결측값 조회
print(colSums(is.na(서울시_상권분석_데이터)))
options(scipen=999) # 10진수 표현
print(summary(서울시_상권분석_데이터$음식_지출_총금액))

#서울시 각 행정구 월 평균 소득 금액을 지도로 시각화
# 1. shp 파일과 서울시 CSV파일을 병합.
# 2. 교집합 컬럼이 필요함.

# inner_join : 두 파일을 병합
# 22년~25년까지 데이터가 존재해서 group_by로 
merged_data = inner_join(seoul_map, 서울시_상권분석_데이터, 
                         by = c('SIG_CD' = '행정동_코드')) %>%
  group_by(SIG_CD, 행정동_코드_명) %>%
  summarise(교육지출총액 = mean(교육_지출_총금액, na.rm = TRUE)) %>%
  select(SIG_CD, 행정동_코드_명, 교육지출총액, geometry) %>%
  arrange(desc(교육지출총액)) %>%
  head(5)

# View(merged_data)

# 지도 시각화
result = ggplot(merged_data) + 
  scale_fill_gradient(low='#ececec', high ='blue', name='교육지출금액') +
  labs(x='경도', y='위도', title= '서울시 22~25년 교육지출금액') +
  # geom_sf(aes(fill = 교육지출총액), color = 'black') + 
  geom_sf_interactive(aes(fill=교육지출총액, tooltip=행정동_코드_명, data_id=SIG_CD)) +
  theme_minimal() # 회색배경 제거

giraph = girafe(ggobj= result)  # 지도 이벤트 추가(마우스 호버) =>geom_sf_interactive 있어야 함 

print(giraph)





