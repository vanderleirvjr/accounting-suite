from sqlalchemy import Column, Integer, Numeric, Date, String, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from .database import Base


class Person(Base):
    __tablename__ = "persons"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    pay_advices = relationship("PayAdvice", back_populates="person")
    transactions = relationship("BankTransaction", back_populates="person")


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(100), nullable=False, unique=True, index=True)
    password_hash = Column(String(255), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class PayAdvice(Base):
    __tablename__ = "pay_advices"

    id = Column(Integer, primary_key=True, index=True)
    person_id = Column(Integer, ForeignKey("persons.id"), nullable=True, index=True)
    pay_date = Column(Date, nullable=False, index=True)
    pay_period_start = Column(Date, nullable=True)
    pay_period_end = Column(Date, nullable=True)
    notes = Column(Text, nullable=True)

    # Income
    gross = Column(Numeric(12, 2), nullable=False, default=0)

    # Pre-Tax Deductions
    dental_pre = Column(Numeric(12, 2), nullable=False, default=0)
    medical_pre = Column(Numeric(12, 2), nullable=False, default=0)
    retirement_plan = Column(Numeric(12, 2), nullable=False, default=0)
    park_permit = Column(Numeric(12, 2), nullable=False, default=0)

    # Taxes
    federal_taxes = Column(Numeric(12, 2), nullable=False, default=0)
    medicare = Column(Numeric(12, 2), nullable=False, default=0)
    social_security = Column(Numeric(12, 2), nullable=False, default=0)
    state_tax = Column(Numeric(12, 2), nullable=False, default=0)
    state_misc2 = Column(Numeric(12, 2), nullable=False, default=0)

    # Post-Tax Deductions
    ltd_post = Column(Numeric(12, 2), nullable=False, default=0)
    vol_add_post = Column(Numeric(12, 2), nullable=False, default=0)
    basic_life_imputed_income = Column(Numeric(12, 2), nullable=False, default=0)
    imputed_famli_ee = Column(Numeric(12, 2), nullable=False, default=0)
    std_post = Column(Numeric(12, 2), nullable=False, default=0)

    # Miscellaneous
    tuition = Column(Numeric(12, 2), nullable=False, default=0)

    # Employer Paid Benefits
    er_retirement_401a = Column(Numeric(12, 2), nullable=False, default=0)
    er_basic_life_add  = Column(Numeric(12, 2), nullable=False, default=0)
    er_dental          = Column(Numeric(12, 2), nullable=False, default=0)
    er_eap             = Column(Numeric(12, 2), nullable=False, default=0)
    er_hsa             = Column(Numeric(12, 2), nullable=False, default=0)
    er_ltd             = Column(Numeric(12, 2), nullable=False, default=0)
    er_medical         = Column(Numeric(12, 2), nullable=False, default=0)
    er_std             = Column(Numeric(12, 2), nullable=False, default=0)
    er_other           = Column(Numeric(12, 2), nullable=False, default=0)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    person = relationship("Person", back_populates="pay_advices")


class BudgetGoal(Base):
    __tablename__ = "budget_goals"

    id = Column(Integer, primary_key=True, index=True)
    category = Column(String(100), nullable=False, unique=True)
    monthly_amount = Column(Numeric(12, 2), nullable=False, default=0)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())


class BankTransaction(Base):
    __tablename__ = "bank_transactions"

    id = Column(Integer, primary_key=True, index=True)
    person_id = Column(Integer, ForeignKey("persons.id"), nullable=True, index=True)
    tx_date = Column(Date, nullable=False, index=True)
    description = Column(Text, nullable=False)
    amount = Column(Numeric(12, 2), nullable=False, default=0)
    balance = Column(Numeric(12, 2), nullable=True)
    account_type = Column(String(50), nullable=False, default="checking")
    bank = Column(String(100), nullable=False, default="")
    labels = Column(Text, nullable=False, default="[]")
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    person = relationship("Person", back_populates="transactions")
