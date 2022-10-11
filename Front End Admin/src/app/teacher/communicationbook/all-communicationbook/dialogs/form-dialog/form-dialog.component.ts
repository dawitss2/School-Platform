import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject,ChangeDetectorRef } from '@angular/core';
import {CommunicationbookService } from '../../communicationbook.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder,
  FormArray
} from '@angular/forms';
import { Students } from '../../communicationbook.model';
import { formatDate } from '@angular/common';
@Component({
  selector: 'app-form-dialog',
  templateUrl: './form-dialog.component.html',
  styleUrls: ['./form-dialog.component.sass']
})
export class FormDialogComponent {
  action: string;
  dialogTitle: string;
  subass:string='';
  stdForm: FormGroup;
  st: Students;
  student: any[] = [];
  gr: Grade[] = [];
  werat: any[] = [];
  gsel: any='';
  ssel: string='';
  msel: string='';
  wsel:number=0;
  comtype:boolean=true // true for weekly and false for mothly
  type: any[] = ['Weekly','Monthly'];
  commVal: any[] = ['እጅግ በጣም ጥሩ','በጣም ጥሩ','ጥሩ','መሻሻል አለበት'];
  commWeekly: any[] = []
  commMonthly:any[] = []
  feedback:string =''
  weeks:any[] = []
  isedit:boolean=true;
  weekstartdate:Date = new Date();
  weekenddate:Date = new Date();
  val:any[] = []
  enablenav:boolean = false
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: CommunicationbookService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;this.gr.splice(-1);});
     
    // Set the defaults
    this.action = data.action;
    this.getseltype('Weekly')
    if (this.action == 'edit') {
      this.dialogTitle = data.students.Name;
      this.st = data.students;
      this.stdForm = this.createContactForm();
      this.stdForm.controls['GradeName'].disable();
      this.stdForm.controls['StudentName'].disable();
      this.isedit = false
      this.getselstu(this.st.StudentID)
    } else {
      this.dialogTitle = 'New Communication';
      //populate month
      this.stdForm = this.createContactForm();
      this.st = new Students({});
    }
    this.stdForm.controls['start'].disable();
    this.stdForm.controls['end'].disable();
    
    
      //disable student id
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
      Type: [this.type[0],[Validators.required]],
      GradeName: [],
      StudentName: [],
      start:[this.weekstartdate],
      end:[this.weekenddate],
      weekNO:[[Validators.required]],
      month:[[Validators.required]],
      weekcommval:new FormArray([]),
      monthcommval:new FormArray([])
    });
  }
  get weekcommval() {
      return this.stdForm.get('weekcommval') as FormArray;
   }
  get monthcommval() {
      return this.stdForm.get('monthcommval') as FormArray;
   }
   get StudentName() {
      return this.stdForm.get('StudentName') as FormControl;
   }
    loadPrev(){
    let index:number =  this.student.findIndex(stu => stu.StudentID === this.ssel);
    //console.log(index,this.ssel, this.student.length)
     if(index == 0)
     {
      this.ssel = this.student[this.student.length - 1].StudentID
      this.getselstu(this.ssel); 
      this.StudentName.setValue(this.ssel)
     }
     else
     {
      this.ssel = this.student[index-1].StudentID
      this.getselstu(this.ssel); 
      this.StudentName.setValue(this.ssel)
     }
    //console.log("prev");
  }
  loadoadNext()
  {
     let index:number =  this.student.findIndex(stu => stu.StudentID === this.ssel);
    //console.log(index,this.ssel, this.student.length)  
    if(this.student.length -1 == index)
     {
      this.ssel = this.student[0].StudentID   
      this.getselstu(this.ssel); 
      this.StudentName.setValue(this.ssel)
     }
     else
     {
      this.ssel = this.student[index+1].StudentID
      this.getselstu(this.ssel); 
      this.StudentName.setValue(this.ssel)
     }
    //console.log("next");
  }
   addweekItem()
   {
     for(let j=1;j <= this.commWeekly.length;j++)
     {
       //this.weekcommval.length = 0
       this.weekcommval.push(this.fb.control(''))
       //console.log(j)
     }
     return this.weekcommval
   }
   addmonthItem()
   {for(let j=1;j <= this.commMonthly.length;j++)
     {
       //this.weekcommval.length = 0
       this.monthcommval.push(this.fb.control(''))
       //console.log(j)
     }
     return this.monthcommval
   }
   async getselmonth(selected:any)
   {
   this.msel = selected
   let filteredstu = this.werat.filter((stu)=>(stu.MonthID == selected))
   this.subass = ' Communication for '.concat(filteredstu[0]['Name'])
    if(this.isedit == false)
    {
    const result: any =  await this.apiService.getmonthlycommval(this.st['StudentID'],this.msel);   
    this.val = result.map(t=>t.Value)
    this.monthcommval.setValue(this.val)  
    await this.apiService.getfeedbackMonth(this.st['StudentID'],this.msel).subscribe((feed:string)=>{this.feedback = feed;})
    //this.feedback = resultfeed
    console.log(this.feedback)
    }
   //console.log(this.msel)
   }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmweek() {
    if(this.isedit !=true){
      let  result = await this.apiService.updateweeklycomm(this.stdForm.value,this.st.StudentID)
      if(result != null)
     { this.dialogTitle = this.data.students.Name;
       this.dialogTitle = this.dialogTitle + " 'Saved !!' " ;
      console.log(result)}
    }
    else
    {
      let  result = await this.apiService.addweeklycomm(this.stdForm.value)
      if(result != null)
     { this.dialogTitle = this.dialogTitle + " 'Saved !!' " ;
      console.log(result)}
    }
    //this.stdForm.reset()
   // this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  async confirmmonth() {
    if(this.isedit !=true){
       this.apiService.updatemonthlycomm(this.stdForm.value,this.msel,this.st["StudentID"])
      this.dialogTitle = this.dialogTitle + " 'Saved !!' " ;
      }
    else
    {
      this.apiService.addmonthlycomm(this.stdForm.value,this.msel)
      this.dialogTitle = this.dialogTitle + " 'Saved !!' " ;
    }
   // this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  //Get all Students by 
  async getStudent(selected:any){
    this.subass =''
    // console.log(selected)
    this.gsel = selected
    await this.apiService.getStudentbyGrade(selected).subscribe((students: any[])=>{this.student = students;});
    //console.log(this.subj)
  }
  async getselstu(selected:any)
  { this.subass=''
    this.enablenav = true
    this.ssel = selected
    if(this.student.length >0){
   let filteredstu = this.student.filter((stu)=>(stu.StudentID == selected));
   this.dialogTitle = filteredstu[0]['Name']}
   //console.log(filteredstu)
    if(this.comtype==true)
    {
      if(this.isedit == false)
      {await this.apiService.getWeeklycomm(selected).subscribe((week: any[])=>{this.weeks = week;});}
      else
      {await this.apiService.getnewWeeks(selected).subscribe((week: any[])=>{this.weeks = week;});}
    }
    else
    {
      if(this.isedit == false)
      {await this.apiService.getAllMonth(2,this.st['StudentID']).subscribe((month: any[])=>{this.werat = month;});}
      else
      {await this.apiService.getAllMonth(1,selected).subscribe((month: any[])=>{this.werat = month;});}
    }
  }
  async getseltype(selected:any)
  {//console.log(this.comtype)
    this.subass =''
    this.feedback = ''
    if (selected == 'Weekly')
    {
      this.comtype = true      
      if(this.commWeekly.length == 0)
      {
         this.commWeekly = await this.apiService.getCommunicationItems(selected)
         this.addweekItem()
      }
    }
    else
    {
      this.comtype = false
      this.getselstu('monthely')
      if(this.commMonthly.length == 0)
      {
         this.commMonthly = await this.apiService.getCommunicationItems(selected)
         this.addmonthItem()
      }
    }
    console.log(this.comtype)
  }
  clear()
  {
    this.stdForm.reset()
    //[disabled]="!stdForm.valid"s
  }
  async removeassign()
  {
    if(this.isedit != true) {
      this.stdForm.controls['SubjectID'].enable();
      let result = await this.apiService.deleteAssignment(this.stdForm.value)  
      console.log(result)           
      }
  }
 async dellComm()
  {
    if (this.comtype == true)
    {
       let result = await this.apiService.dellweeklycomm(this.st['StudentID'],this.wsel)
       //this.studentsService.deleteStudents(this.st.StudentID);  
       console.log(result)   
    }
    else
    {
       let result = await this.apiService.dellmonthlycommval(this.st['StudentID'],this.msel)
       //this.studentsService.deleteStudents(this.st.StudentID);   
       console.log(result)   
    }
  }
 
  async getselweek(selected:any)
  { 
    this.subass = ' Communication for '.concat(selected.Name)
    this.stdForm.controls['start'].enable();
    this.stdForm.controls['end'].enable();     
    this.weekstartdate = selected.Start_date
    this.weekenddate = selected.End_date
    this.wsel = selected.WeekID
    this.stdForm.controls['start'].disable();
    this.stdForm.controls['end'].disable();
    if(this.isedit == false)
    {
    const result: any =  await this.apiService.getweeklycommval(this.st['StudentID'],this.wsel);   
    this.val = result.map(t=>t.Value)
    this.weekcommval.setValue(this.val)
    await this.apiService.getfeedbackWeeks(this.st['StudentID'],this.wsel).subscribe((feed:string)=>{this.feedback = feed;})
    //this.feedback = resultfeed.
    console.log(this.feedback,this.wsel)      
    }
    //console.log(this.wsel,this.weekcommval)
  }
  async assign(){
  if(this.dialogTitle != 'New Subject') {
      this.stdForm.controls['SubjectID'].enable();
      let result = await this.apiService.assignSubject(this.stdForm.value)
     //console.log(result)
    }
    else
    {
     let  result= await this.apiService.assignNewSubject(this.stdForm.value);
     //console.log(result)
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
}
