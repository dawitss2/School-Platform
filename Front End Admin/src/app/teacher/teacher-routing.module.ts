import { Page404Component } from './../authentication/page404/page404.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard.component';

const routes: Routes = [
  {
    path: 'dashboard',
    component: DashboardComponent,
  },
  {
    path: 'calendar',
    loadChildren: () => import('./calendar/calendar.module').then((m) => m.CalendarsModule),
  },
  {
    path: 'assessmentresult',
    loadChildren: () => import('./assessmentresult/assessmentresult.module').then((m) => m.AssessmentresultModule),
  },
  {
    path: 'communicationbook',
    loadChildren: () => import('./communicationbook/communicationbook.module').then((m) => m.CommunicationbookModule),
  },
  { path: '**', component: Page404Component }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class TeacherRoutingModule {}
