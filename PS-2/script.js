function PS2_port(button,buttonCode){
    let setCode = new Array(11);
    let breakCode = new Array(19);    
    let str = buttonCode.split('');
    let count = 0;
    setCode[0]=0;
    for(let i=8;i>=1;i--){
        setCode[i]=str[8-i];
        if(str[8-i]=="1"){
            count+=1;
        }
    }
    count % 2 == 0 ? setCode[9]= 1 : setCode[9]=0; 
    setCode[10]=1;
    console.log(setCode.toString());
    let F0Code="11110000".split('');
    for(let i = 0;i<11;i++){
        breakCode[i+8]=setCode[i];
        if(i<8){
        breakCode[i]=F0Code[i];
        }
    }
    console.log(`Код при отпускании клавиши ${breakCode}`);
    console.log(`Код при нажатии клавиши ${setCode}`);
}
let pressedButton1 = "F";
let buttonCode1 ="00101011";
PS2_port(pressedButton1,buttonCode1);
let pressedButton2 = "B";