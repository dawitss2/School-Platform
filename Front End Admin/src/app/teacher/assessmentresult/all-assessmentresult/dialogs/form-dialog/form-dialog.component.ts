import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Component, Inject } from '@angular/core';
import {AssessmentresultService } from '../../assessmentresult.service';
import {ConfigService} from '../../../../../config/config.service'
import {Grade} from '../../../../../interfaces/grade'
import {Student} from '../../../../../interfaces/student'
import {
  FormControl,
  Validators,
  FormGroup,
  FormBuilder,
  FormArray
} from '@angular/forms';
import { Students } from '../../assessmentresult.model';
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
  isedit:boolean = true;
  student: any[] = [];
  gr: Grade[] = [];
  section: any[] = [];
  assessments: any[] = [];
  subjects: any[] = [];
  secsel:string=''
  gsel:string = ''
  asel:string = ''
  subsel:string=''
  val:any[] = []
  enablenav:boolean = false
  constructor(
    public dialogRef: MatDialogRef<FormDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public studentsService: AssessmentresultService,
    private fb: FormBuilder,
    private apiService: ConfigService
  ) {
    //populate grade
     this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;});
  
    // Set the defaults
    this.action = data.action;
    if (this.action === 'edit') {
      this.dialogTitle = data.students.Name;
      this.student = data.students;
      console.log(this.student['GradeName'])
      this.stdForm= this.createContactFormEdit()
      this.gsel = this.student['GradeName']
      this.secsel = this.student['Section']
      this.apiService.getSectionbyGrade(this.student['GradeName']).subscribe((sections: any[])=>{this.section = sections;});
      this.apiService.getSubjectbyGrade(this.student['GradeName']).subscribe((subjects: any[])=>{this.subjects = subjects;});
      //this.addwstudentItem()
      this.stdForm.controls['GradeName'].disable();
      this.stdForm.controls['Section'].disable();
      this.isedit = false
    } else {
      this.dialogTitle = 'Enter Assessment Results';
      this.stdForm = this.createContactFormAdd();
    }
    
      //disable student id
   // this.stdForm.controls['SubjectID'].disable();
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
  loadPrev(){
    let index:number =  this.section.findIndex(sec => sec.Name === this.secsel);
    //console.log(index,this.secsel, this.section.length)
     if(index == 0)
     {
      this.secsel = this.section[this.section.length - 1].Name 
      this.getselstu(this.secsel); 
      this.Section.setValue(this.secsel)
     }
     else
     {
      this.secsel = this.section[index-1].Name
      this.getselstu(this.secsel); 
      this.Section.setValue(this.secsel)
     }
    //console.log("prev");
  }
  loadoadNext()
  {
     let index:number =  this.section.findIndex(sec => sec.Name === this.secsel);
     //console.log(index,this.secsel, this.section.length)
    if(this.section.length -1 == index)
     {
      this.secsel = this.section[0].Name    
      this.getselstu(this.secsel); 
      this.Section.setValue(this.secsel)
     }
     else
     {
      this.secsel = this.section[index+1].Name 
      this.getselstu(this.secsel); 
      this.Section.setValue(this.secsel)
     }
    //console.log("next");
  }
  createContactFormEdit(): FormGroup {
    return this.fb.group({
      GradeName: [this.student['GradeName']],
      Section: [this.student['Section']],
      Assessments:[],
      Subjects:[],
      StudentResultEdit:[this.val,[Validators.required]]
    });
  }
  createContactFormAdd(): FormGroup {
    return this.fb.group({
      GradeName: [],
      Section: [],
      Assessments:[],
      Subjects:[],
      StudentResult:new FormArray([]),
      StudentResultEdit:[]
    });
  }
  get StudentResult() {
      return this.stdForm.get('StudentResult') as FormArray;
   }
   get  StudentResultEdit() {
      return this.stdForm.get('StudentResultEdit') as FormControl;
   }
   get Section() {
      return this.stdForm.get('Section') as FormControl;
   }
   addwstudentItem()
   {
     for(let j=1;j <= this.student.length;j++)
     {
       //this.weekcommval.length = 0
       this.StudentResult.push(this.fb.control(''))
      // console.log(j)
     }
     //return this.student
   }
  async submit() {
    // emppty stuff
    
  }
  onNoClick(): void {
    this.dialogRef.close();
  }
  async confirmAdd() {
    if(this.isedit != true){
      if(this.val.length == 0)
     {let  result= await this.apiService.addAssessmentResultbyStudent(this.stdForm.value,this.student['StudentID']);
     console.log("add")}
     else
     {let  result= await this.apiService.updateAssessmentResultbyStudent(this.stdForm.value,this.student['StudentID'])
     console.log("update")}
    }
    else
    {if(this.val.length == 0)
     {let  result= await this.apiService.addAssessmentResult(this.stdForm.value);
     console.log("add")}
     else
     {let  result= await this.apiService.UpdateAssessmentResultbyGrade(this.stdForm.value)
     console.log("update")}
    }
    this.studentsService.addStudents(this.stdForm.getRawValue());
  }
  getselsubj(selected:any)
  { this.subass = ''
    this.subsel = selected
    this.getselstu(this.secsel)
    //this.addwstudentItem()
    this.apiService.getAssessmentbyGradeandSubject(this.gsel,selected).subscribe((ass: any[])=>{this.assessments = ass;});
    
  }
 async getselass(selected:any)
  {
   this.asel = selected
   //this.addwstudentItem()
   if(this.isedit == true){
   const result: any = await this.apiService.getresultvalGradeandSection(this.asel,this.gsel,this.secsel);
   //&& this.student.length == result.lenth
   this.val = result.map(t=>t.Name)
        if(this.val.length == this.StudentResult.length)
       { console.log(this.StudentResult.length, this.val.length)
         this.StudentResult.patchValue(this.val)
       }
   }
   else
   {
    const result: any = await this.apiService.getresultvalStudent(this.asel,this.student['StudentID']);
   //&& this.student.length == result.lenth
     this.val = result.map(t=>t.Name)
     console.log(this.val)
     this.StudentResultEdit.setValue(this.val)
    } 
    let filteredstu = this.assessments.filter((stu)=>(stu.AssessmentID == selected));
    console.log(filteredstu)
    this.subass = this.subsel.concat(filteredstu[0]['Name'].concat(" out of ").concat(filteredstu[0]['Value']))
  }
  async getselstu(selected:any)
  { this.val = []
    this.subass = ''
    this.enablenav = true;
    this.secsel = selected
    if(this.isedit == true){
    this.dialogTitle = this.gsel.concat(" Section ").concat(this.secsel)
    const result: any = await this.apiService.getStudentbyGradeandSection(this.gsel,selected);
    this.student = result
    this.clearformarray()
    this.addwstudentItem()
     } 
    //console.log(this.StudentResult.length)
  }
  getselsections(selected:any)
  { this.subass = ''
    this.dialogTitle = 'Enter Assessment Results';
    this.gsel = selected
    if(this.isedit == true){
    this.student = []}
    this.clearformarray()
    this.apiService.getSectionbyGrade(selected).subscribe((sections: any[])=>{this.section = sections;});
    this.apiService.getSubjectbyGrade(selected).subscribe((subjects: any[])=>{this.subjects = subjects;});
  }
  clearformarray()
  {
    while (this.StudentResult.length !== 0) {
    this.StudentResult.removeAt(0)
  }
  }
}
