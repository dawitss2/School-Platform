import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllAssassignmentComponent } from './all-assassignment/all-assassignment.component';


const routes: Routes = [
  {
    path: 'all-assassignment',
    component: AllAssassignmentComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AssassignmentRoutingModule {}
