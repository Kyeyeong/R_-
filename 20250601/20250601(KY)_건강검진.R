# 컬럼이 한글일때는 아래와 같이 설정정

health = read.csv('국민건강보험공단_건강검진정보.csv', 
                  fileEncoding = 'CP949', 
                  encoding = 'UTF-8', 
                  check.names = FALSE)
# View(health)

# 혈색소 데이터를 min, max 스케일링링

hemoglobin_min = min(health$혈색소)
hemoglobin_max = max(health$혈색소)

health$hemoglobin_scaled = (health$혈색소 - hemoglobin_min) / (hemoglobin_max - hemoglobin_min)

# View(health)

library(dplyr)
# why 0.8? : 0.8을 기준으로 이상치치 
result = health %>% filter(hemoglobin_scaled > 0.8) %>% nrow()
print(result)

# 데이터 구조 확인
str(health)
# 상위 5행까지 확인
print(head(health, 5))

# 컬럼명에 ()가 있는 경우 1 옆에 물결 표시
result = health %>% select(`혈청지오티(AST)`)
print(result)



