from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import date, datetime
from decimal import Decimal


# ── Person ────────────────────────────────────────────────────────────────────
class PersonBase(BaseModel):
    name: str
    notes: Optional[str] = None

class PersonCreate(PersonBase):
    pass

class PersonUpdate(PersonBase):
    pass

class PersonResponse(PersonBase):
    id: int
    created_at: Optional[datetime] = None
    model_config = {"from_attributes": True}


# ── Pay Advice ─────────────────────────────────────────────────────────────────
class PayAdviceBase(BaseModel):
    person_id: Optional[int] = None
    pay_date: date
    pay_period_start: Optional[date] = None
    pay_period_end: Optional[date] = None
    notes: Optional[str] = None

    # Income
    gross: Decimal = Field(default=Decimal("0.00"), ge=0)

    # Pre-Tax Deductions
    dental_pre: Decimal = Field(default=Decimal("0.00"), ge=0)
    medical_pre: Decimal = Field(default=Decimal("0.00"), ge=0)
    retirement_plan: Decimal = Field(default=Decimal("0.00"), ge=0)
    park_permit: Decimal = Field(default=Decimal("0.00"), ge=0)

    # Taxes
    federal_taxes: Decimal = Field(default=Decimal("0.00"), ge=0)
    medicare: Decimal = Field(default=Decimal("0.00"), ge=0)
    social_security: Decimal = Field(default=Decimal("0.00"), ge=0)
    state_tax: Decimal = Field(default=Decimal("0.00"), ge=0)
    state_misc2: Decimal = Field(default=Decimal("0.00"), ge=0)

    # Post-Tax Deductions
    ltd_post: Decimal = Field(default=Decimal("0.00"), ge=0)
    vol_add_post: Decimal = Field(default=Decimal("0.00"), ge=0)
    basic_life_imputed_income: Decimal = Field(default=Decimal("0.00"), ge=0)
    imputed_famli_ee: Decimal = Field(default=Decimal("0.00"), ge=0)
    std_post: Decimal = Field(default=Decimal("0.00"), ge=0)

    # Miscellaneous
    tuition: Decimal = Field(default=Decimal("0.00"), ge=0)

    # Employer Paid Benefits
    er_retirement_401a: Decimal = Field(default=Decimal("0.00"), ge=0)
    er_basic_life_add:  Decimal = Field(default=Decimal("0.00"), ge=0)
    er_dental:          Decimal = Field(default=Decimal("0.00"), ge=0)
    er_eap:             Decimal = Field(default=Decimal("0.00"), ge=0)
    er_hsa:             Decimal = Field(default=Decimal("0.00"), ge=0)
    er_ltd:             Decimal = Field(default=Decimal("0.00"), ge=0)
    er_medical:         Decimal = Field(default=Decimal("0.00"), ge=0)
    er_std:             Decimal = Field(default=Decimal("0.00"), ge=0)
    er_other:           Decimal = Field(default=Decimal("0.00"), ge=0)


class PayAdviceCreate(PayAdviceBase):
    pass


class PayAdviceUpdate(PayAdviceBase):
    pass


class PayAdviceResponse(PayAdviceBase):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    # Person info (populated from join)
    person_name: Optional[str] = None

    # Computed — employee side
    total_pre_tax_deductions: Decimal = Decimal("0.00")
    total_taxes: Decimal = Decimal("0.00")
    total_post_tax_deductions: Decimal = Decimal("0.00")
    net_pay: Decimal = Decimal("0.00")

    # Computed — employer side
    total_employer_contributions: Decimal = Decimal("0.00")
    total_compensation: Decimal = Decimal("0.00")   # net_pay + employer contributions

    model_config = {"from_attributes": True}

    @classmethod
    def from_orm_computed(cls, obj):
        data = {c.name: getattr(obj, c.name) for c in obj.__table__.columns}
        instance = cls(**data)

        instance.total_pre_tax_deductions = (
            (obj.dental_pre or 0) + (obj.medical_pre or 0) +
            (obj.retirement_plan or 0) + (obj.park_permit or 0)
        )
        instance.total_taxes = (
            (obj.federal_taxes or 0) + (obj.medicare or 0) +
            (obj.social_security or 0) + (obj.state_tax or 0) +
            (obj.state_misc2 or 0)
        )
        instance.total_post_tax_deductions = (
            (obj.ltd_post or 0) + (obj.vol_add_post or 0) + (obj.std_post or 0)
        )
        instance.net_pay = (
            (obj.gross or 0)
            - instance.total_pre_tax_deductions
            - instance.total_taxes
            - instance.total_post_tax_deductions
            - (obj.imputed_famli_ee or 0)
            - (obj.basic_life_imputed_income or 0)
            - (obj.tuition or 0)
        )
        # Populate person name from relationship if loaded
        if hasattr(obj, 'person') and obj.person is not None:
            instance.person_name = obj.person.name

        instance.total_employer_contributions = (
            (obj.er_retirement_401a or 0) + (obj.er_basic_life_add or 0) +
            (obj.er_dental or 0) + (obj.er_eap or 0) + (obj.er_hsa or 0) +
            (obj.er_ltd or 0) + (obj.er_medical or 0) + (obj.er_std or 0) +
            (obj.er_other or 0)
        )
        instance.total_compensation = instance.net_pay + instance.total_employer_contributions
        return instance


