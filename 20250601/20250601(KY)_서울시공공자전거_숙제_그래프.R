data = read.csv('서울특별시_공공자전거_이용정보.csv',
                na.strings = c(""), # ""를 NA로 표현한다.
                fileEncoding = 'CP949', 
                encoding = 'UTF-8', 
                check.names = FALSE)
# View(data)
str(data)

library(dplyr)


# 데이터전처리 ~ 시각화까지 진행해주세요. 최종 그래프 결과는 PDF로 저장하시오.
# 문제 1: 성별 운동량 박스플롯 표현. 단, 이용시간(분) 3분 이하는 제외
# 데이터확인 = data %>% group_by(성별) %>% summarise(c = n())
# print(데이터확인)

result = data %>% filter(`이용시간(분)` > 3 & !is.na(성별))
pdf('성별 운동량_박스플롯.pdf', family = 'Korea1deb')

# 방법1
#boxplot(result$`운동량` ~ result$'성별', main = '성별 운동량', xlab = '성별', ylab = '운동량', col = c('orange', 'green', 'blue'))

# 방법2
boxplot(운동량 ~ 성별, 
        data=result, 
        main = '성별 운동량', 
        xlab = '성별', 
        ylab = '운동량', 
        col = c('orange', 'green', 'blue'))

dev.off() # pdf 다운로드 종료


# 문제 2: 연령대별 평균 이동거리(M)를 막대그래프로 표현.
result = data %>% group_by(연령대코드) %>% summarise(평균이동거리 = mean(`이동거리(M)`, na.rm=TRUE))
#names.arg : X축 데이터 표시, 
barplot(result$평균이동거리, names.arg = result$연령대코드, main ='연령대별 평균 이동거리', ylab = '이동거리')


# 문제 3: 이동거리를 데이터 스케일링 min-max로 변환한 scaled_이동거리 컬럼을 추가하고, 값이 0.5 이상인 이용자를 연령대별 평균 운동량과 평균 이용시간을 막대그래프로 표현.
# 스케일링 = 기존값 - 최솟값/ 최댓값 - 최솟값

이동거리_min = min(data$`이동거리(M)`)
이동거리_max = max(data$`이동거리(M)`)

# 스케일링 결과 컬럼 추가
data$이동거리_scaled = (data$`이동거리(M)` - 이동거리_min) / (이동거리_max - 이동거리_min)

# View(data)
#str(data)
result = data %>% filter(data$이동거리_scaled >= 0.5) %>% group_by(연령대코드) %>% summarise(평균운동량 = mean(`운동량`, na.rm = TRUE), 평균이용시간=mean(`이용시간(분)`, na.rm = TRUE))

#names.arg : X축 데이터 표시, 
barplot(result$평균운동량~result$평균이용시간, names.arg = result$연령대코드, main ='연령대별 평균 운동량', ylab = '이동거리')


# 문제 4: 정기권을 구매한 이용자 중 연령대 별 평균 운동량 파이차트로 표현. 단, 이용시간(분) 5분 이하는 평균에서 제외

result = data %>% filter(대여구분코드=="정기권" & `이용시간(분)`>=5) %>%
  group_by(연령대코드) %>%
  summarise(평균운동량 = mean(운동량, na.rm=TRUE))
pie(result$평균운동량, labels = result$연령대코드, main = "연령대멸 평균 운동량", col=rainbow(7))
# 도넛 효과
symbols(0, 0, circles = 0.3, inches = FALSE, add = TRUE, bg= 'white')

# 문제 5: 정기권 회원 중 연령대가 10대에서 50대 사이의 이용시간과 운동량을 비교하는 산점도그래프 표현하시오.(이용시간 x축, 운동량 y축) 회귀선까지 추가하시오.
#str(data)
result = data %>% 
  filter(대여구분코드=='정기권' & 연령대코드 %in% c('10대', '20대', '30대', '40대', '50대') )

plot(result$`이용시간(분)`, result$운동량, main = "이용시간과 운동량 관계계", xlab = "이용시간", ylab = "운동량량")
#회귀선 추가
model = lm(result$운동량~result$`이용시간(분)`)
abline(model, col='red', lwd=2)
