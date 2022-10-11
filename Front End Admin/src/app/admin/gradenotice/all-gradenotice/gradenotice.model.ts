import { formatDate } from '@angular/common';
export class Notice {
  NotificationID: number;
  Title: string;
  Value:string;
  Type: string;
  AssignedTo:string;
  constructor(notice) {
    {     
      this.NotificationID= notice.NotificationID||'';
      this.Title = notice.Title || ''; 
      this.Value = notice.Value ||'';
      this.Type = notice.Type || ''; 
      this.AssignedTo = notice.AssignedTo ||'';    
    }
  }
}