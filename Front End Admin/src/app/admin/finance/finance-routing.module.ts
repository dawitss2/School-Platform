import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllFinanceComponent } from './all-finance/all-finance.component';


const routes: Routes = [
  {
    path: 'all-finance',
    component: AllFinanceComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FinanceRoutingModule {}
