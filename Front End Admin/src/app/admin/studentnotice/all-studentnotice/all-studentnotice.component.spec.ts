import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllStudentnoticeComponent } from './all-studentnotice.component';

describe('AllStudentnoticeComponent', () => {
  let component: AllStudentnoticeComponent;
  let fixture: ComponentFixture<AllStudentnoticeComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllStudentnoticeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllStudentnoticeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
