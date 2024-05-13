from typing import Union

from fastapi import FastAPI
import mysql.connector
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

# MySQL 서버에 연결
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="0000",
    database="test"
)
cursor = conn.cursor()

# 데이터를 전송하기 위한 모델 정의
class TestData(BaseModel):
    target_url: str
    test_name: str
    user_num: int
    user_plus_num: int
    interver_time: float
    plus_count: int

# 테스트 생성
@app.post("/add_data")
async def add_data(data: TestData):
    try:
        print(data)
        # 데이터베이스에 데이터 추가
        cursor.execute(
            """
            INSERT INTO test (TARGET_URL, TEST_NAME, USER_NUM, USER_PLUS_NUM, INTERVER_TIME, PLUS_COUNT)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (data.target_url, data.test_name, data.user_num, data.user_plus_num, data.interver_time, data.plus_count)
        )
        conn.commit()
        return {"message": "Data added successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

# 테스트 삭제
@app.delete("/delete_test/{test_id}/")
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
@app.get("/testcase/{testcase_id}/execute/")
def execute_test(testcase_id: int):
    try:
        cursor.execute("SELECT * FROM test WHERE test_id = %s", (testcase_id,))
        test_data = cursor.fetchone()  # 해당 튜플을 가져옴
        if test_data:
            # 튜플이 존재할 경우 해당 데이터 반환
            test_id, target_url, test_name, user_num, user_plus_num, interver_time, plus_count = test_data
            return {
                "test_id": test_id,
                "target_url": target_url,
                "test_name": test_name,
                "user_num": user_num,
                "user_plus_num": user_plus_num,
                "intervar_time": interver_time,
                "plus_count": plus_count
            }
        else:
            # 튜플이 존재하지 않을 경우 404 에러 반환
            raise HTTPException(status_code=404, detail="Testcase no    t found")
    except Exception as e:
        # 예외 발생 시 500 에러 반환
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


# 테스트 결과값 반환
@app.get("/testcase/{testcase_id}/stats")
def stats():
    # 테스트 결과 가져오는 SQL
    return
