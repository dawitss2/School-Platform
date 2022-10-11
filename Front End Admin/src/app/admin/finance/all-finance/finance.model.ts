import { formatDate } from '@angular/common';
export class Students {
  StudentID: number;
  img: string;
  Name: string;
  Gender: string;
  GradeName: string;
  Section: string;
  SchoolFee: string;
  BusFee: string;
  constructor(students) {
    {
      this.StudentID= students.StudentID||'';
      this.img = students.img || 'assets/images/user/user1.jpg';
      this.Name = students.Name || '';
      this.Gender = students.Gender || '-';
      this.GradeName = students.GradeName||'';
      this.Section = students.Section || '-';
      this.SchoolFee = students.SchoolFee || '';
      this.BusFee= students.BusFee || '';
    }
  }
}
