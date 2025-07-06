data = read.csv('서울특별시_공공자전거_이용정보.csv',
                na.strings = c(""), # ""를 NA로 표현한다.
                fileEncoding = 'CP949', 
                encoding = 'UTF-8', 
                check.names = FALSE)
# View(data)
str(data)

library(dplyr)

# 문제 1: 이동거리(M)가 2000 이상인 데이터 중 해당 대여소명과 이동거리(M), 이용시간(분)만 조회.
result = data %>% filter(`이동거리(M)`>=2000) %>% select(대여소명, `이동거리(M)`, `이용시간(분)`)
#View(result)

# 문제 2: 대여소 별 이용건 수 조회.
result = data %>% group_by(대여소명) %>% summarise(이용건 = sum(이용건수, na.rm=TRUE))
print(result)

# # 문제 3: 일일회원과 정기회원 이용 건 수, 평균 이용시간 조회. 단, 일일회원권 중 비회원은 제외
# 회원타입 = data %>% group_by(대여구분코드) %>% summarise(mean(`이용시간(분)`, na.rm=TRUE))
# print(회원타입)

result = data %>% filter(대여구분코드 != '일일권(비회원)') %>% group_by(대여구분코드) %>% summarise(총이용건수 = sum(이용건수, na.rm = TRUE), 평균이용시간= mean(`이용시간(분)`, na.rm=TRUE))
print(result)

# 문제 4: 탄소량이 0.8 이상인 이용 건수는 몇 건인지 조회.
result = data %>% filter(탄소량>=0.8) %>% summarise(`0.8이상이용건수` = n(), na.rm=TRUE)
print(result)

# 문제 5: 연령대별로 평균 이동거리(M) 조회.
result = data %>% group_by(연령대코드) %>% summarise(평균이동거리 = mean(`이동거리(M)`, na.rm=TRUE))
print(result)


# 문제 6: 연령대별로 이용건수의 합과 평균 운동량을 구한 뒤, 운동량 평균이 가장 높은 연령대 조회.
result = data %>% 
  group_by(연령대코드) %>% 
  summarise(이용건수합 = sum(이용건수, na.rm=TRUE), 평균운동량 = mean(운동량, na.rm=TRUE)) %>%  
  arrange(desc(평균운동량)) %>% 
  slice(1:1)  # slice(1)과 같음음
print(result)


# 문제 7: 대여소명에 "역"이 포함된 대여소에서 발생한 총 운동량의 합 조회.
# 
# text = c('apple', 'banana', 'grape', 'bread')
# # ap가 들어간 단어 찾기
# # grep(잡다) logical(TURE, FALSE)
# print(grepl('ap', text))

result = data %>% filter(grepl('역', 대여소명)) %>% summarise(sum(운동량, na.rm=TRUE))
print(result)

#install.packages("stringr")
library(stringr)
result = data %>% filter(str_detect(대여소명, "역")) %>% summarise(sum(운동량, na.rm=TRUE))
print(result)

# 문제 8: 10대 여성 회원의 평균 운동량, 평균 이동거리 조회. 단, 평균 운동량으로 내림차순 할 것
result = data %>% filter(연령대코드 == "10대" & (성별 =='F' | 성별 =='f')) %>% summarise(평균운동량 = mean(운동량, na.rm=TRUE), 평균이동량 = mean(`이동거리(M)`, na.rm=TRUE)) %>% arrange(desc(평균운동량))
print(result)

# 문제 9: 운동량을 데이터 스케일링 min-max로 변환한 scaled_운동량 컬럼을 추가 0.8 이하인 회원 이동거리 사분위수 출력
# min-max는 데이터의 범위를 0과 1사이로 변환하는 데이터 전처리 기법법

# 데이터 스케일링 공식 = (기존값 - 최솟값) / (최댓값 - 최솟값)
운동량_min = min(data$운동량)
운동량_max = max(data$운동량)

data = data %>% mutate(scaled_운동량 = (운동량 - 운동량_min) / 
           (운동량_max - 운동량_min))
#View(data)
#str(data)
#방법1
result = data %>% filter(scaled_운동량 <= 0.8) %>% summarise(quantile(`이동거리(M)`, probs = c(0.25, 0.5, 0.75), na.rm=TRUE))
print(result)
#방법2
result = data %>% filter(scaled_운동량 <= 0.8)
print(quantile(data$`이동거리(M)`))


# 문제 10. 연령대 별 운동량과 이동거리의 상관관계 조회.
# cor = correlation
result = data %>% group_by(연령대코드) %>% 
  summarise(상관계수 = cor(운동량, `이동거리(M)`, use='complete.obs'))
print(result)


# 데이터전처리 ~ 시각화까지 진행해주세요. 최종 그래프 결과는 PDF로 저장하시오.
# 문제 1: 성별 운동량 박스플롯 표현. 단, 이용시간(분) 3분 이하는 제외

result = data %>% filter(`이용시간(분)` > 3)
pdf('성별 운동량_박스플롯.pdf', family = 'Korea1deb')

boxplot(result$`운동량` ~ result$'성별', main = '성별 운동량', xlab = '성별', ylab = '운동량', col = c('orange', 'green', 'blue'))

dev.off() # pdf 다운로드 종료

 
# 문제 2: 연령대별 평균 이동거리(M)를 막대그래프로 표현.
result = data %>% group_by(연령대코드) %>% summarise(평균이동거리 = mean(`이동거리(M)`))
#names.arg : X축 데이터 표시, 
barplot(result$평균이동거리, names.arg = result$연령대코드, main ='연령대별 평균 이동거리', ylab = '이동거리리')


# 문제 3: 이동거리를 데이터 스케일링 min-max로 변환한 scaled_이동거리 컬럼을 추가하고, 값이 0.5 이상인 이용자를 연령대별 평균 운동량과 평균 이용시간을 막대그래프로 표현.
# 스케일링 = 기존값 - 최솟값/ 최댓값 - 최솟값

이동거리_min = min(data$`이동거리(M)`)
이동거리_max = max(data$`이동거리(M)`)

# 스케일링 결과 컬럼 추가
data$이동거리_scaled = (data$`이동거리(M)` - 이동거리_min) / (이동거리_max - 이동거리_min)

# View(data)
str(data)
result = data %>% filter(data$이동거리_scaled >= 0.5) %>% group_by(연령대코드) %>% summarise(평균운동량 = mean(`운동량`, na.rm = TRUE), 평균이용시간=mean(`이용시간(분)`, na.rm = TRUE))

#names.arg : X축 데이터 표시, 
barplot(result$평균운동량~result$평균이용시간, names.arg = result$연령대코드, main ='연령대별 평균 운동량', ylab = '이동거리')


# 문제 4: 정기권을 구매한 이용자 중 연령대 별 평균 운동량 파이차트로 표현. 단, 이용시간(분) 5분 이하는 평균에서 제외
# 
# 문제 5: 정기권 회원 중 연령대가 10대에서 50대 사이의 이용시간과 운동량을 비교하는 산점도그래프 표현하시오.(이용시간 x축, 운동량 y축) 회귀선까지 추가하시오.

