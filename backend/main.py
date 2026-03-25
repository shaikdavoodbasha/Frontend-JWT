# from fastapi import FastAPI, Depends, HTTPException, status
# from sqlmodel import SQLModel, create_engine, Session, select
# from contextlib import asynccontextmanager
# from typing import Annotated
# from passlib.context import CryptContext
# from models import User, CreateUser, Token
# from jose import JWTError, jwt
# from datetime import datetime, timedelta, timezone
# from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

# # ==============================
# # DATABASE CONFIG
# # ==============================

# DATABASE_URL = "mysql+pymysql://root:davood8888@localhost/flutter_auth"

# engine = create_engine(
#     DATABASE_URL,
#     echo=True
# )

# # ==============================
# # CREATE TABLES ON STARTUP
# # ==============================

# @asynccontextmanager
# async def lifespan(app: FastAPI):
#     SQLModel.metadata.create_all(engine)
#     yield

# app = FastAPI(lifespan=lifespan)

# # ==============================
# # DATABASE SESSION
# # ==============================

# def get_session():
#     with Session(engine) as session:
#         yield session

# SessionDep = Annotated[Session, Depends(get_session)]

# # ==============================
# # AUTH CONFIG
# # ==============================

# SECRET_KEY = "supersecretkey_change_this"
# ALGORITHM = "HS256"
# ACCESS_TOKEN_EXPIRE_MINUTES = 30

# oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# # ==============================
# # PASSWORD HASHING
# # ==============================

# pwd_context = CryptContext(
#     schemes=["bcrypt"],
#     deprecated="auto"
# )

# def hash_password(password: str):
#     return pwd_context.hash(password)

# def verify_password(plain: str, hashed: str):
#     return pwd_context.verify(plain, hashed)

# # ==============================
# # JWT TOKEN CREATION
# # ==============================

# def create_access_token(data: dict, expires_delta: timedelta | None = None):

#     to_encode = data.copy()

#     expire = datetime.now(timezone.utc) + (
#         expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#     )

#     to_encode.update({"exp": expire})

#     encoded_jwt = jwt.encode(
#         to_encode,
#         SECRET_KEY,
#         algorithm=ALGORITHM
#     )

#     return encoded_jwt

# # ==============================
# # VERIFY TOKEN
# # ==============================

# def verify_token(token: str):

#     try:
#         payload = jwt.decode(
#             token,
#             SECRET_KEY,
#             algorithms=[ALGORITHM]
#         )

#         return payload

#     except JWTError:
#         return None

# # ==============================
# # GET CURRENT USER
# # ==============================

# def get_current_user(
#     token: Annotated[str, Depends(oauth2_scheme)],
#     session: SessionDep
# ):

#     payload = verify_token(token)

#     if not payload:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail="Invalid token"
#         )

#     email = payload.get("sub")

#     if email is None:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail="Invalid token payload"
#         )

#     user = session.exec(
#         select(User).where(User.email == email)
#     ).first()

#     if not user:
#         raise HTTPException(
#             status_code=status.HTTP_404_NOT_FOUND,
#             detail="User not found"
#         )

#     return user

# # ==============================
# # ROOT ROUTE
# # ==============================

# @app.get("/")
# def home():
#     return {"message": "FastAPI JWT backend running"}

# # ==============================
# # REGISTER
# # ==============================

# @app.post("/register")
# def register(
#     user_data: CreateUser,
#     session: SessionDep
# ):

#     existing_user = session.exec(
#         select(User).where(User.email == user_data.email)
#     ).first()

#     if existing_user:
#         raise HTTPException(
#             status_code=400,
#             detail="Email already registered"
#         )

#     hashed_pwd = hash_password(user_data.password)

#     user = User(
#         name=user_data.name,
#         email=user_data.email,
#         hashed_password=hashed_pwd
#     )

#     session.add(user)
#     session.commit()
#     session.refresh(user)

#     return {"message": "User registered successfully"}

# # ==============================
# # LOGIN
# # ==============================

# @app.post("/login", response_model=Token)
# def login(
#     session: SessionDep,
#     form_data: Annotated[OAuth2PasswordRequestForm, Depends()]
# ):

#     user = session.exec(
#         select(User).where(User.email == form_data.username)
#     ).first()

#     if not user:
#         raise HTTPException(
#             status_code=400,
#             detail="Invalid credentials"
#         )

#     if not verify_password(form_data.password, user.hashed_password):
#         raise HTTPException(
#             status_code=400,
#             detail="Invalid credentials"
#         )

#     token = create_access_token(
#         data={"sub": user.email}
#     )

#     return {
#         "access_token": token,
#         "token_type": "bearer"
#     }

# # ==============================
# # PROTECTED ROUTE
# # ==============================

# @app.get("/profile")
# def profile(
#     current_user: Annotated[User, Depends(get_current_user)]
# ):

#     return {
#         "name": current_user.name,
#         "email": current_user.email
#     }