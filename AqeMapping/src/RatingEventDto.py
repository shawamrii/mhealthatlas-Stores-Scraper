from dataclasses import dataclass
import AppType
from TaxonomyClassEventDto import TaxonomyClassEventDto

@dataclass
class RatingEventDto:
  ratingId: int
  applicationVersionId: int
  applicationId: int
  applicationType: AppType
  taxonomyClass: TaxonomyClassEventDto
  questionId: int
  expertId: int
  rating: int
