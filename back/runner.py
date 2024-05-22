import mysql.connector                      # MySQL 데이터베이스와 상호 작용하기 위해 
import argparse                             # 명령줄 인수를 처리
import logging                              # 로그 기록
import requests                             # HTTP 요청 보내기 위해
import gevent                               # 비동기 작업을 위해 greenlet 사용
from stats_management import RequestStats   # 요청 통게 관리

# MySQL 데이터베이스 연결
db_config = {
    'user': 'root',      
    'password': '0000',   
    'host': 'localhost',  
    'database': 'test'    
}

conn = mysql.connector.connect(**db_config)     # DB 연결 객체
c = conn.cursor()                               # DB 커서 객체

# result 테이블 생성
c.execute('''CREATE TABLE IF NOT EXISTS result (
             test_id INT,
             average_response_time FLOAT)''')

# 가상의 사용자 클래스 정의 : 각 사용자가 요청을 보내는 역할
class User:

    # 클래스 정의 및 초기화
    def __init__(self, environment, url):
        self.environment = environment # 테스트 환경 객체 저장
        self.url = url  # 요청을 보낼 url

    # 지정된 url로 HTTP GET 요청 보내고 응답 시간 기록
    def do_work(self):
        try:
            response = requests.get(self.url)                       # 지정된 URL로 GET 요청 보냄
            response.raise_for_status()                             # HTTP 상태 코드가 200(성공)이 아닌 경우 예외를 발생
            response_time = response.elapsed.total_seconds() * 1000 # 응답 시간을 밀리초 단위로 변환
            content_length = len(response.content)                  # 응답 내용의 길이를 바이트 단위로 계산
            
            if self.environment.stats:
                self.environment.stats.log_request('GET', self.url, response_time, content_length) # 요청 통계 기록
            self.environment.load_tester.response_times.append(response_time)  # 응답 시간을 LoadTester 객체의 response_times 리스트에 추가
            # 요청 성공과 관련된 디버그 정보를 로그로 기록
            logging.debug(f"Request to {self.url} successful. Response time: {response_time} ms, Content length: {content_length} bytes")
        
        except requests.RequestException as e:
            logging.error(f"An error occurred while requesting {self.url}: {e}") # 예외를 처리하고, 오류 로그를 기록

# 부하 테스트 클래스 정의 : 부하 테스트를 수행하며, 여러 사용자를 동시에 생성하고 요청을 관리
class LoadTester:
    def __init__(self, environment):
        self.environment = environment
        self.response_times = []  # 응답 시간을 저장할 리스트

    # 지정된 수의 사용자 객체 생성 -> 동시 요청 처리
    def spawn_users(self, user_count, url):
        users = [] # 생성된 User 객체를 저장할 리스트
        greenlets = [] # greenlet 객체를 저장할 리스트
        for _ in range(user_count):
            user = User(self.environment, url)
            users.append(user)
            greenlets.append(gevent.spawn(user.do_work)) # User 객체의 do_work 메서드 비동기적으로 실행
        gevent.joinall(greenlets) # 모든 greenlet이 완료될 때까지 기다림.
        return users # 사용자를 생성하고 요청을 수행한 후 users 리스트를 반환

    # 주기적으로 사용자를 추가하여 부하 테스트를 실행
    # 초기 사용자 수만큼 사용자를 생성하고, 지정된 간격마다 추가 사용자를 생성하여 부하 테스트를 실행
    def add_users_periodically(self, initial_users, additional_users, interval, repeat_count, url):
        self.spawn_users(initial_users, url)
        for _ in range(repeat_count):
            gevent.sleep(interval)
            self.spawn_users(additional_users, url)

    # 응답 시간 리스트의 평균을 계산하여 반환
    def calculate_average_response_time(self):
        if self.response_times:
            return sum(self.response_times) / len(self.response_times)
        else:
            return 0

# 테스트 환경 설정 클래스 정의
class TestEnvironment:
    def __init__(self):
        self.stats = RequestStats()  # RequestStats 인스턴스로 초기화
        self.load_tester = LoadTester(self) # LoadTester 객체 생성

# 테스트 환경 설정
def setup_test(): # 로깅 설정 후 TestEnvironment 객체 초기화
    logging.basicConfig(level=logging.DEBUG) # 디버그 수준으로 로깅을 설정
    environment = TestEnvironment() # 테스트 환경 객체를 초기화
    return environment.load_tester # 초기화된 LoadTester 객체를 반환

# 부하 테스트를 설정하고 실행
def main(url, initial_user_count, additional_user_count, interval, repeat_count, test_id):
    load_tester = setup_test()
    # 부하 테스트 실행
    load_tester.add_users_periodically(initial_user_count, additional_user_count, interval, repeat_count, url)
    # 평균 응답 시간 계산
    average_response_time = load_tester.calculate_average_response_time()
    # 결과 데이터베이스에 저장
    c.execute("INSERT INTO result (test_id, average_response_time) VALUES (%s, %s)",
              (test_id, average_response_time))
    # 데이터베이스에 변경 사항을 커밋
    conn.commit()
    print(f"######## Average Response Time: {average_response_time} ms ######## ")

# 명령줄 인수 처리
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Load testing script parameters.')
    parser.add_argument('--url', type=str, required=True, help='Target URL for load testing')
    parser.add_argument('--initial_user_count', type=int, required=True, help='Initial number of users')
    parser.add_argument('--additional_user_count', type=int, required=True, help='Number of additional users to add periodically')
    parser.add_argument('--interval', type=int, required=True, help='Interval in seconds between adding additional users')
    parser.add_argument('--repeat_count', type=int, required=True, help='Number of times to add additional users')
    parser.add_argument('--test_id', type=int, required=True, help='Test ID')

    args = parser.parse_args()

    main(
        url=args.url,
        initial_user_count=args.initial_user_count,
        additional_user_count=args.additional_user_count,
        interval=args.interval,
        repeat_count=args.repeat_count,
        test_id=args.test_id
    )

# 데이터베이스 연결 닫기
conn.close()
