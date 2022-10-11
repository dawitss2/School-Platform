export interface address
{
    AddID:string;
    FathersMobile:string;
    MothersMobile:string;
    Address:string;
    KifleKetema:string;
    Woreda:string;
    HouseNum:string;
}
export interface Student {   
    StudentID: string;
    img:string;
    Name: string;
    Gender: string;
    GradeName: string;
    Section:string;
    isactive:number;
    paystart:number;
    discount:number;
    address: address;
}
