import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllStudentnoticeComponent } from './all-studentnotice/all-studentnotice.component';


const routes: Routes = [
  {
    path: 'all-studentnotice',
    component: AllStudentnoticeComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class StudentnoticeRoutingModule {}
