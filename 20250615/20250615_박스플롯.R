# 박스플롯 = 주식 차트 : 데이터 분포를 시각적 표현, 최솟값, 최댓값, 중앙값 등을 요약 통계치 보여줌

# 제조사별 칼로리 분포를 박스플롯

library(ggplot2)  # 불러오기
scereal = read.csv('UScereal.csv')

boxplot = ggplot(scereal, aes(x = mfr, y = calories, fill = mfr)) +
  geom_boxplot() +
  labs(title = "제조사별 칼로리 분포", 
       x = "제조사",
       y = "칼로리") +
  theme_minimal()  # 배경색 제거

str(scereal)
# print(boxplot)

# 제조사별 나트륨(sodium) 분포 박스플롯
boxplot = ggplot(scereal, aes(x = mfr, y = sodium, fill = mfr)) +
  geom_boxplot() +
  labs(title = "제조사별 나트륨 분포", 
       x = "제조사",
       y = "나트륨") +
  theme_minimal() +  # 배경색 제거
  theme(panel.grid = element_blank())

print(boxplot)

ggsave('myplot2.png', width = 10, height = 6, dpi = 300, bg = 'white')
