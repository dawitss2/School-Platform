import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

const routes: Routes = [
  {
    path: 'students',
    loadChildren: () =>import('./students/students.module').then((m) => m.StudentsModule),
  },
  {
    path: 'dashboard',
    loadChildren: () => import('./dashboard/dashboard.module').then((m) => m.DashboardModule),
  },
   {
    path: 'subjects',
    loadChildren: () => import('./subjects/subjects.module').then((m) => m.SubjectsModule),
  },
  {
    path: 'users',
    loadChildren: () => import('./users/users.module').then((m) => m.UsersModule),
  },
  {
    path: 'assessments',
    loadChildren: () => import('./assessments/assessments.module').then((m) => m.AssessmentsModule),
  },
  {
    path: 'notice',
    loadChildren: () => import('./notice/notice.module').then((m) => m.NoticeModule),
  },
  {
    path: 'calendar',
    loadChildren: () => import('./calendar/calendar.module').then((m) => m.CalendarsModule),
  }
  ,
  {
    path: 'communicationbook',
    loadChildren: () => import('./communicationbook/communicationbook.module').then((m) => m.CommunicationbookModule),
  }
  ,
  {
    path: 'assassignment',
    loadChildren: () => import('./assassignment/assassignment.module').then((m) => m.AssassignmentModule),
  },
  {
    path: 'gradenotice',
    loadChildren: () => import('./gradenotice/gradenotice.module').then((m) => m.GradenoticeModule),
  },
  {
    path: 'studentnotice',
    loadChildren: () => import('./studentnotice/studentnotice.module').then((m) => m.StudentnoticeModule),
  },
  {
    path: 'finance',
    loadChildren: () => import('./finance/finance.module').then((m) => m.FinanceModule),
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class AdminRoutingModule {}
