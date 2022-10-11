import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllAssessmentresultComponent } from './all-assessmentresult.component';

describe('AllAssessmentresultComponent', () => {
  let component: AllAssessmentresultComponent;
  let fixture: ComponentFixture<AllAssessmentresultComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllAssessmentresultComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllAssessmentresultComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
