
print('안녕하세요 R을 시작합니다.')

# 주석
# 주석은 프로그래밍에 있어서 '메모'하는 것을 목적으로 사용됩니다.

print('Hello World') #단일 주석

# Author : 김계영
# Date : 2025-05-18
# Comment : 프로그램 테스트
# 실무에서는 작성자, 코드작성날짜 등 상세히 입력, 코드는 팀으로 프로젝트 하기 때문에

# 출력하기
# 첫번째 방법
print('Hello')
# 두번째 방법
# cat 'concatenate'의 줄임말, 연결하다, 이어붙이다 라는 뜻
cat('hello', 'world', '\n') # \n 개행


# 자료형

print(35)
print('홍길동')

# ctrl+enter 한줄 코드만 실행행

# 인간이 정보를 주고 받을때는 문자와 숫자면 충분, 하지만, 컴퓨터는 한가지 더 요구
# 논리형(True/False) 이라고 합니다.

print(TRUE)
print(FALSE)

#범주형 데이터타입
#범주형 항목으로 구분된 데이터
#수치적인 계산보다는 분류와 그룹화에 적합

# 1.혈액형(A, B, O, AB) 2.성별 3. 고객만족도(매우만족, 만족, 보통...)

print(factor(c('A', 'B', 'O', 'AB')))

# 특수 데이터형(R에서 더 특히히 중요)
# R에서 특수 데이터형이란 데이터 분석과정에서 자주 마주치는 특별한 의미를 가진 값

# 1. NA : 결측값(missing value), 누락된 데이터
print(NA)

# 2. NULL : 비어있는 값(데이터 자체가 존재하지 않음)
# NULL은 Python 이나 C 다른 언어에서 중요요
print(NULL)

#자료형 확인 - 문자, 숫자, 논리형
# R에서 기본적으로(Default) 숫자는 실수로 인식식
print(typeof(34))

print(typeof(34L))  #integer(정수)

print(typeof('apple'))  #character(문자)

print(typeof(TRUE))  # 논리

print(typeof(NULL)) #NULL(값이 없다)

print(typeof(NA)) #결측값(논리)

# ***데이터 타입 변환
#R에서 타입 변환(형변환)은 원하는 자료형으로 바꾸는 작업, 실무에서 많이 활용

print(as.character(123)) # 숫자를 문자로 변경
print(as.numeric('123')) # 문자를 숫자로 변경

#숫자에서 논리형으로 변경
# 컴퓨터는 0을 거짓으로 1을 참으로 이해해
print(as.logical(0)) #False
print(as.logical(1)) #True

# 변수 : 값이 들어갈 수 있는 상자, 그 상자에는 자료형이 들어감

저금통 = 1000
print(저금통)


저금통2 = 21000
print(저금통2)

# = : 대입연산자
# 저금통 : 변수

# 사칙 연산자(+, -, *, /) ** 지수수
num = 3+2
print(num)

num = 2**3
print(num)

# 비교 연산자
print(5>2)  # 5는 2보다 크다. TRUE로 출력
print(3<2)  # 3은 2보다 작지 않. FALSE로 출력
print(5<=5)
print(3==3)
print(3!=3)

# 논리연산자
print((3>2) & (5>4)) # & - AND 연산자, 두 조건이 모두 참이면 참을 출력
print((3>2) | (5>4)) # | - OR 연산자, 두 조건 중 하나만 참이면 참을 출력
print(!(3>20))

result = 0
result = (50+30)/(10-2)*3
print(result)

# *****벡터(Vector) : 벡터는 여러개의 값을 한 줄로 쭉 늘어놓은 상자
# 동일한 데이터를 쭉 늘어놓은 것 = 1차원 배열(Array)

# 예 : 친구 5명의 시험점수를 입력한다고 가정
# c() - Combined 결합된
점수 = c(90, 85, 100, 93, 88) # 벡터로 친구 5명의 점수를 한번에 담았음
print(점수)
# 문자 벡터
색깔 = c('red', 'blue', 'green')
print(색깔)

# 벡터에서 특정 값을 꺼낼때는 대괄호 []를 사용
print(점수[1])

# 벡터에서 여러 값 꺼내기
print(점수[c(1, 3, 5)])

# 연속된 숫자를 벡터로 만들기 1~10까지 숫자를 벡터로 만들어 보기
숫자 = 1 : 10
print(숫자)

# *** 벡터 형변환
숫자벡터 = as.numeric(c('1', '2', '3'))
print(숫자벡터)

# 숫자로 변환해야 연산이 가능하기 때문에

문자열벡터 = as.character(c(1, 2, 100))
print(문자열벡터)

# 벡터연산
# 벡터는 수학적 연산이 가능합니다.

x = c(2, 4, 6, 8)
y = c(1, 2, 3)

z = x+y
print(z)


# 1. 숫자 10, 20, 30으로 이루어진 벡터 num_vec을 선언하세요.
num_vec = c(10, 20, 30)
print(num_vec)

fruit_vec = c("apple", "banana", "orange")
print(fruit_vec[2])


seq_vec = 1:5
print(seq_vec[c(1, 3, 5)])

