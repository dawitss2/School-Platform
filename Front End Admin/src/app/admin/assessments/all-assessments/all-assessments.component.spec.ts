import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllAssessmentsComponent } from './all-assessments.component';

describe('AllAssessmentsComponent', () => {
  let component: AllAssessmentsComponent;
  let fixture: ComponentFixture<AllAssessmentsComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllAssessmentsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllAssessmentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
