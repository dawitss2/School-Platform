import { formatDate } from '@angular/common';
export class Assessments {
  AssID: number;
  Name: string;
  Value: string;
  constructor(assessments) {
    {
      this.AssID= assessments.AssID||'';
      this.Name = assessments.Name || ''; 
      this.Value = assessments.AssignedGrade ||'';    
    }
  }
}
