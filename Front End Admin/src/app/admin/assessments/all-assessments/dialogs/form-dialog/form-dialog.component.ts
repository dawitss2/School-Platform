import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {AssessmentsService } from '../../assessments.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'

import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Assessments } from '../../assessments.model';
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
  assessments: Assessments;
  
  
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: AssessmentsService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     //this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.assessments.Name;
      this.assessments = data.assessments;
    } else {
      this.dialogTitle = 'New Assessment';
      this.assessments = new Assessments({});
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['AssID'].disable();
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
      AssID: [this.assessments.AssID],
      Name: [this.assessments.Name,[Validators.required]],
      Value:[this.assessments.Value,[Validators.required,Validators.pattern('[0-9]+')]]
    });
  }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.dialogTitle != 'New Assessment'){
       this.stdForm.controls['AssID'].enable();
      let result = await this.apiService.updateAssessment(this.stdForm.value)
     console.log(result)
    }
    else
    {
     let  result= await this.apiService.addAssessment(this.stdForm.value);
     console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
 
}
