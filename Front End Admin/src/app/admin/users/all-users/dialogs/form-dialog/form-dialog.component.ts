import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {UsersService } from '../../users.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Users } from '../../users.model';
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
  users: Users;
  student: Student[] = [];
  auth: any[] = ['Administrator','Teacher'];
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: UsersService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate authority
     //this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.users.Name;
      this.users = data.users;
    } else {
      this.dialogTitle = 'New Users';
      this.users = new Users({});
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['UserID'].disable();
    this.stdForm.controls['userName'].disable();
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
      UserID: [this.users.UserID],
      Name: [this.users.Name,[Validators.required, Validators.pattern('[a-zA-Z ]+')]],
      userName:[this.users.userName],
      authority:[this.users.authority,[Validators.required]]
    });
  }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.dialogTitle != 'New Users'){
       this.stdForm.controls['UserID'].enable();
      let result = await this.apiService.updateUser(this.stdForm.value)
     console.log(result)
    }
    else
    {
     let  result= await this.apiService.addUser(this.stdForm.value);
     console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
}
