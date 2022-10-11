import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllGradenoticeComponent } from './all-gradenotice/all-gradenotice.component';


const routes: Routes = [
  {
    path: 'all-gradenotice',
    component: AllGradenoticeComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class GradenoticeRoutingModule {}
