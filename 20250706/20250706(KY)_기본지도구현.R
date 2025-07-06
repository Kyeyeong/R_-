# 지도 시각화 구현
# 필요한 패키지 설치
# install.packages('sf')  #공간 데이터를 처리하고 시각화하는 프로그램(패키지)

library(sf)
library(ggplot2)

# R 경로확인
print(getwd())

# SHP(공간데이터를 저장, 표현하하는데 사용하는 파일로 우리나라 좌표가 다 저장되어 있어) 불러오기

shp = 'sig.shp'    #파일이름
korea_map = st_read(shp, quiet = TRUE) #지도파일 불러오기
#korea_map$SIG_KOR_NM <- iconv(korea_map$SIG_KOR_NM, from = "CP949", to = "UTF-8")
# print(korea_map)

library(dplyr)

seoul_map = korea_map %>% filter(substr(SIG_CD, 1, 2) =='11') 


result = ggplot(seoul_map) + 
  geom_sf(fill = 'white', color = 'black') + 
  labs(x='경도', y='위도', title= '전국 행정구역역') +
  coord_sf() + # 지도비율 유지
  theme_minimal()
  
print(result)