class BudgetGoalBase(BaseModel):
    category: str
    monthly_amount: Decimal = Field(default=Decimal("0.00"), ge=0)
    notes: Optional[str] = None


class BudgetGoalCreate(BudgetGoalBase):
    pass


class BudgetGoalUpdate(BudgetGoalBase):
    pass


class BudgetGoalResponse(BudgetGoalBase):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    model_config = {"from_attributes": True}


class YearSummary(BaseModel):
    year: int
    person_id: Optional[int] = None
    person_name: Optional[str] = None
    total_gross: Decimal
    total_federal_taxes: Decimal
    total_medicare: Decimal
    total_social_security: Decimal
    total_state_tax: Decimal
    total_state_misc2: Decimal
    total_retirement_plan: Decimal
    total_dental_pre: Decimal
    total_medical_pre: Decimal
    total_park_permit: Decimal
    total_ltd_post: Decimal
    total_vol_add_post: Decimal
    total_basic_life_imputed_income: Decimal
    total_imputed_famli_ee: Decimal
    total_std_post: Decimal
    total_tuition: Decimal
    total_pre_tax_deductions: Decimal
    total_taxes: Decimal
    total_post_tax_deductions: Decimal
    total_net_pay: Decimal
    pay_count: int
    # Employer
    total_er_retirement_401a: Decimal
    total_er_basic_life_add: Decimal
    total_er_dental: Decimal
    total_er_eap: Decimal
    total_er_hsa: Decimal
    total_er_ltd: Decimal
    total_er_medical: Decimal
    total_er_std: Decimal
    total_er_other: Decimal
    total_employer_contributions: Decimal
    total_compensation: Decimal


class BankTransactionBase(BaseModel):
    person_id: Optional[int] = None
    tx_date: date
    description: str
    amount: Decimal
    balance: Optional[Decimal] = None
    account_type: str = "checking"
    bank: str = ""
    labels: List[str] = Field(default_factory=list)
    notes: Optional[str] = None


class BankTransactionCreate(BankTransactionBase):
    pass


class BankTransactionUpdate(BankTransactionBase):
    pass


class BankTransactionResponse(BankTransactionBase):
    id: int
    person_name: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    model_config = {"from_attributes": True}

    @classmethod
    def from_orm_with_person(cls, obj):
        data = {c.name: getattr(obj, c.name) for c in obj.__table__.columns}
        if isinstance(data.get("labels"), str):
            try:
                import json
                parsed = json.loads(data.get("labels") or "[]")
                data["labels"] = parsed if isinstance(parsed, list) else []
            except Exception:
                data["labels"] = []
        instance = cls(**data)
        if hasattr(obj, "person") and obj.person is not None:
            instance.person_name = obj.person.name
        return instance


class BankTransactionBulkLabelRequest(BaseModel):
    tx_ids: List[int]
    labels: List[str]
    mode: str = "add"


class TaxCalculatorInputBase(BaseModel):
    standard_deduction: Decimal = Field(default=Decimal("0.00"))
    hsa_contributions: Decimal = Field(default=Decimal("0.00"))
    investment_earnings: Decimal = Field(default=Decimal("0.00"))
    investment_withheld: Decimal = Field(default=Decimal("0.00"))
    additional_credits: Decimal = Field(default=Decimal("0.00"))
    federal_tax_before_credits: Decimal = Field(default=Decimal("0.00"))


class TaxCalculatorInputUpdate(TaxCalculatorInputBase):
    pass


class TaxCalculatorInputResponse(TaxCalculatorInputBase):
    id: Optional[int] = None
    year: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    model_config = {"from_attributes": True}
