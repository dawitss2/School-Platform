import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AllFinanceComponent } from './all-finance.component';

describe('AllFinanceComponent', () => {
  let component: AllFinanceComponent;
  let fixture: ComponentFixture<AllFinanceComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AllFinanceComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AllFinanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
