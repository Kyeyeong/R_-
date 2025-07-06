data = read.csv('국민건강보험공단_건강검진정보.csv',
                na.strings = c(""), # ""를 NA로 표현한다.
                fileEncoding = 'CP949', 
                encoding = 'UTF-8', 
                check.names = FALSE)
View(data)


library(dplyr)


# 문제 1. : 남성의 허리둘레 사분위수 조회.
# 유형 = data %>% group_by(성별) %>% summarise(r=n())
# print(유형)
result = data %>% filter(성별 == 1)
print(quantile(data$허리둘레))


# 문제 2. : 성별 허리둘레와 체중 상관관계 조회.
result = data %>% group_by(성별) %>% summarise(상관계수= cor(허리둘레, `체중(5kg단위)`, use = 'complete.obs'))
print(result)


# 문제 3. : 혈색소 수치는 남성은 13~17, 여성은 12~16이 정상입니다. 정상과 의심을 구별할 수 있는 컬럼 혈색소결과를 만드시오.
data = data %>% 
  mutate(혈색소정상여부 = ifelse((성별==1 & 혈색소>=13 & 혈색소 <=17) | (성별==2 & 혈색소>=12 & 혈색소 <=16) , '정상', '의심'))
print(data)

# 문제 4. : 식전혈당이 126이상은 위험, 100미만은 정상 그외는 주의를 나타내는 컬럼 당뇨병위험을 추가하시오.
data = data %>% mutate(당뇨병위험 = ifelse(`식전혈당(공복혈당)`>=126, '위험', ifelse(`식전혈당(공복혈당)`<=100, '정상', '주의')))
print(data)
                         
# 추가 후 당뇨병위험 별 인원 수 조회.
data = data %>% group_by(당뇨병위험) %>% summarise(인원수 = n())
print(data)

# 문제 5. : 연령대 코드가 5~8인 사람 중 혈색소의 중앙값, 하위 30%, 상위 10%, 표준편차 조회.

result = data %>% 
  filter(`연령대코드(5세단위)`>=5 & `연령대코드(5세단위)`<=8) %>%
  summarise(중앙값 = median(혈색소, , na.rm = TRUE), 
            하위30 = quantile(혈색소, 0.3, na.rm = TRUE), 
            상위10 = quantile(혈색소, 0.9, na.rm = TRUE), 
            표준편차 = sd(혈색소, na.rm = TRUE))
print(result)


# 문제 6. : 음주와 흡연을하는 남성의 혈색소 이상치를 제거한 데이터 수 조회. 임계치는 2로 필터링

result = data %>% 
  filter(음주여부==1 & 흡연상태==1)
  
  # 1. 이상치 제거
  # 우선, 평균과 표준편차를 구해야 함
mu = mean(result$혈색소, na.rm = TRUE)
sigma = sd(result$혈색소, na.rm = TRUE)

print(mu)
print(sigma)

result = result %>%
  mutate(z_score = abs((result$혈색소 - mu) / sigma))  # 공식
print(data)

이상치제거_데이터 = result %>% filter(z_score < 2)  # 2는 비교적 넒은 범위의 이상치를 탐지할때
print(이상치제거_데이터)




# 문제 7. : 연령대 코드별로 허리둘레의 분포를 박스플롯으로 나타내세요.
boxplot(data$연령대~data$허리둘레,
        main = "연령대별 허리둘레 분포",
        xlab = "연령대 코드",
        ylab = "허리둘레 (cm)",
        col = "lightblue")


# 문제 8. : 연령대 코드가 5~8인 사람의 신장과 체중의 관계를 산점도로 나타내시오. 회귀선도 추가하시오.
# 1. 연령대코드 5~8 필터
result = data %>%
  filter(`연령대코드(5세단위)` >= 5 & `연령대코드(5세단위)` <= 8)

# 2. 산점도 그리기
plot(result$신장, result$체중,
     main = "연령대별 신장과 체중의 관계",
     xlab = "신장 (cm)",
     ylab = "체중 (kg)",
     pch = 19,          # 점 모양: ●
     col = "blue")      # 점 색깔: 파란색

# 3. 회귀선 추가
model = lm(체중 ~ 신장, data = result)
abline(model, col = "red", lwd = 2)   # 회귀선: 빨간색, 두께 2





# 문제 9. : 감마지티피의 분포를 정규분포그래프으로 나타내세요. 중앙값, 하위 20%, 상위 20%, 신뢰구간도 표현해주세요.
# 1. 평균과 표준편차 지정
mu = mean(data$감마지티피)
sigma = sd(data$감마지티피)

# 2. 중앙값, 하위 20%, 상위 80%, 95% 신뢰구간 계산
med = median(data$감마지티피)
low_20 = quantile(data$감마지티피, 0.2)
high_80 = quantile(data$감마지티피, 0.8)

ci_lower = mu - 1.96 * sigma
ci_upper = mu + 1.96 * sigma

x <- seq(min(data$감마지티피), max(data$감마지티피), length = 200)
y <- dnorm(x, mean = mu, sd = sigma)

# 정규분포 곡선 그리기
plot(x, y, type = "l", lwd = 2, col = "blue",
     main = "표준 정규분포 곡선",
     xlab = "X", ylab = "Density")

str(data)

# 문제 10. : 혈청지오티와 혈청지피티의 관계를 산점도로 나타내시오. 단, 혈청지오티와 혈청지피티를 min-max로 스케일링 후 비교하시오. 회귀선도 추가하시오.


지오티_min = min(data$`혈청지오티(AST)`)
지오티_max = max(data$`혈청지오티(AST)`)

지피티_min = min(data$`혈청지피티(ALT)`)
지피티_max = max(data$`혈청지피티(ALT)`)


# 스케일링 결과 컬럼 추가
data$지오티_scaled = (data$`혈청지오티(AST)` - 지오티_min) / (지오티_max - 지오티_min)
data$지피티_scaled = (data$`혈청지피티(ALT)` - 지피티_min) / (지피티_max - 지피티_min)

# 산점도 그리기
plot(data$지오티_scaled, data$지피티_scaled,
     main = "혈청지오티와 혈청지피티 (Min-Max 스케일링 후)",
     xlab = "혈청지오티 (Scaled)",
     ylab = "혈청지피티 (Scaled)",
     pch = 19,
     col = "blue")

# 회귀선 추가
model = lm(지피티_scaled ~ 지오티_scaled, data = data)
abline(model, col = "red", lwd = 2)