num_char = c("1", "2", "3")
print(as.numeric(num_char))

logic_vec = c(TRUE, FALSE, TRUE)
print(as.character(logic_vec))


# ***벡터 조건문
# 조건문 - 문장을 의미 = 조건이 들어있는 문장
# 특정 조건이 만족하면 한가지 일을 하고, 아니면 다른일을 하게 하는 명령어

나이 = 25
if(나이 > 20){
  print('ok')
}else{
  print('no')
}

x = c(1, 2, 3, 4, 5)
짝수 = ifelse(x%%2==0, '짝수', '홀수')    # %% 나머지값
print(짝수)

점수 = c(90, 70, 80, 100, 99)
A학점 = ifelse(점수>=90, 'A', 'B')
print(A학점)

A학점 = ifelse((점수>=80)&(점수<=90), 'A', 'B')
print(A학점)


#1. 1부터 10까지의 정수 벡터 num_vec에서 각 값이 짝수면 "even", 홀수면 "odd"라는 문자 벡터를 만드세요.

num_vec = 1:10
char_vec = ifelse(num_vec%%2==0, 'even', 'odd')
print(char_vec)

#2. 점수 벡터 score_vec = c(85, 42, 77, 64, 58)에서 60점 이상은 "PASS", 미만은 "FAIL"로 표시하는 문자 벡터를 만드세요.


score_vec = c(85, 42, 77, 64, 58)
result = ifelse(score_vec>=60, 'PASS', 'FAIL')
print(result)

#3. 몸무게 벡터 weight = c(69, 50, 55, 71, 89, 64, 59, 70, 71, 80)에서 60~70kg 사이 값만 추출하여 새로운 벡터로 만드세요.

weight = c(69, 50, 55, 71, 89, 64, 59, 70, 71, 80)
weight_60_70 <- weight[weight >= 60 & weight <= 70]
print(weight_60_70)

# 문자열 처리
# R에서 특정 문자를 바꾼다거나 잘라내기 같은 기능이 필요할 때 사용

# 1. substr - 특정 위치의 부분 문자열을 추출
# 2. strsplit - 특정 구분자를 기준으로 나누어 분리
# 3. gsub - 다른 문자로 대체

text = '안녕하세요. 오늘은 R을 배워요.'
print(substr(text, 1 , 10))

print(substr(text, 3 , 10))

print(substr(text, 1 , 10))

text= 'kky@korea.kr'
print(strsplit(text, split='@'))



text = '고양이와 함께 놀고있ㅇ요요'
결과 = gsub('고양이', )

text = '15000$'
text1 = gsub('\\$', '', text)  #달러기호 제거 
print(as.numeric(text1))

# 학생 이름이 벡터로 주어졌습니다. 각 이름의 첫 글자만 뽑아서 새로운 벡터로 만들어 보세요.
names = c("민수", "지영", "철수", "영희")
결과 = substr(names, 1, 1)
print(결과)
# 각 이름의 첫 글자만 추출하는 코드를 작성하세요.


# 휴대폰 번호 벡터가 있습니다. 각 번호에서 가운데 4자리만 추출해 벡터로 만드세요.
phones = c("010-1234-5678", "010-9876-4321")
결과 = substr(phones, 5, 8)
print(결과)
# 가운데 4자리(1234, 9876)만 추출하는 코드를 작성하세요.


fruits = c("사과,바나나,포도", "딸기,수박")
결과 = strsplit(fruits, split = ',')
print(결과)
# 쉼표(,)를 기준으로 과일 이름을 나누는 코드를 작성하세요.

#아래 벡터에서 모든 'a'를 'A'로 바꾼 새로운 벡터를 만드세요.
words = c("apple", "banana", "grape")
결과 = gsub('a', 'A', words)
print(결과)
# 모든 'a'를 'A'로 바꾸는 코드를 작성하세요.


# 문장 벡터에서 마침표(.)를 공백(' ')으로 바꾸고, 다시 공백을 기준으로 단어별로 나누는 코드를 작성하세요.
sentences = c("I like apple.", "You like banana.")
# 1. 마침표를 공백으로 바꾸고
결과 = gsub('\\.', ' ', sentences)
print(결과)
# 2. 공백으로 단어를 나누세요.
결과2 = strsplit(결과, split=' ')
print(결과2)



# 1. 벡터에서 두 번째 값을 출력하는 코드를 써 보세요.
colors = c("red", "green", "blue")
print(colors[2])


# 2. 벡터에서 1, 3번째 값을 한 번에 출력하는 코드를 써 보세요.
nums = c(10, 20, 30, 40)
print(nums[c(1, 3)])

# 3. 벡터의 각 값이 50 이상이면 "PASS", 아니면 "FAIL"을 출력하는 코드를 ifelse로 써 보세요.
scores = c(80, 45, 60, 30)
결과 = ifelse(scores>=50, 'PASS', 'FAIL')
print(결과)

# 4. 벡터의 각 값이 "apple"이면 "과일", 아니면 "모름"을 출력하는 코드를 ifelse로 써 보세요.
items = c("apple", "car", "apple", "dog")
결과 = ifelse(items=='apple', '과일', '모름')
print(결과)


