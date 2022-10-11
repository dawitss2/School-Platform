import { formatDate } from '@angular/common';
export class Users {

  UserID: number;
  Name: string;
  userName:string;
  authority:string;
  constructor(users) {
    {
      this.UserID= users.UserID||'';
      this.Name = users.fname  || ''; 
      this.userName = users.userName ||'';
      this.authority = users.authority ||'';    
    }
  }
}
