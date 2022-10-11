import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllCommunicationbookComponent } from './all-communicationbook.component';

describe('AllCommunicationbookComponent', () => {
  let component: AllCommunicationbookComponent;
  let fixture: ComponentFixture<AllCommunicationbookComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllCommunicationbookComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllCommunicationbookComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
