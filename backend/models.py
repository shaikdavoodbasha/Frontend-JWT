from sqlmodel import SQLModel, Field
from typing import Optional


# ==========================
# DATABASE TABLE
# ==========================

class User(SQLModel, table=True):
    __tablename__ = "users_auth"   # change table name to avoid conflicts

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    email: str = Field(index=True, unique=True)
    hashed_password: str


# ==========================
# REQUEST MODELS
# ==========================

class CreateUser(SQLModel):
    name: str
    email: str
    password: str


class LoginUser(SQLModel):
    email: str
    password: str


# ==========================
# RESPONSE MODEL
# ==========================

class Token(SQLModel):
    access_token: str
    token_type: str