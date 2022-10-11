import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllAssessmentsComponent } from './all-assessments/all-assessments.component';


const routes: Routes = [
  {
    path: 'all-assessments',
    component: AllAssessmentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AssessmentsRoutingModule {}
