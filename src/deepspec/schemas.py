from typing import List, Optional
from pydantic import BaseModel, Field


class SearchQueryList(BaseModel):
    query: List[str] = Field(
        description="A list of search queries to be used for web research."
    )
    rationale: str = Field(
        description="A brief explanation of why these queries are relevant to the research topic."
    )


class AnalyzeReport(BaseModel):
    Top_Analyze: str = Field(
        description="Analyze the task's header, ports, and overall behavior"
    )
    Topic_Analyze: str = Field(
        description="Provide a structured analysis of the research topic"
    )
    Solving_Strategies: str = Field(
        description="Outline the overall reasoning strategies and methodology"
    )


class MindtraceSchema(BaseModel):
    original_text: str = Field(
        description="The original misleading or problematic text from the research topic"
    )
    misleading_rationale: str = Field(
        description="Detailed explanation of why this text is misleading, biased, or incorrect"
    )
    corrected_inference: str = Field(
        description="The accurate inference or interpretation that reveals the true information behind the chain of thought"
    )
    confidence_level: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
        description="Confidence score (0-1) indicating the certainty of the correction",
    )


class Mindtrace(BaseModel):
    mindtrace_schemas: List[MindtraceSchema] = Field(
        description="Collection of mindtrace analyses that systematically reveal and correct underlying misinformation in the chain of thought"
    )
    mindtraced_research_topic: str = Field(
        description="The research topic that has been mindtraced and corrected."
    )


class Reflection_A_feedback(BaseModel):
    atomic_information_decomposition: str = Field(
        description="Decomposed atomic information from the research topic for detailed analysis"
    )
    information_1_atomic_sets_X: List[str] = Field(
        description="First set of atomic information extracted from the mindtraced research topic"
    )
    information_2_atomic_sets_Y: List[str] = Field(
        description="Second set of atomic information extracted from the enhanced specification"
    )


class Reflection_A(BaseModel):
    feedback: Reflection_A_feedback = Field(
        description="Feedback on the research topic"
    )


class ConflictDetail(BaseModel):
    conflicting_X: Optional[str] = Field(
        default=None, description="Atomic unit from set X that is in conflict"
    )
    conflicting_Y: Optional[str] = Field(
        default=None, description="Atomic unit from set Y that conflicts with X"
    )
    conflict_type: str = Field(
        description="Type of conflict: functional / timing / logical / behavioral"
    )
    conflict_severity: str = Field(
        description="Severity of the conflict: minor / moderate / critical"
    )
    explanation: str = Field(description="Explanation of why these two units conflict")
    suggested_fix: str = Field(
        description="Suggested correction to resolve the conflict"
    )


class Reflection_B(BaseModel):
    is_consistent_B: bool = Field(
        default=True, description="Whether inconsistencies exist between X and Y"
    )
    conflicts: Optional[ConflictDetail] = Field(
        default=None,
        description="The detected severest conflicts between atomic units. If no conflict, this is null.",
    )
    intersection: list[str] = Field(description="Common atomic units between X and Y")
    union: list[str] = Field(description="Union of unique atomic units from X and Y")
    jaccard_similarity_value: float = Field(
        ge=0.0,
        le=1.0,
        description="Jaccard similarity score (0-1) quantifying overlap between X and Y",
    )
    reflectionB_feedback: str = Field(
        description="High-level corrective guidance or confirmation of consistency"
    )
