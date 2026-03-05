from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from ..database import get_db
from ..models import BudgetGoal
from ..schemas import BudgetGoalCreate, BudgetGoalUpdate, BudgetGoalResponse

router = APIRouter(prefix="/api/budget", tags=["Budget"])


@router.get("/", response_model=List[BudgetGoalResponse])
def list_budget_goals(db: Session = Depends(get_db)):
    return db.query(BudgetGoal).order_by(BudgetGoal.category).all()


@router.post("/", response_model=BudgetGoalResponse, status_code=201)
def create_budget_goal(payload: BudgetGoalCreate, db: Session = Depends(get_db)):
    existing = db.query(BudgetGoal).filter(BudgetGoal.category == payload.category).first()
    if existing:
        raise HTTPException(400, f"Budget goal for '{payload.category}' already exists")
    obj = BudgetGoal(**payload.model_dump())
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj


@router.put("/{goal_id}", response_model=BudgetGoalResponse)
def update_budget_goal(goal_id: int, payload: BudgetGoalUpdate, db: Session = Depends(get_db)):
    obj = db.query(BudgetGoal).filter(BudgetGoal.id == goal_id).first()
    if not obj:
        raise HTTPException(404, "Budget goal not found")
    for k, v in payload.model_dump().items():
        setattr(obj, k, v)
    db.commit()
    db.refresh(obj)
    return obj


@router.delete("/{goal_id}", status_code=204)
def delete_budget_goal(goal_id: int, db: Session = Depends(get_db)):
    obj = db.query(BudgetGoal).filter(BudgetGoal.id == goal_id).first()
    if not obj:
        raise HTTPException(404, "Budget goal not found")
    db.delete(obj)
    db.commit()
