from fastapi import FastAPI
import mysql.connector
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess

app = FastAPI()

# AWS RDS 서버에 연결
conn = mysql.connector.connect(
    host="api-database.c98wk66a2xnf.ap-northeast-1.rds.amazonaws.com",
    user="root",
    password="test1234",
    database="api"
)
cursor = conn.cursor()

# 데이터베이스 테이블 생성 함수

# 데이터를 전송하기 위한 모델 정의
class Test_Data(BaseModel):
    target_url: str
    test_name: str
    user_num: int
    user_plus_num: int
    interval_time: int
    plus_count: int

def run_load_testing_script(url, initial_user_count, additional_user_count, interval, repeat_count, test_id):
    command = [
        "python",
        "runner.py",
        "--url", url,
        "--initial_user_count", str(initial_user_count),
        "--additional_user_count", str(additional_user_count),
        "--interval", str(interval),
        "--repeat_count", str(repeat_count),
        "--test_id", str(test_id)
    ]
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")

# 테스트 생성
@app.post("/testcase/")
async def create_test(data: Test_Data):
    try:
        print(data)
        # 데이터베이스에 데이터 추가
        cursor.execute(
            """
            INSERT INTO test (target_url, test_name, user_num, user_plus_num, interval_time, plus_count)
            VALUES (%s, %s, %s, %s, %s, %s)
            """, 
            (data.target_url, data.test_name, data.user_num, data.user_plus_num, data.interval_time, data.plus_count)
        )
        conn.commit()
        return {"message": "Data added successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

# 테스트 삭제
@app.delete("/testcase/{test_id}/")
def delete_test(test_id: int):
    try:
        cursor.execute("DELETE FROM test WHERE test_id = %s", (test_id,))
        conn.commit()
        return {"message": "Test deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


# 테스트 케이스 목록 가져오기
@app.get("/testcase/")
def read_list():
    try:
        cursor.execute("SELECT test_id, test_name FROM test")  # test_id와 test_name 모두 가져오기
        test_cases = cursor.fetchall()
        test_cases = {test_id: test_name for test_id, test_name in test_cases}  # test_id와 test_name을 쌍으로 이루는 딕셔너리로 변환
        return {"test_cases": test_cases}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

# runner 실행
@app.get("/testcase/{test_id}/execute/")
def execute_test(test_id: int):
    try:
        cursor.execute("SELECT * FROM test WHERE test_id = %s", (test_id,))
        test_data = cursor.fetchone()  # 해당 튜플을 가져옴
        if test_data:
            # 튜플이 존재할 경우 해당 데이터 반환
            test_id, target_url, test_name, user_num, user_plus_num, interval_time, plus_count = test_data
            # 부하 테스트 스크립트 실행
            result = run_load_testing_script(target_url, user_num, user_plus_num, interval_time, plus_count, test_id)
            return {
                "test_id": test_id,
                "target_url": target_url,
                "test_name": test_name,
                "user_num": user_num,
                "user_plus_num": user_plus_num,
                "interval_time": interval_time,
                "plus_count": plus_count,
            }
        else:
            # 튜플이 존재하지 않을 경우 404 에러 반환
            raise HTTPException(status_code=404, detail="Testcase not found")
    except Exception as e:
        # 예외 발생 시 500 에러 반환
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


# 테스트 결과값 반환
@app.get("/testcase/{test_id}/stats/")
def stats():
    try:
        cursor.execute("SELECT * FROM result")  # test_id와 test_name 모두 가져오기
        test_cases = cursor.fetchall()
        return test_cases
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")
    return
