import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllCommunicationbookComponent } from './all-communicationbook/all-communicationbook.component';


const routes: Routes = [
  {
    path: 'all-communicationbook',
    component: AllCommunicationbookComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CommunicationbookRoutingModule {}
