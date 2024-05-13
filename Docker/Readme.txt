
FastAPI는 모던하고 빠른 (고성능) 웹 프레임워크로, Python 3.6+ 기반으로 비동기 프로그래밍을 쉽게 할 수 있게 도와줍니다. ==0.68.0은 특정 버전을 명시하여 프로젝트의 일관성과 호환성을 유지합니다.
uvicorn[standard]:

Uvicorn은 ASGI 호환 웹 서버입니다. standard는 Uvicorn이 웹소켓 등을 포함한 추가 기능을 사용할 수 있게 해주는 옵션입니다. 특정 버전 0.15.0을 지정하여 안정적인 운영 환경을 보장합니다.
gunicorn:

Gunicorn은 Python WSGI HTTP 서버로, Uvicorn과 함께 사용되어 프로덕션 환경에서의 로드 밸런싱과 더 나은 성능을 제공합니다. 버전 20.1.0을 지정합니다.
pydantic:

Pydantic은 데이터 파싱과 검증을 위한 라이브러리로, FastAPI는 내부적으로 Pydantic을 사용하여 요청 데이터를 검증하고 모델링합니다. 버전 1.8.2을 사용합니다.
