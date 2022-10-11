import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AboutSubjectComponent } from './about-subject.component';

describe('AboutSubjectComponent', () => {
  let component: AboutSubjectComponent;
  let fixture: ComponentFixture<AboutSubjectComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [AboutSubjectComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AboutSubjectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
