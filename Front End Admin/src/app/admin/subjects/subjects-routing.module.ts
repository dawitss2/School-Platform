import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllSubjectsComponent } from './all-subjects/all-subjects.component';
import { AddSubjectComponent } from './add-subject/add-subject.component'
import { AboutSubjectComponent } from './about-subject/about-subject.component';

const routes: Routes = [
  {
    path: 'all-subjects',
    component: AllSubjectsComponent
  },
  {
    path: 'add-subject',
    component: AddSubjectComponent
  },
  {
    path: 'about-subject',
    component: AboutSubjectComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class StudentsRoutingModule {}
