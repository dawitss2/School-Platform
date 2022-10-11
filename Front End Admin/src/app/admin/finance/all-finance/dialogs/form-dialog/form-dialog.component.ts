import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import { FinanceService } from '../../finance.service';
import { ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Students } from '../../finance.model';
import { formatDate } from '@angular/common';
@Component({
  selector: 'app-form-dialog',
  templateUrl: './form-dialog.component.html',
  styleUrls: ['./form-dialog.component.sass']
})
export class FormDialogComponent {
  action: string;
  dialogTitle: string;
  stdForm: FormGroup;
  students: Students;
  student: Student[] = [];
  gr: Grade[] = [];
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: FinanceService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     //this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.students.Name;
      this.students = data.students;
    } else {
      this.dialogTitle = data.students.Name;
      this.students = new Students({});
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['StudentName'].disable();
  }
  formControl = new FormControl('', [
    Validators.required
  ]);
  getErrorMessage() {
    return this.formControl.hasError('required')
      ? 'Required field'
      : this.formControl.hasError('email')
      ? 'Not a valid email'
      : '';
  }
  createContactForm(): FormGroup {
    return this.fb.group({
      StudentName: [this.students.StudentID],
      Title:['Payment Notice',[Validators.required]],
      Value:['This is a Reminder for Payment of School Fee for the month of [....]',[Validators.required]],
      Type:['Late Fee',[Validators.required]],
    });
  }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
       this.stdForm.controls['StudentName'].enable();
      let result = await this.apiService.addNoticewithAssignment(this.stdForm.value,'student')
     console.log(result)
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  
}
