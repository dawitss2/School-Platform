import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Assassignments } from './assassignment.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { UnsubscribeOnDestroyAdapter } from 'src/app/shared/UnsubscribeOnDestroyAdapter';
@Injectable()
export class AssassignmentService extends UnsubscribeOnDestroyAdapter {
  private readonly API_URL = 'http://localhost/progress_api/assesmentreception.php?all=2';
  isTblLoading = true;
  dataChange: BehaviorSubject<Assassignments[]> = new BehaviorSubject<Assassignments[]>([]);
  // Temporarily stores data from dialogs
  dialogData: any;
  constructor(private httpClient: HttpClient) {
    super();
  }
  get data():  Assassignments[] {
    return this.dataChange.value;
  }
  getDialogData() {
    //console.log(this.dialogData)
    return this.dialogData;
  }
  /** CRUD METHODS */
  getAllStudentss(): void {
    this.subs.sink = this.httpClient.get<Assassignments[]>(this.API_URL).subscribe(
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
  addStudents(assassignments: Assassignments): void {
    this.dialogData = assassignments;

    /*  this.httpClient.post(this.API_URL, students).subscribe(data => {
      this.dialogData = students;
      },
      (err: HttpErrorResponse) => {
     // error code here
    });*/
  }
  updateStudents(assassignments: Assassignments): void {
    this.dialogData = assassignments;

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
