# 사용할 베이스 이미지를 지정합니다. Python 공식 이미지를 사용합니다.
FROM python:3.9-slim

# 작업 디렉토리를 설정합니다. 모든 명령어는 이 디렉토리에서 실행됩니다.
WORKDIR /app

# main.py 파일과 requirements.txt 파일을 컨테이너의 작업 디렉토리로 복사합니다.
COPY main.py .
COPY requirements.txt .

# 필요한 Python 패키지를 설치합니다.
# requirements.txt 파일에 FastAPI와 uvicorn을 포함해 필요한 모든 패키지를 명시해야 합니다.
RUN  pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# 컨테이너가 시작할 때 실행할 명령을 지정합니다. Uvicorn으로 FastAPI 애플리케이션을 실행합니다.
CMD uvicorn main:app --host 0.0.0.0 --port 8090 --reload
