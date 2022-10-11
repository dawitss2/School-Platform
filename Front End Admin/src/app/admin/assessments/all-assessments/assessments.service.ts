import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Assessments } from './assessments.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { UnsubscribeOnDestroyAdapter } from 'src/app/shared/UnsubscribeOnDestroyAdapter';
@Injectable()
export class AssessmentsService extends UnsubscribeOnDestroyAdapter {
  private readonly API_URL = 'http://localhost/progress_api/assesmentreception.php?all=1';
  isTblLoading = true;
  dataChange: BehaviorSubject<Assessments[]> = new BehaviorSubject<Assessments[]>([]);
  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpClient) {
    super();
  }
  get data():  Assessments[] {
    return this.dataChange.value;
  }
  getDialogData() {
    //console.log(this.dialogData)
    return this.dialogData;
  }
  /** CRUD METHODS */
  getAllStudentss(): void {
    this.subs.sink = this.httpClient.get<Assessments[]>(this.API_URL).subscribe(
      (data) => {
        this.isTblLoading = false;
        this.dataChange.next(data);
      },
      (error: HttpErrorResponse) => {
        this.isTblLoading = false;
        console.log(error.name + ' ' + error.message);
      }
    );
  }
  addStudents(assessments: Assessments): void {
    this.dialogData = assessments;

    /*  this.httpClient.post(this.API_URL, students).subscribe(data => {
      this.dialogData = students;
      },
      (err: HttpErrorResponse) => {
     // error code here
    });*/
  }
  updateStudents(assessments: Assessments): void {
    this.dialogData = assessments;

    /* this.httpClient.put(this.API_URL + students.id, students).subscribe(data => {
      this.dialogData = students;
    },
    (err: HttpErrorResponse) => {
      // error code here
    }
  );*/
  }
  deleteStudents(id: number): void {
    //console.log(id);

    /*  this.httpClient.delete(this.API_URL + id).subscribe(data => {
      console.log(id);
      },
      (err: HttpErrorResponse) => {
         // error code here
      }
    );*/
  }
}
