import { formatDate } from '@angular/common';
export class Subjects {
  SubjectID: number;
  Name: string;
  AssignedGrade:string;
  constructor(subjects) {
    {
      this.SubjectID= subjects.StudentID||'';
      this.Name = subjects.Name || ''; 
      this.AssignedGrade = subjects.AssignedGrade ||'';    
    }
  }
}
