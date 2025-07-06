scereal = read.csv('UScereal.csv')
# View(scereal)

str(scereal)
# 상관관계 시각화
# cor, correlation의 약자로 상관계수라는 뜻
# 설탕과 칼로리의 상관관계
상관관계 = cor(scereal$sugars, scereal$calories, use='complete.obs')  # 결측값 제거
cat('설탕과 칼로리의 상관관계 : ', round(상관관계, 2), '\n')    # cat=character print와 비슷, 한줄로
# 0.5 = 보통 상관관계
# -1 ~ 1 : -1 음의 관계, 0 관계 없음, 1 양의 관계
# 상관계수 해석 : 0.3이하 = 약한 관계, 0.3~0.7 = 중간, 0.7 = 강한 관계

# install.packages('corrgram')

library(corrgram)   # 설치한 프로그램 불러오기
library(dplyr)

테스트 = scereal %>% select(calories, protein, fat)
print(head(테스트))

corrgram(테스트, 
         main = '칼로리, 단백질, 지방 상관관계 행렬',
         lower.panel = panel.shade, # 아래쪽 색상으로 상관관계 표현
         upper.panel = panel.cor,   # 위쪽 상관관계 수치 표현
         diag.panel = panel.minmax   # 대각선은 최솟, 최댓값 표현
)

# 

평균데이터 = scereal %>% 
  group_by(mfr) %>% 
  summarise(평균칼로리 = mean(`calories`, na.rm = TRUE), 
            평균단백질 = mean(`protein`, na.rm = TRUE),
            평균식이섬유 = mean(`fibre`, na.rm = TRUE))
print(평균데이터)
corrgram(평균데이터, 
         main = '제조사별 칼로리, 단백질, 식이섬유 상관관계 행렬',
         lower.panel = panel.shade, # 아래쪽 색상으로 상관관계 표현
         upper.panel = panel.cor,   # 위쪽 상관관계 수치 표현
         #upper.panel = panel.pie,   # 위쪽 상관관계 수치 표현
         diag.panel = panel.minmax   # 대각선은 최솟, 최댓값 표현
)

# 데이터에서 나트륨(sodium), 식이섬유(fibre), 복합탄수화물(carbo), 칼륨(potassium) 컬럼을 선택하고,
# 결측치가 아닌 데이터만 corrgram으로 상관관계 시각화하시오.

테스트 = scereal %>% 
  filter(!is.na(sodium) & !is.na(fibre) & !is.na(carbo) & !is.na(potassium)) %>%
  select(sodium, fibre, carbo, potassium)

corrgram(테스트, 
         main = '결측치 아닌 sodium, fibre, carbo, potassium 상관관계 행렬',
         lower.panel = panel.shade, # 아래쪽 색상으로 상관관계 표현
         upper.panel = panel.cor,   # 위쪽 상관관계 수치 표현
         diag.panel = panel.minmax   # 대각선은 최솟, 최댓값 표현
)


상관관계 = cor(scereal$fibre, scereal$potassium, use='complete.obs')
print(상관관계)
