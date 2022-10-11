import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllAssessmentresultComponent } from './all-assessmentresult/all-assessmentresult.component';


const routes: Routes = [
  {
    path: 'all-assessmentresult',
    component: AllAssessmentresultComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AssessmentresultRoutingModule {}
