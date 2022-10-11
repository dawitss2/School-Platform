import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {GradenoticeService } from '../../gradenotice.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Notice } from '../../gradenotice.model';
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
  notice: Notice;
  student: Student[] = [];
  gr: Grade[] = [];
  stu: any[]=[];
  gsel: any='';
  isedit:boolean = false;
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: GradenoticeService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.notice.Title;
      this.notice = data.notice;
      this.isedit = false
    } else {
      this.dialogTitle = 'New Notification';
      this.notice = new Notice({});
      this.isedit = true
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['NotificationID'].disable();
    this.stdForm.controls['AssignedTo'].disable();
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
      NotificationID: [this.notice.NotificationID],
      Title: [this.notice.Title,[Validators.required]],
      Value:[this.notice.Value,[Validators.required]],
      Type:[this.notice.Type,[Validators.required]],
      AssignedTo:[this.notice.AssignedTo],
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
    if(this.dialogTitle != 'New Notification'){
       this.stdForm.controls['NotificationID'].enable();
      let result = await this.apiService.updateNotice(this.stdForm.value)
     console.log(result)
    }
    else
    {
     if(this.gsel != '')
      {
        let  result= await this.apiService.addNoticewithAssignment(this.stdForm.value,'student');
         console.log(result)
      }  
      else
      {
        let  result= await this.apiService.addNotice(this.stdForm.value);
         console.log(result)
      } 
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  async removeassign()
  { if(this.gsel != '' ){
    this.stdForm.controls['NotificationID'].enable();
    let  result= await this.apiService.removeAssignedGradeNotice(this.stdForm.value);
     console.log(result)
    this.studentsService.deleteStudents(this.stdForm.getRawValue());}
  }
   async getStudent(selected:any){
    // console.log(selected)
    this.gsel = selected
    await this.apiService.getStudentbyGrade(selected).subscribe((students: any[])=>{this.stu = students;});
    //console.log(this.subj)
  }
  
  async assign(){
    if(this.gsel != ''){
    this.stdForm.controls['NotificationID'].enable();
     let  result= await this.apiService.assignGradeNotice(this.stdForm.value);
     console.log(result)
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  }
}
