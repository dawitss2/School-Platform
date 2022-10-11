import { formatDate } from '@angular/common';
export class Assassignments {
  AssessmentID: number;
  AssID: string;
  Name: string;
  Value: number;
  SubjectName: string;
  Grade: string;
  constructor(assassignments) {
    {
      this.AssessmentID= assassignments.AssessmentID||'';
      this.AssID= assassignments.AssID||'';
      this.Name = assassignments.Name || ''; 
      this.Value = assassignments.AssignedGrade ||'';
      this.AssID= assassignments.AssID||'';
      this.Name = assassignments.Name || ''; 
      this.Value = assassignments.AssignedGrade ||'';      
    }
  }
}
