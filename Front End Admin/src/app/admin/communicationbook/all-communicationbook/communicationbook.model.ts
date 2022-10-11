import { formatDate } from '@angular/common';
export class Communications {
  CommitemID: number;
  Type: string;
  Value:string;
  Catagory:string;
  constructor(communications) {
    {
      this.CommitemID= communications.CommitemID||'';
      this.Type = communications.Type  || ''; 
      this.Value = communications.Value ||''; 
      this.Catagory = communications.Catagory ||'';  
    }
  }
}
