# install.packages("ggplot2")  설치는 한번만

library(ggplot2)  # 불러오기

scereal = read.csv('UScereal.csv')

# 기본 산점도 칼로리 vs 단백질
# aes : aesthetics 미적속성
# labs : labels 
plot = ggplot(scereal,
              aes(x = calories, y = protein)) +
                geom_point() + # 산점도의 점
                labs(title = '칼로리 vs 단백질', x = 'calories', y = 'protein') +
                geom_smooth(method = 'lm', se = TRUE) + # 회귀선 추가
                theme_minimal() # 깔끔하게 처리
               
# print(plot)

scereal$label = rownames(scereal) # 행의 번호를 label이라는 컬럼 추가
# View(scereal)  # 실무에서는 이런걸 시퀀스라고 함함
# 산점도 그래프에 텍스트 추가

plot = ggplot(scereal,
              aes(x = calories, y = protein)) +
  geom_point() + # 산점도의 점
  labs(title = '칼로리 vs 단백질', x = 'calories', y = 'protein') +
  geom_smooth(method = 'lm', se = TRUE) + # 회귀선 추가
  geom_text(aes(label = label), hjust=0, vjust=1, size=3, check_overlap = TRUE) +
  theme_minimal() # 깔끔하게 처리
print(plot)

#칼로리가 낮은 제품은 Good, 높은 제품은 Bad를 구분하는 새로운 열을 추가
# 칼로리가 평균보다 낮으면 Good, 아니면 Bad
# 새로운 열 `grade` 추가

평균칼로리 = mean(scereal$calories, na.rm = TRUE)
cat('칼로리 평균 : ', 평균칼로리, '\n')

scereal$grade = ifelse(scereal$calories >= 평균칼로리, "BAD", "GOOD")

# print(head(scereal))


# GOOD 동그라미, BAD 세모 표시

plot = ggplot(scereal,
              aes(x = calories, y = protein, shape = grade, colour = grade)) +
  geom_point() + # 산점도의 점
  labs(title = '칼로리 vs 단백질', x = 'calories', y = 'protein') +
  scale_shape_manual(values = c("GOOD" = 16, "BAD" = 17)) + # 모양 다르게 지정
  scale_color_manual(values = c("GOOD" = "blue", "BAD" = "red")) +  # 모양 색깔 지정정
  geom_smooth(method = 'lm', se = TRUE) + # 회귀선 추가
  geom_text(aes(label = label), hjust=0, vjust=1, size=3, check_overlap = TRUE) +
  theme_minimal() # 깔끔하게 처리

print(plot)

## ggplot에서는 ggsave라는 명령어로 쉽게 저장할 수 있음
# dpi : 해상도 dot per inch
ggsave('myplot.png', width = 10, height = 6, dpi = 300, bg = 'white')





