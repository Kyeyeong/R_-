library(ggplot2)
scereal = read.csv('UScereal.csv')

# 칼로리 vs 단백질

# 기본 그래프 산점도
plot(scereal$calories, scereal$protein, main = '칼로리 vs 단백질')

# (종속변수) ~ (독립변수) : 독립변수가 변할때 종속변수가 어떻게 변화하는지 나타냄
# 칼로리가 높을 수록 단백질 함량도 높아지는가?

model= lm(scereal$protein ~ scereal$calories)
print(summary(model))
# p-value: 5.071e-11 = 0.00000000005071 
# ***** p-value = 유의 확률 : 1700년도 영국에서 개념 도입, 1900년대 공식 도입
# 과학, 의학, 사회과확 등에서 유용하게 사용

# 유의확률은 통계 분석에서 관계가 우연히 나타날 확률을 의미
# 즉, 칼로리와 단백질 사이에 실제로 아무런 관계가 없는데도
# 우연히 지금처럼 강한 관계를 관찰될 확률을 나타냄
# p-value가 0.05보다 작거나 같으면 '칼로리와 단백질 사이에 통계적으로 의미있는
# 관계가 있다고 볼수 있다
# 둘은 매우 강하게, 우연히 아니라 실제로 강한 관계다 라는 결론을 내릴수 있음
# 그래서 0.05 미만인 애들을 머신러닝 돌림


abline(model, col = 'red')





