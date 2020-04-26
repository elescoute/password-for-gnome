
const char base64_url_alphabet[] = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

string passwordQMask;

string mdpCalcul(string mot1, string mot2, bool mask, int hash, bool conversion, int length, string saltString, bool remLower, bool remUpper, bool remNum, bool remSpec) {


    string output = "";


    if(mot1!="" && mot2!=""){

        string mot=mot1+mot2+saltString;
        string result = "";

        if(hash==0) result = GLib.Checksum.compute_for_string (ChecksumType.MD5, mot);
        if(hash==1) result = GLib.Checksum.compute_for_string (ChecksumType.SHA1, mot);
        if(hash==2) result = GLib.Checksum.compute_for_string (ChecksumType.SHA256, mot);
        if(hash==3) result = GLib.Checksum.compute_for_string (ChecksumType.SHA384, mot);
        if(hash==4) result = GLib.Checksum.compute_for_string (ChecksumType.SHA512, mot);
        if(hash==5) result = GLib.Hmac.compute_for_string (ChecksumType.MD5, {} , mot);
        if(hash==6) result = GLib.Hmac.compute_for_string (ChecksumType.SHA1, {} , mot);
        if(hash==7) result = GLib.Hmac.compute_for_string (ChecksumType.SHA256, {} , mot);
        if(hash==8) result = GLib.Hmac.compute_for_string (ChecksumType.SHA384, {} , mot);
        if(hash==9) result = GLib.Hmac.compute_for_string (ChecksumType.SHA512, {} , mot);

        //CONVERSION HEXA -> ASCII

        string newString = "";

        if(conversion){
            for(int i=0; i< result.length; i+=2){
                string byte = result.substring(i,2);
                char chr = (char) (int)long.parse(byte,16);
                //char chr = (char) (int) byte.to_long(null,16); //DEPRECATED
                newString+=chr.to_string ();
            }}
        else {
            newString = result;
        }

        //ENCODAGE BASE 64

        string passwordLong = GLib.Base64.encode(newString.data);

        passwordCourt = passwordLong.substring(0,length);

        //REMOVE NUMERIC

        if(remNum) {
            passwordCourt = passwordCourt.replace("0", "+");
            passwordCourt = passwordCourt.replace("1", "/");
            passwordCourt = passwordCourt.replace("2", "=");
            passwordCourt = passwordCourt.replace("3", "A");
            passwordCourt = passwordCourt.replace("4", "B");
            passwordCourt = passwordCourt.replace("5", "C");
            passwordCourt = passwordCourt.replace("6", "D");
            passwordCourt = passwordCourt.replace("7", "E");
            passwordCourt = passwordCourt.replace("8", "F");
            passwordCourt = passwordCourt.replace("9", "G");
        }

        //REMOVE SPECIAL

        if(remSpec) {
            passwordCourt = passwordCourt.replace("+", "A");
            passwordCourt = passwordCourt.replace("/", "B");
            passwordCourt = passwordCourt.replace("=", "B");
        }

        //REMOVE LOWER

        if(remLower) passwordCourt = passwordCourt.ascii_down();

        //REMOVE UPPER

        if(remUpper) passwordCourt = passwordCourt.ascii_up();

        //CREATION QSTRING AVEC POINTS

        passwordQMask = "";


        int nbMask=1;
        if(length>7) nbMask=2;
        if(length>10) nbMask=3;
        for(int i=0; i<length; i++){
            if(i<nbMask || i>=length-nbMask){
                passwordQMask += passwordCourt.substring(i,1);
            }
            else{
                passwordQMask += "\u25CF";
            }
        }

        if(!mask) output = passwordQMask;
        if(mask) output = passwordCourt;
    }

    return output;
}


string calculMask(bool mask){

    string output = "";

    if(!mask) output = passwordQMask;
    if(mask) output = passwordCourt;

    return output;
}
