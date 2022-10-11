import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl} from '@angular/forms';
import {ConfigService} from '../../../config/config.service'
import {Student} from '../../../interfaces/student'
import {Grade} from '../../../interfaces/grade'
@Component({
  selector: 'app-add-student',
  templateUrl: './add-student.component.html',
  styleUrls: ['./add-student.component.sass']
})
export class AddStudentComponent {
  stdForm: FormGroup;
  gr: Grade[] = [];
  student: Student[] = [];
  //imgFile: File;
  file=new FormControl('')
  file_data:any=''
  fd = new FormData();
  isShown: boolean = false ;
   
  constructor(private fb: FormBuilder,private apiService: ConfigService) {
    this.apiService.getAllGrade().subscribe((grades: Grade[])=>{this.gr = grades;this.gr.splice(-1);});
    //console.log('Form Value',this.gr);
    //console.log('Form Value',this.grade['Name']);
    this.stdForm = this.fb.group({
      sname: ['', [Validators.required, Validators.pattern('[a-zA-Z]+')]],
      fname: ['', [Validators.required, Validators.pattern('[a-zA-Z]+')]],
      gfname: ['', [Validators.required, Validators.pattern('[a-zA-Z]+')]],
      gender: ['', [Validators.required]],
      gmn1: ['', [Validators.required,Validators.pattern('[0-9]+')]],
      gmn2: ['', [Validators.required],,Validators.pattern('[0-9]+')],
      grade: ['', [Validators.required]],
      section: ['',[Validators.required]],
      address: ['', [Validators.required]],
      kifleketema: ['',[Validators.required]],
      woreda: ['', [Validators.required]],
      housenum: ['',[Validators.required]],
      uploadImg: ['']
    });
  }
  
    fileChange(event) { 
    const fileList: FileList = event.target.files;
    //check whether file is selected or not
    if (fileList.length > 0) {

        const file = fileList[0];
        //get file information such as name, size and type
        console.log('finfo',file.name,file.size,file.type);
        //max file size is 4 mb
        if((file.size/1048576)<=4)
        {
          let formData = new FormData();
          let info={id:2,name:'uploadImg'}
          formData.append('uploadImg', file, file.name);
          formData.append('id','2');
          formData.append('tz',new Date().toISOString());
          formData.append('update','2');
          formData.append('info',JSON.stringify(info));
          this.fd = formData;        
        }else{
          //this.snackBar.open('File size exceeds 4 MB. Please choose less than 4 MB','',{duration: 2000});
        }
        
    }

  }
  manageallert($event)
  {
    this.isShown = false;
   // alert(this.isShown)
  }
  
   async onSubmit() {
    this.student = await this.apiService.addStudents(this.stdForm.value);
    //console.log(this.student[0].StudentID ;
    if(this.student.length != 0 && this.stdForm.value['uploadImg'] != '')
     {
      this.fd.append('sid',this.student[0].StudentID)
      this.file_data = this.fd
      //console.log(this.fd)
      this.apiService.upload(this.file_data);
     }
     this.stdForm.reset();
     if(this.student.length != 0){
       this.isShown = true;
     }
    //console.log('Form Value',this.student);
  }
}
