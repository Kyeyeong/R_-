emp = read.csv('emp.csv')
str(emp)


# 문제 1: 급여(SAL)가 3000 이상인 직원들의 이름(ENAME)과 직업(JOB)을 출력하세요.
# # 힌트 : filter(), select()
result = emp %>% filter(SAL >= 3000) %>% select (ENAME, JOB)
print(result)


# 문제 2: "RESEARCH" 부서에 근무하는 직원들의 이름(ENAME)과 급여(SAL)를 출력하세요.
# # 힌트 :  inner_join(), filter(), select()

# 문제 3: 직업(JOB)별 평균 급여(SAL)를 계산하고 출력하세요.
# # 힌트 : group_by(), summarize()
result = emp %>% group_by(JOB) %>% summarise(AVG_SAL = mean(SAL))
print(result)

# 문제 4: 각 부서(DNAME)별 직원 수를 계산하고 출력하세요.
# # 힌트 : group_by(), summarize()



# 문제 5: 고용일(HIREDATE)이 "1981-01-01" 이후인 직원들의 이름(ENAME), 직업(JOB), 고용일(HIREDATE)을 출력하세요.
# # 힌트 : filter(), select()
emp$HIREDATE = as.Date(emp$HIREDATE)
result = emp %>% filter(HIREDATE > as.Date('1981-01-01')) %>% select(ENAME, JOB, HIREDATE)
print(result)



# 문제 6: 부서별(DEPTNO)로 그룹화하여 총 급여(SAL)의 합계를 계산하고 출력하세요.
# # 힌트 : group_by(), summarize()
result = emp %>% group_by(DEPTNO) %>% summarise(SUM_SAL = sum(SAL))
print(result)


# 문제 7: 커미션(COMM)이 결측치가 아닌 직원들의 이름(ENAME), 커미션(COMM)을 출력하세요.
# # 힌트 : filter(!is.na()), select()
result = emp %>% filter(!is.na(COMM)) %>% select(ENAME, COMM)
print(result)



# 문제 8: "SALES" 부서에서 근무하는 직원들의 이름(ENAME), 급여(SAL), 커미션(COMM)을 출력하세요.
# # 힌트 : inner_join(), filter(), select() 
# 문제 9: 각 부서(DNAME)별로 가장 높은 급여를 받는 직원의 이름(ENAME)과 급여(SAL)를 출력하세요.
# # 힌트 : group_by(), slice_max(), select()
# 문제 10: 직업(JOB)이 "MANAGER"인 직원들의 이름(ENAME), 부서명(DNAME), 급여(SAL)을 출력하세요.
# # 힌트 :  inner_join(), filter(), select()
  
  
# 문제 11: 부서번호가 20번이고 직책이 MANAGER인 사원 번호와 사원 이름 조회
result = emp %>% filter(DEPTNO == 20 & JOB =='MANAGER') %>% select(empNO, ENAME)
print(result)

  
# 문제 12: 각 직업별 사원 수 구하기
result = emp %>% group_by(JOB) %>% summarise(count = n())
print(result)


# 문제 13: 부서 번호가 20인 직원들의 직업(JOB)별 평균 급여(SAL)를 계산하세요.
result = emp %>% filter(DEPTNO == 20) %>% group_by(JOB) %>% summarise(AVG_SAL = mean(SAL))
print(result)


# 문제 14: 급여가 2000 이상인 직원들만 필터링한 후, 부서 번호(DEPTNO)별 직원 수를 계산하세요.
result = emp %>% filter(SAL >= 2000) %>% group_by(DEPTNO) %>% summarise(count = n())
print(result)


# 문제 15: 커미션(COMM)이 결측치가 아닌 직원들만 필터링한 후, 부서 번호(DEPTNO)별 평균 커미션과 최대 커미션을 계산하세요.
result = emp %>% filter(!is.na(COMM)) %>% group_by(DEPTNO) %>% summarise(AVG_COMM = mean(COMM), MAX_COMM = max(COMM))
print(result)


# 문제 16: 직업(JOB)이 "MANAGER"인 직원들만 필터링한 후, 부서 번호(DEPTNO)별 총 급여(SAL)의 합계를 계산하세요.
result = emp %>% filter(JOB == 'MANAGER') %>% group_by(DEPTNO) %>% summarise(TOTAL = sum(SAL))
print(result)


# 문제 17: 고용일(HIREDATE)이 "1981-01-01" 이후인 직원들만 필터링한 후, 직업(JOB)별 평균 급여(SAL)와 직원 수를 계산하세요.
emp$HIREDATE = as.Date(emp$HIREDATE)
result = emp %>% filter(HIREDATE >= as.Date('1981-01-01')) %>% group_by(JOB) %>% summarise(AVG_SAL = mean(SAL))
print(result)



# 문제 18: 각 부서별로, 입사일(HIREDATE)이 가장 오래된 직원의 이름과 입사일만 출력
result = emp %>% group_by(DEPTNO) %>% slice_max(HIREDATE, n=1) %>% select(ENAME, HIREDATE, DEPTNO) 
print(result)


# 문제 19: 매니저(MGR)가 없는 직원과, 매니저(MGR)가 있는 직원 중 급여가 2,000 이상인 직원만 추출
result = emp %>% filter(is.na(MGR) | (!is.na(MGR) & SAL >= 2000))  
print(result)


# 문제 20: 각 직무(JOB)별로, 급여가 상위 2위 이내에 드는 직원의 이름, 급여, 직무만 급여 내림차순으로 출력
result = emp %>% group_by(JOB) %>% slice_max(SAL, n=2) %>% select(ENAME, SAL, JOB) %>% arrange(desc(SAL)) 
print(result)


