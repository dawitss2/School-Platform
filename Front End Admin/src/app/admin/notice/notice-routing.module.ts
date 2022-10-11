import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AllNoticeComponent } from './all-notice/all-notice.component';


const routes: Routes = [
  {
    path: 'all-notice',
    component: AllNoticeComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class NoticeRoutingModule {}
