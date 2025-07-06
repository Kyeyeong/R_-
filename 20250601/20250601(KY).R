# 경로 확인
print(getwd())

# 해당 경로에 있는 파일 조회
print(list.files())


# csv 파일 불러오기
emp = read.csv('emp.csv')
#View(emp)

# 데이터 확인
# 문제 1. 행과 열의 개수 파악 = dimension
print(dim(emp))

# 문제 2. 전체 컬럼만 조회= column names
print(colnames(emp))

# 문제 3. 메이터 상위 1~2행 출력하기 = head
print(head(emp, 2))

# 문제 4. 데이터 마지막 3개행 출력하기 = tail
print(tail(emp, 3))

# 문제 5. 데이터 타입 확인**** = structure : print 안써도 됨
str(emp)

## dplyr(디플리알) - 데이터 가공 전처리
# 데이터 가공 전처리가 실무에서 80~90% 하는 일

# 설치가 필요함 install.packages("dplyr")
# install.packages("dplyr")
# 설치한 프로그램 가져오기(import, road)
library(dplyr) # 설치한 프로그램 가져오기 - import

# 급여(SAL)가 3000 이상인 직원들의 이름, 직업
result = emp %>% filter(SAL>=3000) %>% select(ENAME, JOB)
print(result)

# 직업별 평균 급여 계산
# R은 group_by 만 단독적으로 사용시 의미없는 결과가 나온다
# 그룹별 평균(mean), 행의 수(n), 총합(sum)...
result = emp %>% group_by(JOB) %>% summarise(AVG_SAL = mean(SAL), EMP_COUNT = n())
print(result)

# 급여 2000이상인 직원들만 필터링 후, 부서번호(DEPTNO)별 직원수 계산
result = emp %>% filter(SAL>=2000) %>% group_by(DEPTNO) %>% summarise(EMP_COUNT = n())

#dept 파일 불러오기, str로 구조 확인
print(list.files())
dept = read.csv('dept.csv')
str(dept)
# View(dept)

# dplyr 병합(join)
# 두 데이터 프레임을 특정 컬럼을 기준으로 병합
result = emp %>% inner_join(dept, by = "DEPTNO")

# 근무지가 "DALLAS"인 직원들의 이름 출력
result = emp %>% inner_join(dept, by = "DEPTNO") %>% filter(LOC=='DALLAS') %>% select(DNAME, JOB)
print(result)

# slice : 자르다(DBMS = limit), slice는 (대부분의 경우) 맨 마지막에 작성성
result = emp %>% slice(2, 4)
print(result)


result = emp %>% slice(1:3)
print(result)


# 문제 2: "RESEARCH" 부서에 근무하는 직원들의 이름(ENAME)과 급여(SAL)를 출력하세요.
result = emp %>% inner_join(dept, by = "DEPTNO") %>% filter(DNAME=="RESEARCH") %>% select(DNAME, SAL)
print(result)

# 문제 4: 각 부서(DNAME)별 직원 수를 계산하고 출력하세요.
result = emp %>% inner_join(dept, by = "DEPTNO") %>% group_by(DNAME) %>% summarise(EMP_COUNT = n()) %>% slice(1)
print(result)
 
# 문제 8: "SALES" 부서에서 근무하는 직원들의 이름(ENAME), 급여(SAL), 커미션(COMM)을 출력하세요.
# 문제 10: 직업(JOB)이 "MANAGER"인 직원들의 이름(ENAME), 부서명(DNAME), 급여(SAL)을 출력하세요.
result = emp %>% inner_join(dept, by = "DEPTNO") %>% filter(JOB == "MANAGER") %>% select(ENAME, DNAME, SAL)
print(result)


result = emp %>% inner_join(dept, by = "DEPTNO") %>% group_by(DNAME) %>% summarise(EMP_COUNT = n()) %>% arrange(desc(EMP_COUNT)) %>% slice(1:2)
print(result)


