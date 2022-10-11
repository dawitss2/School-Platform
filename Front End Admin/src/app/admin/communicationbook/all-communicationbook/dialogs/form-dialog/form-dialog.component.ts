import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {CommunicationbookService } from '../../communicationbook.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder
} from '@angular/forms';
import { Communications } from '../../communicationbook.model';
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
  communications: Communications;
  
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: CommunicationbookService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     //this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.communications.Name;
      this.communications = data.communications;
    } else {
      this.dialogTitle = 'New Communication Item';
      this.communications = new Communications({});
    }
    this.stdForm = this.createContactForm();
      //disable student id
    this.stdForm.controls['CommitemID'].disable();
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
      CommitemID: [this.communications.CommitemID],
      Type: [this.communications.Type,[Validators.required, Validators.pattern('[a-zA-Z ]+')]],
      Value:[this.communications.Value,[Validators.required]],
      Catagory: [this.communications.Catagory],
    });
  }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.dialogTitle != 'New Communication Item'){
       this.stdForm.controls['CommitemID'].enable();
      let result = await this.apiService.updateComunications(this.stdForm.value)
     //console.log(result)
    }
    else
    {
     let  result= await this.apiService.addComunications(this.stdForm.value);
     //console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }

}
