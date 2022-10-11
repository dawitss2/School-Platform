import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import { StudentsService } from '../../students.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Students } from '../../students.model';
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
    public studentsService: StudentsService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.getgrade()
     this.gr.splice(-1) 
     console.log(this.gr)
     //disable student id

    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.students.Name;
      this.students = data.students;
    } else {
      this.dialogTitle = 'New Students';
      this.students = new Students({});
    }
    this.stdForm = this.createContactForm();
    this.stdForm.controls['StudentID'].disable();
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
      StudentID: [this.students.StudentID],
      img: [this.students.img],
      Name: [this.students.Name,[Validators.required, Validators.pattern('[a-zA-Z ]+')]],
      Gender: [
        this.students.Gender,
        [Validators.required]
      ],
      GradeName: [
        this.students.GradeName,
        [Validators.required]
      ],
      Section: [this.students.Section],
      gmn1: [this.students.gmn1,[Validators.required,Validators.pattern('[0-9]+')]],
      gmn2: [this.students.gmn2, [Validators.required,Validators.pattern('[0-9]+')]],
    });
  }
  async getgrade()
  {
   await this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades; this.gr.splice(-1);});
  }
  async submit() {
    // emppty stuff
    if(this.dialogTitle != 'New Students'){
      this.stdForm.controls['StudentID'].enable();
      let result = await this.apiService.updateStudent(this.stdForm.value)
     //console.log(result)
    }
    else
    {
     let  result= await this.apiService.addStudentmini(this.stdForm.value);
     //console.log(result)
    }
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  public confirmAdd(): void {
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
}
