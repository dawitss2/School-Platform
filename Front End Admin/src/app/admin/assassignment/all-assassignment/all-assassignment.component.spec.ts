import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllAssassignmentComponent } from './all-assassignment.component';

describe('AllAssassignmentComponent', () => {
  let component: AllAssassignmentComponent;
  let fixture: ComponentFixture<AllAssassignmentComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllAssassignmentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllAssassignmentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
