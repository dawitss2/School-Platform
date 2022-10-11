import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllGradenoticeComponent } from './all-gradenotice.component';

describe('AllGradenoticeComponent', () => {
  let component: AllGradenoticeComponent;
  let fixture: ComponentFixture<AllGradenoticeComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllGradenoticeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllGradenoticeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
