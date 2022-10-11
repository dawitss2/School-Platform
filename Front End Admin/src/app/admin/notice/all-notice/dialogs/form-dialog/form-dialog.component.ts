import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {NoticeService } from '../../notice.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Subjects } from '../../notice.model';
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
  subjects: Subjects;
  student: Student[] = [];
  gr: Grade[] = [];
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: NoticeService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.subjects.Name;
      this.subjects = data.subjects;
    } else {
      this.dialogTitle = 'New Subject';
      this.subjects = new Subjects({});
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['SubjectID'].disable();
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
      SubjectID: [this.subjects.SubjectID],
      Name: [this.subjects.Name,[Validators.required, Validators.pattern('[a-zA-Z ]+')]],
      GradeName:[]
    });
  }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.dialogTitle != 'New Subject'){
       this.stdForm.controls['SubjectID'].enable();
      let result = await this.apiService.updateSubject(this.stdForm.value)
     console.log(result)
    }
    else
    {
     let  result= await this.apiService.addSubject(this.stdForm.value);
     console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  async removeassign()
  {
    if(this.dialogTitle != 'New Subject') {
      this.stdForm.controls['SubjectID'].enable();
      let result = await this.apiService.deleteAssignment(this.stdForm.value)  
      console.log(result)           
      }
  }
  async assign(){
  if(this.dialogTitle != 'New Subject') {
      this.stdForm.controls['SubjectID'].enable();
      let result = await this.apiService.assignSubject(this.stdForm.value)
     //console.log(result)
    }
    else
    {
     let  result= await this.apiService.assignNewSubject(this.stdForm.value);
     //console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
}
