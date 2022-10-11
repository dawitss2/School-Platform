import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Notice } from './studentnotice.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { UnsubscribeOnDestroyAdapter } from 'src/app/shared/UnsubscribeOnDestroyAdapter';
@Injectable()
export class StudentnoticeService extends UnsubscribeOnDestroyAdapter {
  private readonly API_URL = 'http://localhost/progress_api/noticereception.php?all=1';
  isTblLoading = true;
  dataChange: BehaviorSubject<Notice[]> = new BehaviorSubject<Notice[]>([]);
  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpClient) {
    super();
  }
  get data():  Notice[] {
    return this.dataChange.value;
  }
  getDialogData() {
    //console.log(this.dialogData)
    return this.dialogData;
  }
  /** CRUD METHODS */
  getAllStudentss(): void {
    this.subs.sink = this.httpClient.get<Notice[]>(this.API_URL).subscribe(
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
  addStudents(notice: Notice): void {
    this.dialogData = notice;

    /*  this.httpClient.post(this.API_URL, students).subscribe(data => {
      this.dialogData = students;
      },
      (err: HttpErrorResponse) => {
     // error code here
    });*/
  }
  updateStudents(notice: Notice): void {
    this.dialogData = notice;

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
