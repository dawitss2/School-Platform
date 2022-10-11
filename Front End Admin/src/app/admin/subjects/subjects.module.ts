import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatDialogModule } from '@angular/material/dialog';
import { MatSortModule } from '@angular/material/sort';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MaterialFileInputModule } from 'ngx-material-file-input';
import { MatTabsModule } from '@angular/material/tabs';
import { MatMenuModule } from '@angular/material/menu';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

import { StudentsRoutingModule } from './subjects-routing.module';
import { AboutSubjectComponent } from './about-subject/about-subject.component';
import { AddSubjectComponent } from './add-subject/add-subject.component';

import { AllSubjectsComponent } from './all-subjects/all-subjects.component';
import { DeleteDialogComponent } from './all-subjects/dialogs/delete/delete.component';
import { FormDialogComponent } from './all-subjects/dialogs/form-dialog/form-dialog.component';
import { SubjectsService } from './all-subjects/subjects.service';

@NgModule({
  declarations: [
    AboutSubjectComponent,
    AddSubjectComponent,
    AllSubjectsComponent,
    DeleteDialogComponent,
    FormDialogComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatTableModule,
    MatPaginatorModule,
    MatFormFieldModule,
    MatInputModule,
    MatSnackBarModule,
    MatButtonModule,
    MatIconModule,
    MatDialogModule,
    MatSortModule,
    MatToolbarModule,
    MatSelectModule,
    MatDatepickerModule,
    MatCheckboxModule,
    MatTabsModule,
    MatMenuModule,
    MaterialFileInputModule,
    StudentsRoutingModule,
    MatProgressSpinnerModule,
  ],
  providers: [SubjectsService],
})
export class SubjectsModule {}
