setwd('C:/Users/kcs/Desktop/r_workspace/data')
print(getwd())

print(list.files()) # 현재 디렉토리의 파일 목록 출력

emp = read.csv('emp.csv')
# View(emp)

# 행과 열 개수
print(dim(emp))
# 전체 컬럼 조회
print(colnames(emp))
# 상위1~4행
print(head(emp, 4))
# 마지막 3행
print(tail(emp, 3))
# 데이터 타입
print(typeof(emp))
print(str(emp))   # **** 매우 중요 structure

# *** dplyr(디플리알) : data frame plier 데이터프레임을 다루는 공구
# 실무에서 많이 사용, 대규모 데이터셋에서 빠른 속도 제공

# install.packages('dplyr')   # 설치명령어 -> 설치 후 주석처리리
library(dplyr)  # 설치된 디플리알 불러오기

# 급여가 3000이상인 조회
# 방향 %>% = 람다식 표현현
급여3000 = emp %>% filter(SAL >= 3000)
#오류 cat('급여3000 : ', 급여3000, '\n')
print(급여3000)
# 급여 3000 이상 사원 이름, 급여 사원번호
result = emp %>% filter(SAL >= 3000) %>% select(ENAME, SAL, empNO)
print(result)

# 직책이 MANAGER인 사원의 이름 직책 부서번호 급여
result = emp %>% filter(JOB == 'MANAGER') %>% select(ENAME, JOB, DEPTNO, SAL)
print(result)

# 새로운 열 추가&수정
result = emp %>% mutate(TOTAL_COMM = SAL+100)
print(result)

# 급여와 커미션의 합계를 기존 TOTLA_COMM에 수정
result = emp %>% mutate(TOTAL_COMM = SAL + ifelse(is.na(COMM), 0, COMM))
print(result)

# group by + summarize - 데이터를 특정 기준으로 묶어 그룹화
# 단, summarize와 함께 사용

# 직책별(JOB) 평균 급여여
group_result = emp %>% group_by(JOB) %>% summarise(AVG_SAL = mean(SAL))
print(group_result)
#View(group_result)

# 부서번호 별 평균 급여
group_result = emp %>% group_by(DEPTNO) %>% summarise(mean(SAL))
print(group_result)

# 부서번호 별 평균, 총합
group_result = emp %>% group_by(DEPTNO) %>% summarise(mean(SAL), max(SAL), min(SAL))
print(group_result)

# 직책별 직원수
group_result = emp %>% group_by(JOB) %>% summarize(count = n())
print(group_result)

# 정렬 arrange(조정하다, 배열하다)
# arrange(count) - count 기준으로 오름차순순
group_result = emp %>% group_by(JOB) %>% summarize(count = n()) %>% arrange(count)
print(group_result)
# 내림차순 desc = descending
group_result = emp %>% group_by(JOB) %>% summarize(count = n()) %>% arrange(desc(count))
print(group_result)

# 급여 기준으로 내림차순 정렬, 급여, 이름만 출력 = 정렬은 항상 마지막에 정렬렬
group_result = emp  %>% select(ENAME, SAL) %>% arrange(desc(SAL))
print(group_result)

# 부서별 최대 급여 직원 조회
# slice = 자르다
group_result = emp %>% group_by(DEPTNO) %>% slice_max(SAL, n=1)
print(group_result)


# 박스플롯
# boxplot(emp$SAL ~ emp$DEPTNO, main = '부서별 급여', xlab = '부서번호', ylab= '급여',
#         col = c('orange', 'green', 'lightblue'))

#근속연수일 항목 추가
today = Sys.Date()
str(emp) # 데이터 확인
# 방법1
emp = emp %>% mutate(HIREDATE = as.Date(HIREDATE))
str(emp) # 데이터 확인
# 방법2
emp$HIREDATE = as.Date(emp$HIREDATE)
str(emp)

result = emp %>% mutate(근속일 = difftime(today, HIREDATE))
# View(result)

# 급여가 2000이상인 직원 중 세후 급여(SAL_TAX) 컬럼 추가, 단 사원이름 급여만 조회, 급여 내림차순
# 3.3% 원천징수
result = emp %>% filter(SAL >= 2000) %>% select(ENAME, SAL) %>% mutate(SAL_TAX = SAL*0.967) %>% arrange(desc(SAL))
print(result)

# 부서번호가 30인 직원 중 이름, 직업, 부서번호 조회, 단 이름 오름차순
result = emp %>% filter(DEPTNO == 30) %>% select(ENAME, JOB, DEPTNO) %>% arrange(ENAME)
print(result)

# 1981-01-01 이후 입사한 직원 이름, 입사일, 급여, 근무연수 조회
result = emp %>% filter(HIREDATE > as.Date('1981-01-01')) %>% select(ENAME, HIREDATE, SAL) %>% mutate(근무연수 = difftime(Sys.Date(), HIREDATE))
print(result)





