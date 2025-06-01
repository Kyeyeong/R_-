# 벡터 복습
# 1. 벡터는 비슷한 데이터(같은 데이터형)를 한 줄로 모아놓은 상자
# 2. 벡터를 생성할 때에는 c() = combine 라는 문법을 사용
# 3. 벡터에서 값을 꺼낼 때는 []를 사용

colors = c('red', 'blue', 'green')  # 벡터 생성

print(colors[1])  # ctrl+shift+s, 가장 많이 씀씀

# 오류 print(colors[3], colors[2]) 

print(colors[c(2, 3)])   # 참고만 해


# ***** 벡터와 조건문 활용
# ifelse : 만약 ~ 라면면
x = c(1, 2, 3, 4, 5)
result = ifelse(x %% 2 ==0, 'even', 'odd')
print(result)


# 데이터프레임 : 가로(행)와 세로(열)가 있는 테이블

# 벡터생성
id = c(1, 2, 3)
name = c('James', 'June', 'Paul')
age = c(23, 34, 56)

# 데이터프레임(벡터를 묶은거) 생성
df = data.frame(id, name, age)  

#View(df)   # 테이블 형태로 출력

# EMPNO : 사원번호
# ENAME : 사원명
# JOB   : 직책
# MGR   : 사수번호
# HIREDATE : 입사날짜
# SAL : 급여
# COMM : 보너스(커미션)
# DEPTNO : 부서번호


emp = data.frame(
  empNO = c(7369, 7499, 7521, 7566, 7698, 7782, 7788, 7839, 7844, 7900),
  ENAME = c("SMITH", "ALLEN", "WARD", "JONES", "BLAKE", "CLARK", "SCOTT", "KING", "TURNER", "ADAMS"),
  JOB = c("CLERK", "SALESMAN", "SALESMAN", "MANAGER", "MANAGER", "MANAGER", "ANALYST", "PRESIDENT", "SALESMAN", "CLERK"),
  MGR = c(7902, 7698, 7698, 7839, 7839, 7839, 7566, NA, 7698, 7788),
  HIREDATE = as.Date(c("1980-12-17", "1981-02-20", "1981-02-22", 
                       "1981-04-02", "1981-05-01", "1981-06-09",
                       "1982-12-09", "1981-11-17", "1981-09-08",
                       "1983-01-12")),
  SAL = c(800, 1600, 1250, 2975, 2850, 2450, 3000, 5000, 1500, 1100),
  COMM = c(NA, 300, 500, NA, NA, NA, NA, NA, NA, NA),
  DEPTNO = c(20, 30, 30, 20, 30, 10, 20, 10, 30, 20)
)
# View(emp)
# 데이터프레임 조회

# *** 데이터프레임의 타입 확인
str(emp)   # str = structure 구조

#1행부터 6행까지 출력 = head
print(head(emp))

#1행부터 2행까지 출력
print(head(emp, 2))

# 아래서 부터 6행까지 출력 =tail
print(tail(emp))

# 아래서부터 2행까지 출력
print(tail(emp, 2))

# 전체컬럼 조회t
print(colnames(emp))

# 행과 열 개수 조회  dim = dimension(차원)
print(dim(emp))

# 데이터프레임 특정 열 조회
# 사원 이름만 조회
cat('사원 이름 : ', emp$ENAME, '\n')
# 부서 조회만 조회
cat('부서 : ',emp$DEPTNO, '\n')

# 새로운 열 생성
emp$bonus = 100
#View(emp)

# 데이터프레임 -> 엑셀로 전환
# file = 'emp.csv' : 저장할 파일 이름
# row.names = FALSE : 행 번호가 파일에 저장되지 않음
# write.csv(emp, file = 'emp.csv', row.names = FALSE)

# 집계함수
# 엑셀 총합, 평균, 최댓값, 최솟값....
# R도 엑셀처럼 통계내는 도구가 존재

# 벡터 생성
x = c(10, 20, 30, 40, 50)
최솟값 =  min(x)
최댓값 = max(x)
총합 = sum(x)
평균 = mean(x)
표준편차 = sd(x)   # sd : standard deviation 

# 데이터프레임에서 특정 열(벡터 조회)
# cat을 이용해서 emp 급여만 조회
cat('사원 급여 : ', emp$SAL, '\n')

# 사원급여 평균
cat('사원 급여 mean : ', mean(emp$SAL), '\n')
cat('사원 급여 sum : ', sum(emp$SAL), '\n')
cat('사원 급여 max : ', max(emp$SAL), '\n')

# COMM 총합    na.rm = TRUE 열 값 중 NA가 있으면 집계 안안됨
cat('사원 커미션 sum : ', sum(emp$COMM, na.rm = TRUE), '\n')

# 제어문을 활용한 열 생성
# 사원급여가 3000 이상이면 high, 나머지는 low
emp$Grade = ifelse(emp$SAL >= 3000, 'High', 'Low')
# View(emp)

# 기존 열 수정
emp$bonus = emp$bonus * 2
# View(emp)

# 사원 근속일 컬럼 추가
print(Sys.Date())
# difftime : 시간 차이 계산 단, 데이터열(행)의 데이터타입이 날짜형(as.date)이여야 함함
cat('사원 근속일 : ', difftime(Sys.Date(), emp$HIREDATE), '\n')

# 데이터프레임 행 조건 필터링
# 데이터프레임 [행조건, 열조건]
# 사원 급여가 2000이상인 사원 전체 조회
print(emp[emp$SAL >= 2000, ])

print(emp[emp$SAL >= 2000, c(2, 6)])

# job 직책이 salesman인 사원의 이름과 직책 입사날짜 조회
print(emp[emp$JOB == 'SALESMAN', c(2, 3, 5)])

# 급여가 1500~3000 직원 조회
print(emp[emp$SAL>=1500 & emp$SAL<=3000, ])

# 커미션을 받은 직원 
# *** is.na() 
print(emp[is.na(emp$COMM), ])
print(emp[!is.na(emp$COMM), c(2, 7)])








