library(dplyr)
서울시_상권분석_데이터 = read.csv('서울시_상권분석서비스.csv', na.strings = c(""), fileEncoding = 'CP949', encoding = 'UTF-8', check.names = FALSE)

서울시_상권분석_데이터$행정동_코드 = as.character(서울시_상권분석_데이터$행정동_코드) #타입 변환


# 1. 데이터 타입 조회
str(서울시_상권분석_데이터)
head(서울시_상권분석_데이터)
print(summary(서울시_상권분석_데이터))

# 2. 컬럼 이름만 조회
colnames(서울시_상권분석_데이터)

# 3. 컬럼별 결측값 수 조회
print(colSums(is.na(서울시_상권분석_데이터)))

# 4. 상위 10개 데이터 조회
head(서울시_상권분석_데이터, 10)

#5. 교육_지출_총금액 가장 큰 자치구

교육지출최대 = max(서울시_상권분석_데이터$교육_지출_총금액, na.rm=TRUE)
print(교육지출최대)

result = 서울시_상권분석_데이터 %>%
  group_by(행정동_코드_명) %>%
  summarise(교육지출총액 = mean(교육_지출_총금액, na.rm = TRUE)) %>%
  select(행정동_코드_명, 교육지출총액) %>%
  arrange(desc(교육지출총액)) %>%
  head(1)

print(result)

# 6. 25년 데이터 전체 조회
result2 = 서울시_상권분석_데이터 %>%
  filter(substr(기준_년분기_코드, 1, 4)=='2025')

print(result2)

# 7. 25년 데이터 지출 총금액 대비 음식 지출 비율(음식지출/지출총금액)*100
result3 = 서울시_상권분석_데이터 %>%
  filter(substr(기준_년분기_코드, 1, 4)=='2025') %>%
  summarise(총지출=mean(지출_총금액, na.rm=TRUE),
          음식지출=mean(음식_지출_총금액, na.rm=TRUE))

print((result3$총지출/result3$음식지출)*100)

result2 = result2 %>% mutate(비율 = (음식_지출_총금액/지출_총금액)*100)
print(head(result2))


# 8. 25년 데이터 중 생활, 의류, 교통, 유흥 상관계수

cor_mat = cor(result2[, c('생활용품_지출_총금액', '의류_신발_지출_총금액', '교통_지출_총금액', '유흥_지출_총금액')])
# 0.3~0.7 중간, 0.7 이상은 강한 관계
print(cor_mat)

# 9. 24년 구로구 제
result4 = 서울시_상권분석_데이터 %>%
  filter(substr(기준_년분기_코드, 1, 4)=='2024' & 행정동_코드_명=='구로구')

print(result4)