import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {AssassignmentService } from '../../assassignment.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'

import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Assassignments } from '../../assassignment.model';
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
  assassignments: Assassignments;
  gr: Grade[] = [];
  subj: any[]=[];
  ass: any[]=[];
  selassesment:any;
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: AssassignmentService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;this.gr.splice(-1);});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.assassignments.Name;
      this.assassignments = data.assassignments;
      this.getSubject(data.assassignments.Grade);
      this.getAssessment()
      this.stdForm = this.createContactForm();
      //disable student id
      this.stdForm.controls['Name'].disable();
    } else {
      this.dialogTitle = 'New Assignmenment';
      this.assassignments = new Assassignments({});
      this.getAssessment()
      this.stdForm = this.createContactForm();
    }

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
      AssessmentID: [this.assassignments.AssessmentID],
      AssID: [this.assassignments.AssID],
      Name: [this.assassignments.Name,[Validators.required]],
      Grade: [this.assassignments.Grade,[Validators.required]],
      SubjectName:[this.assassignments.SubjectName,[Validators.required]]
    });
  }
  async submit() {
    // emppty stuff
    
  }
  async getSubject(selected:any){
    // console.log(selected)
    await this.apiService.getSubjectbyGrade(selected).subscribe((subjects: any[])=>{this.subj = subjects;});
    //console.log(this.subj)
  }
  async getAssessment(){
    // console.log(selected)
    await this.apiService.getAssessments().subscribe((ass: any[])=>{this.ass = ass;});
    //this.stdForm.controls['Value'].value = this.ass.filter()
    console.log(this.ass)
  }
  gelsected(selectedName)
  {
    this.selassesment = selectedName
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.dialogTitle != 'New Assignmenment'){
       //this.stdForm.controls['AssID'].enable();
      let result = await this.apiService.updateAssessmentAss(this.stdForm.value)
     console.log(result)
    }
    else
    {
     let  result= await this.apiService.addAssessmentAss(this.selassesment,this.stdForm.value);
     //console.log(this.stdForm.value)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
 
}