#5. 벡터의 각 값에서 첫 글자만 뽑아 새로운 벡터로 만들어 보세요.
names = c("민수", "지영", "철수")
결과 = substr(names, 1, 1)
print(결과)


# 6. 벡터의 각 값에서 모든 "a"를 "A"로 바꾼 새로운 벡터를 만들어 보세요.
words = c("apple", "banana", "grape")
결과 = gsub('a', 'A', words)
print(결과)

# 7. 쉼표(,)로 연결된 과일 이름 벡터를 과일별로 나누어 리스트로 만들어 보세요.
fruits = c("사과,바나나", "포도,딸기")
결과 = strsplit(fruits, split = ',')
print(결과)

# 8. 숫자 벡터를 문자 벡터로 바꾸는 코드를 써 보세요.
nums = c(1, 2, 3)
print(as.character(nums))

# 9. 문자 벡터를 숫자 벡터로 바꾸는 코드를 써 보세요.
str_nums = c("10", "20", "30")
print(as.integer(str_nums))

# 10.문자 벡터를 숫자 벡터로 바꾸는 코드를 써 보세요.
price = c("15000$", "22000$", "18000$")
결과 = as.integer(gsub('\\$', '', price))
print(결과)


# 숫자 10을 R에서 저장하면 어떤 자료형일까요?
print(typeof(10))

#   "사과"처럼 따옴표로 감싼 것은 어떤 자료형일까요?
print(typeof('사과'))

#   참(True) 또는 거짓(False)은 어떤 자료형일까요?
print(typeof(TRUE))

#   날짜를 저장하는 자료형을 무엇이라고 하나요?
print(typeof('2024-01-01')

#   아래 코드에서 변수 a의 자료형은 무엇일까요?
a = 3.14
print(typeof(a))


# 변수에 5를 저장하고, 그 값을 출력하는 코드를 써 보세요.
a = 5
print(a)

# 변수 x에 7을 저장하고, x에 3을 더한 값을 출력하는 코드를 써 보세요.
x = 7
print(x+3)

# 변수란 무엇을 저장하는 상자라고 했나요? 벡터터

#   아래 코드에서 변수의 이름은 무엇인가요? my_age
#   my_age = 12

# 8 + 2의 식과 결과를 R로 구현하세요.
print(8+2)

# 10 - 4의 식과 결과를 R로 구현하세요.
print(10-4)
# 3 * 5의 식과 결과를 R로 구현하세요.
print(3 * 5)

# 12 / 4의 식과 결과를 R로 구현하세요.
print(12 / 4)

# 7 > 5의 결과를 R로 구현하세요.
print(7 > 5)


# 아래 코드에서 "어린이"가 출력되려면 age에 어떤 숫자를 넣어야 하는지 R로 구현하세요.
age= 12
  if (age < 13) {
    print("어린이")
  } else {
    print("청소년")
  }


# 숫자 1, 2, 3을 담은 벡터를 만들어 보세요.
num = c(1, 2, 3)
print(num)

# 아래 벡터에서 두 번째 값을 출력하는 코드를 써 보세요.
fruits = c("사과", "바나나", "포도")
print(fruits[2])


## *** 벡터 합계함수
x=c(10, 20, 30, 40, 50)
print(mean(x))
print(sum(x))
print(mean(x))
print(median(x))
print(sd(x))
#표준편차 - 데이터가 평균으로 얼마나 퍼져있는지를 나타내는 통계적 지표
#standard deviation 

# 벡터에 결측값(누락된 값)이 있을 때
x = c(1, 2, NA, 4)  # 결측치가 포함된 벡터
# 결측치가 포함된 데이터는 바로 계산했을 때 NA가 나옵니다.
평균 = mean(x)
print(평균)
# 이 결측값을 처리 후 계산해야 함
# 결측값 확인하기
data = c(1, 2, NA, 4, NA, 6)
print(is.na(data))  # NA가 있는 원소는 TRUE가 출력력

# 결측값을 제거하기
# 1. na.omit
# 2. na.rm(remove)

결과 = na.omit(data)
print(결과)

data = c(1, 2, NA, 4, NA, 6)
결과2 = mean(data, na.rm=TRUE)
print(결과2)

# 다음 벡터에서 결측치(NA)를 벡터의 중앙값으로 대체한 벡터를 만드시오
x = c(NA, 20, 36, NA, 50, 10)
결과 = median(x, na.rm = TRUE)
print(결과)

# ***** 벡터들의 집합 = 데이터 프레임
# 데이터프레임을 잘 다루면 R은 50% 끝남
# 데이터프레임은 행과 열로 구성된 표 형태의 데이터 구조

# 벡터 생성
ID = c(1, 2, 3)
Name = c('홍길동', '박길동', '홍길동')
Age = c(35, 25, 46)
Salary = c(5000, 6000, 7000)

# 데이터프레임 생성
# 벡터들을 한번에 묶은게 데이터프레임(dataframe)

df = data.frame(ID, Name, Age, Salary)
print(df)
View(df)







