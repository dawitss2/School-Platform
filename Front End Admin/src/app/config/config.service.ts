import { Injectable } from '@angular/core';
import { InConfiguration } from '../core/models/config.interface';
import { HttpClient,HttpParams } from '@angular/common/http';            
import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import {Subject } from '../interfaces/subject';
import {Student } from '../interfaces/student';
import {Grade} from '../interfaces/grade';

@Injectable({
  providedIn: 'root',
})


export class ConfigService {
  public configData: InConfiguration;
  PHP_API_SERVER = "http://localhost/progress_api";
  student: Student[] ;
  commdata:String = ""
  constructor(private http: HttpClient) {
    this.setConfigData();
  }

  //getAllSubjects(): Observable<Subject[]> {
  //return this.http.get<Subject[]>(`${this.PHP_API_SERVER}subjectreception.php`);
   //}
   getAllGrade(): Observable<Grade[]> {
  return this.http.get<Grade[]>(`${this.PHP_API_SERVER}/gradereception.php`);
  }
  getAllMonth(type:any,sid:any): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/etcalmonthreception.php?all=${type}&sid=${sid}`);
  }
  getSubjectbyGrade(grade:any): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/subjectreception.php?grd=${grade}`);
  }
  getStudentbyGrade(grade:any): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/studentreception.php?grd=${grade}`);
  }
  getStudentbyGradeandSection(grade:any,section:any){
    //console.log(grade,section)
  return this.http.get(`${this.PHP_API_SERVER}/studentreception.php?grdsec=1&grd=${grade}&sec=${section}`).toPromise();
  }
  getSectionbyGrade(grade:any): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/studentreception.php?sec=${grade}`);
  }
  getAssessments(): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/assesmentreception.php?all=1`);
  }
  addStudents(student:any){
     //console.log('Form Value',student)
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/studentreception.php?add=1&sname=${student['sname']}&fname=${student['fname']}&gfname=${student['gfname']}&gen=${student['gender']}&gname=${student['grade']}&section=${student['section']}&fmob=${student['gmn1']}&mmob=${student['gmn2']}&add=${student['address']}&kk=${student['kifleketema']}&wor=${student['woreda']}&hno=${student['housenum']}`).toPromise()
   }  
  addStudentmini(student:any){
     //console.log('Form Value',student)
   let word = String(student['Name']).split(" ")
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/studentreception.php?add=2&sname=${word[0]}&fname=${word[1]}&gfname=${word[2]}&gen=${student['Gender']}&gname=${student['GradeName']}&section=${student['Section']}&fmob=${student['gmn1']}&mmob=${student['gmn2']}`).toPromise()
   }
   updateStudent(student:any){
    console.log('Form Value',student)
   let word = String(student['Name']).split(" ")
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/studentreception.php?update=1&sid=${student['StudentID']}&sname=${word[0]}&fname=${word[1]}&gfname=${word[2]}&gen=${student['Gender']}&gname=${student['GradeName']}&section=${student['Section']}&fmob=${student['gmn1']}&mmob=${student['gmn2']}`).toPromise()
   }
   deleteStudent(student:any){
    console.log('Form Value',student)
   //let word = String(student['Name']).split(" ")
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/studentreception.php?remove=1&sid=${student}`).toPromise()
   }
   upload(img:any){
   // console.log(img);
    this.http.post(`${this.PHP_API_SERVER}/file-upload.php`,img)
      .subscribe(response => {
        //alert('Image has been uploaded.');assignSubject
      })
  }
  addSubject(subject:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID
  return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   updateSubject(subject:any){
     //console.log('Form Value',subject)// $Name,$grade,$type,$SubjID
    // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}`).toPromise()
  return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?update=1&name=${subject['Name']}&subjid=${subject['SubjectID']}`).toPromise()
   } 
   assignSubject(subject:any){
     //console.log('Form Value',subject)// $Name,$grade,$type,$SubjID
    // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}`).toPromise()
  return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?update=2&name=${subject['Name']}&grade=${subject['GradeName']}&type=1&subjid=${subject['SubjectID']}`).toPromise()
   }
   assignNewSubject(subject:any){
     //console.log('Form Value',subject)// $Name,$grade,$type,$SubjID
    // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}`).toPromise()
  return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=2&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   }
   deleteSubject(subject:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/subjectreception.php?remove=1&subjid=${subject}`).toPromise()
   }
   deleteAssignment(subject:any){
    console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<Student[]>(`${this.PHP_API_SERVER}/subjectreception.php?remove=2&subjid=${subject['SubjectID']}&grade=${subject['GradeName']}`).toPromise()
   }
   //User API
   addUser(user:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID
     let word = String(user['Name']).split(" ")
     let auth = 0
     if (user['authority']=='Administrator')
     {
        auth = 1;
     }
     else
     {
        auth = 0;
     }
  return this.http.get<any>(`${this.PHP_API_SERVER}/userreception.php?add=1&fname=${word[0]}&lname=${word[1]}&auth=${auth}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   updateUser(user:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
     let word = String(user['Name']).split(" ")
     let auth = 0
     if (user['authority']=='Administrator')
     {
        auth = 1;
     }
     else
     {
        auth = 0;
     }
  return this.http.get<any>(`${this.PHP_API_SERVER}/userreception.php?update=1&fname=${word[0]}&lname=${word[1]}&auth=${auth}&uid=${user['UserID']}`).toPromise()
   } 
    deleteUser(user:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/userreception.php?remove=1&uid=${user}`).toPromise()
   }
   //assment API
   getAssessmentbyGradeandSubject(grade:any,subject:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID     
  return this.http.get<any>(`${this.PHP_API_SERVER}/assesmentreception.php?fill=1&grade=${grade}&subject=${subject}`)
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   }
   addAssessment(assessment:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID     
  return this.http.get<any>(`${this.PHP_API_SERVER}/assesmentreception.php?add=1&name=${assessment['Name']}&value=${assessment['Value']}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   updateAssessment(assessment:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
   
  return this.http.get<any>(`${this.PHP_API_SERVER}/assesmentreception.php?update=1&name=${assessment['Name']}&value=${assessment['Value']}&assid=${assessment['AssID']}`).toPromise()
   } 
    deleteAssessment(assessment:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/assesmentreception.php?remove=1&assid=${assessment}`).toPromise()
   }
   //assessment assignment API
   addAssessmentAss(assid,assessment:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID     
  return this.http.get<any>(`${this.PHP_API_SERVER}/assesmentreception.php?add=2&assid=${assid}&grade=${assessment['Grade']}&subject=${assessment['SubjectName']}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   updateAssessmentAss(assessment:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
   
  return this.http.get<any>(`${this.PHP_API_SERVER}/assesmentreception.php?update=2&assid=${assessment['AssessmentID']}&grade=${assessment['Grade']}&subject=${assessment['SubjectName']}`).toPromise()
   } 
    deleteAssessmentAss(assessment:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/assesmentreception.php?remove=2&assid=${assessment}`).toPromise()
   }
   //Comunications API
    addComunications(communication:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID     
  return this.http.get<any>(`${this.PHP_API_SERVER}/communicationsreception.php?add=1&type=${communication['Type']}&value=${communication['Value']}&catagory=${communication['Catagory']}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   updateComunications(communication:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
   
  return this.http.get<any>(`${this.PHP_API_SERVER}/communicationsreception.php?update=1&cid=${communication['CommitemID']}&type=${communication['Type']}&value=${communication['Value']}&catagory=${communication['Catagory']}`).toPromise()
   } 
    deleteComunications(communication:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/communicationsreception.php?remove=1&cid=${communication}`).toPromise()
   }
   //Notice API
    addNotice(notice:any){
     //console.log('Form Value',student) $Name,$grade,$type,$SubjID     
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?add=1&title=${notice['Title']}&value=${notice['Value']}&type=${notice['Type']}`).toPromise()
  // return this.http.get<any>(`${this.PHP_API_SERVER}/subjectreception.php?add=1&name=${subject['Name']}&grade=${subject['GradeName']}&type=0&subjid=${subject['SubjectID']}`).toPromise()
   } 
   addNoticewithAssignment(notice:any,assignto:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
   if(assignto == 'grade')
   {
     return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?add=2&title=${notice['Title']}&value=${notice['Value']}&type=${notice['type']}&grade=${notice['GradeName']}`).toPromise()
   }
   else
    {
      //let word = String(ssel).split(" ")
      //console.log(ssel,word)
      return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?add=2&title=${notice['Title']}&value=${notice['Value']}&type=${notice['Type']}&sid=${notice['StudentName']}`).toPromise()
    }
   } 
  updateNotice(notice:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID  
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?update=1&title=${notice['Title']}&value=${notice['Value']}&type=${notice['Type']}&nid=${notice['NotificationID']}`).toPromise()
   }
  assignStudentNotice(notice:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID 
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?assign=1&nid=${notice['NotificationID']}&sid=${notice['StudentName']}`).toPromise()
   }
  removeAssignedStudentNotice(notice:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID 
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?remove=2&nid=${notice['NotificationID']}&sid=${notice['StudentName']}`).toPromise()
   }
  assignGradeNotice(notice:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID 
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?assign=1&nid=${notice['NotificationID']}&grade=${notice['GradeName']}`).toPromise()
   }
  removeAssignedGradeNotice(notice:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID 
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?remove=2&nid=${notice['NotificationID']}&grade=${notice['GradeName']}`).toPromise()
   }
   deleteNotice(notice:any){
    //console.log('Form Value',subject)
   //let word = String(student['Name']).split(" ")
  return this.http.get<any>(`${this.PHP_API_SERVER}/noticereception.php?remove=1&nid=${notice}`).toPromise()
   }
   //get communication
   getCommunicationItems(type:any){
     ///console.log('Form Value',student) $Name,$grade,$type,$SubjID
     return this.http.get<any[]>(`${this.PHP_API_SERVER}/communicationsreception.php?type=${type}`).toPromise()
   }
   // Comm weekly Comm API
  addmonthlycomm(communication:any,month:any) {
    this.commdata = ""
  const params = new HttpParams()
      .set('sid', communication['StudentName'])
      .set('month',month)
      .set('add','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < communication['monthcommval'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(communication['monthcommval'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   communication = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/communicationsmonthlyreception.php`,communication,{'params':params,'headers':headers}).toPromise(); 
  }
  addweeklycomm(communication:any) {
    // console.log(communication)
    this.commdata = ""
    const params = new HttpParams()
      .set('sid', communication['StudentName'])
      .set('week',communication['weekNO'].WeekID)
      .set('add','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < communication['weekcommval'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(communication['weekcommval'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   communication = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/communicationsweeklyreception.php`,communication,{'params':params,'headers':headers}).toPromise();  
  }
 updatemonthlycomm(communication:any,month:any,sid :any) {
   this.commdata = ""
   const params = new HttpParams()
      .set('sid', sid)
      .set('month',month)
      .set('update','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < communication['monthcommval'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(communication['monthcommval'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   communication = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/communicationsmonthlyreception.php`,communication,{'params':params,'headers':headers}).toPromise(); 
  }
 updateweeklycomm(communication:any,sid :any) {
   this.commdata = ""
   const params = new HttpParams()
      .set('sid', sid)
      .set('week',communication['weekNO'].WeekID)
      .set('update','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < communication['weekcommval'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(communication['weekcommval'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   communication = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/communicationsweeklyreception.php`,communication,{'params':params,'headers':headers}).toPromise();   
  }
  getnewWeeks(sid:any): Observable<any[]> {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/communicationsweeklyreception.php?all=1&sid=${sid}`);
  }
  getWeeklycomm(sid:any): Observable<any[]>
  {
  return this.http.get<any[]>(`${this.PHP_API_SERVER}/communicationsweeklyreception.php?all=2&sid=${sid}`);
  }
  getweeklycommval(sid:any,week: any){
  return this.http.get(`${this.PHP_API_SERVER}/communicationsweeklyreception.php?comm=2&sid=${sid}&week=${week}`).toPromise();
  }
  getmonthlycommval(sid:any,month: any){
  return this.http.get(`${this.PHP_API_SERVER}/communicationsmonthlyreception.php?comm=2&sid=${sid}&month=${month}`).toPromise();
  }
  dellweeklycomm(sid:any,week:any)
  {
    //console.log("this is happening")
  return this.http.get(`${this.PHP_API_SERVER}/communicationsweeklyreception.php?remove=1&sid=${sid}&week=${week}`).toPromise();
  }
  dellmonthlycommval(sid:any,month: any){
  return this.http.get(`${this.PHP_API_SERVER}/communicationsmonthlyreception.php?remove=1&sid=${sid}&month=${month}`).toPromise();
  }
  //Result API
   addAssessmentResult(assessment:any) {
   this.commdata = ""
   const params = new HttpParams()
      .set('aid', assessment['Assessments'])
      .set('gname', assessment['GradeName'])
      .set('section', assessment['Section'])
      .set('addres','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < assessment['StudentResult'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(assessment['StudentResult'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   assessment = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/assesmentreception.php`,assessment,{'params':params,'headers':headers}).toPromise();   
  }
   UpdateAssessmentResultbyGrade(assessment:any) {
   this.commdata = ""
   const params = new HttpParams()
      .set('aid', assessment['Assessments'])
      .set('gname', assessment['GradeName'])
      .set('section', assessment['Section'])
      .set('updateres','1');
      this.commdata = this.commdata.concat('{')
      for(let j=0;j < assessment['StudentResult'].length;j++)
      {this.commdata = this.commdata.concat('"val'.concat(String(j+1).concat('":"').concat(assessment['StudentResult'][j]).concat('",')))
      }
      this.commdata = this.commdata.substring(0,this.commdata.length-1)
      this.commdata = this.commdata.concat('}')
      console.log(JSON.parse(JSON.stringify(this.commdata)))
   const headers = { 'content-type': 'application/json'} 
   assessment = JSON.parse(JSON.stringify(this.commdata))
   return this.http.post<any[]>(`${this.PHP_API_SERVER}/assesmentreception.php`,assessment,{'params':params,'headers':headers}).toPromise();   
  }
  updateAssessmentResultbyStudent(assessment:any,sid) { 
   return this.http.get(`${this.PHP_API_SERVER}/assesmentreception.php?stuval=2&aid=${assessment['Assessments']}&sid=${sid}&value=${assessment['StudentResultEdit']}`).toPromise();   
  }
  addAssessmentResultbyStudent(assessment:any,sid) { 
   return this.http.get(`${this.PHP_API_SERVER}/assesmentreception.php?stuval=1&aid=${assessment['Assessments']}&sid=${sid}&value=${assessment['StudentResultEdit']}`).toPromise();   
  }
  getresultvalGradeandSection(assessment:any,grade: any,section:any){
  return this.http.get(`${this.PHP_API_SERVER}/assesmentreception.php?val=1&aid=${assessment}&grade=${grade}&section=${section}`).toPromise();
  }
  getresultvalStudent(assessment:any,sid:any){
  return this.http.get(`${this.PHP_API_SERVER}/assesmentreception.php?val=2&aid=${assessment}&sid=${sid}`).toPromise();
  }
  //feedback api call
  getfeedbackWeeks(sid:any,wid:any) {
  return this.http.get(`${this.PHP_API_SERVER}/feedbackreception.php?get=2&sid=${sid}&wid=${wid}`);
  }
  getfeedbackMonth(sid:any,mid:any)
  {
  return this.http.get(`${this.PHP_API_SERVER}/feedbackreception.php?get=1&sid=${sid}&mid=${mid}`);
  }

    setConfigData() {
    this.configData = {
      layout: {
        rtl: false, // options:  true & false
        variant: 'light', // options:  light & dark
        theme_color: 'white', // options:  white, black, purple, blue, cyan, green, orange
        logo_bg_color: 'white', // options:  white, black, purple, blue, cyan, green, orange
        sidebar: {
          collapsed: false, // options:  true & false
          backgroundColor: 'light', // options:  light & dark
        },
      },
    };
  }
}
