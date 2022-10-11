import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllNoticeComponent } from './all-notice.component';

describe('AllNoticeComponent', () => {
  let component: AllNoticeComponent;
  let fixture: ComponentFixture<AllNoticeComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllNoticeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllNoticeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
