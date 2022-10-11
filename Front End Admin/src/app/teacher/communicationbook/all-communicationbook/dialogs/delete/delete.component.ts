import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import { CommunicationbookService } from '../../communicationbook.service';
import {ConfigService} from '../../../../../config/config.service'

@Component({
  selector: 'app-delete',
  templateUrl: './delete.component.html',
  styleUrls: ['./delete.component.sass']
})
export class DeleteDialogComponent {
  constructor(
    public dialogRef: MatDialogRef<DeleteDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: CommunicationbookService,
    private apiService: ConfigService
  ) {}
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmDelete() {   
    let  result= await this.apiService.deleteSubject(this.data.StudentD);
    console.log(result);
    this.studentsService.deleteStudents(this.data.StudentID);
  }
}